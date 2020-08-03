#!/bin/bash
#
# Based on
#     - https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain

# by Johannes Weiß
# Adjustments by Helge Heß <me@helgehess.eu>

# Usage: $0 dest ubuntu-swift-pkg

set -eu

BUILD_DIR=${BUILD_DIR:=${PWD}/.build}
FETCH_DIR=${FETCH_DIR:=${PWD}/.fetch}
SWIFT_VERSION=${SWIFT_VERSION:=5.2}
TARGET_ARCH=${TARGET_ARCH:=x86_64}
TARGET_PLATFORM=${TARGET_PLATFORM:=ubuntu16.04}
CROSS_TOOLCHAIN_NAME=${CROSS_TOOLCHAIN_NAME:=swift-${SWIFT_VERSION}-${TARGET_PLATFORM}.xtoolchain}
HOST_PLATFORM=x86_64

# brew install swiftxcode/swiftxcode/swift-xctoolchain-5.2
# brew install swiftxcode/swiftxcode/clang-llvm-bin-8
# ./retrieve-sdk-packages.sh
HOST_SWIFT_TOOLCHAIN=/usr/local/lib/swift/xctoolchains/${HOST_PLATFORM}-apple-darwin/${SWIFT_VERSION}-current/swift.xctoolchain
HOST_X_LLD=/usr/local/lib/swift/clang-llvm/${HOST_PLATFORM}-apple-darwin/8.0.0/bin/lld
linux_sdk_name="${TARGET_ARCH}-${TARGET_PLATFORM}.sdk"
LINUX_SDK="${BUILD_DIR}/${linux_sdk_name}"

export PATH="/bin:/usr/bin"

#PGK is $3

function realpath() {
    if [[ "${1:0:1}" = / ]]; then
        echo "$1"
    else
        (
        cd "$(dirname "$1")"
        echo "$(pwd)/$(basename "$1")"
        )
    fi
}

function fix_glibc_modulemap() {
    local glc_mm
    local tmp
    local inc_dir

    glc_mm="$1"
    echo "glibc.modulemap at '$glc_mm'"
    test -f "$glc_mm"

    tmp=$(mktemp "$glc_mm"_orig_XXXXXX)
    inc_dir="$(dirname "$glc_mm")/private_includes"
    cat "$glc_mm" >> "$tmp"
    echo "Paths:"
    echo " - original glibc.modulemap: $tmp"
    echo " - new      glibc.modulemap: $glc_mm"
    echo " - private includes dir    : $inc_dir"
    echo -n > "$glc_mm"
    rm -rf "$inc_dir"
    mkdir "$inc_dir"
    cat "$tmp" | while IFS='' read line; do
        if [[ "$line" =~ ^(\ *header\ )\"\/+usr\/include\/(x86_64-linux-gnu\/)?([^\"]+)\" ]]; then
            local orig_inc
            local rel_repl_inc
            local repl_inc

            orig_inc="${BASH_REMATCH[3]}"
            rel_repl_inc="$(echo "$orig_inc" | tr / _)"
            repl_inc="$inc_dir/$rel_repl_inc"
            echo "${BASH_REMATCH[1]} \"$(basename "$inc_dir")/$rel_repl_inc\"" >> "$glc_mm"
            if [[ "$orig_inc" == "uuid/uuid.h" ]]; then
                # no idea why ;)
                echo "#include <linux/uuid.h>" >> "$repl_inc"
            else
                echo "#include <$orig_inc>" >> "$repl_inc"
            fi
            true
        else
            echo "$line" >> "$glc_mm"
        fi
    done
}

# set -xv # for debugging

# where to get stuff from
linux_swift_pkg=$(realpath "$1") # this is going to be automatic
test -f "$linux_swift_pkg"

# config
blocks_h_url="https://raw.githubusercontent.com/apple/swift-corelibs-libdispatch/master/src/BlocksRuntime/Block.h"

if ! test -d "${HOST_SWIFT_TOOLCHAIN}"; then
  echo "Missing host toolchain: ${HOST_SWIFT_TOOLCHAIN}"; exit 1
fi
if ! test -d "${LINUX_SDK}"; then
  echo "Missing Linux SDK: ${LINUX_SDK}"; exit 1
fi
if ! test -x "${HOST_X_LLD}"; then
  echo "Missing LLD: ${HOST_X_LLD}"; exit 1
fi


# ************************* HELPER ***********************

# url, key
function download_with_cache() {
    mkdir -p "$FETCH_DIR"
    local out
    out="$FETCH_DIR/$2"
    if [[ ! -f "$out" ]]; then
        curl --fail -s -o "$out" "$1"
    fi
    echo "$out"
}


# ************************* RUN **************************

echo "Cleaning existing chain ..."
rm -rf "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}"
mkdir -p "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}"

# clone-copy Linux SDK w/ the unpacked packages, we need to patch it later
echo "Cloning Linux SDK ${LINUX_SDK} ..."
cp -ac "${LINUX_SDK}" \
       "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/${linux_sdk_name}"

# clone-copy Swift Host SDK, we need to patch it later
echo "Cloning host Swift toolchain ${HOST_SWIFT_TOOLCHAIN} ..."
xc_tc_name="swift.xctoolchain"
cp -ac "${HOST_SWIFT_TOOLCHAIN}" \
       "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/${xc_tc_name}"

# Copy Linker (lld)
# TBD: If we use an absolute path in the json-declaration, we may not need
#      this, it copies the lld INTO the HOST Swift toolchain.
echo "Installing LLD into host toolchain: ${HOST_X_LLD} ..."
cp -ac "$HOST_X_LLD" "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/${xc_tc_name}/usr/bin/ld.lld"


# swift.xctoolchain/usr/lib/swift_static/linux
# swift.xctoolchain/usr/lib/swift/linux
echo "Coping in headers/libs from target Swift toolchain: ${linux_swift_pkg} ..."
(
# FIXME: just tar xvf over the right location
tmp=$(mktemp -d "${BUILD_DIR}/tmp_pkgs_XXXXXX")
tar -C "$tmp" --strip-components 1 -xf "$linux_swift_pkg"

echo "  .. Linux Swift libs/mods into host toolchain ..."
cp -ac "$tmp/usr/lib/swift/linux"          "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/lib/swift/linux"
mkdir -p "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/lib/swift_static"
cp -ac "$tmp/usr/lib/swift_static/linux"   "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/lib/swift_static/linux"

echo "  .. Linux Swift libs/mods into target toolchain ..."
mkdir -p "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/lib/swift"
mkdir -p "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/lib/swift_static"
cp -ac "$tmp/usr/lib/swift/linux"          "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/lib/swift/linux"
cp -ac "$tmp/usr/lib/swift_static/linux"   "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/lib/swift_static/linux"

echo "  .. Linux Swift libs/mods into host toolchain ..."
cp -ac "$tmp/usr/lib/swift/dispatch"       "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/include/dispatch"
cp -ac "$tmp/usr/lib/swift/CoreFoundation" "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/include/CoreFoundation"
cp -ac "$tmp/usr/lib/swift/os"             "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/include/os"
rm -rf "$tmp"

echo "  ok."
)


echo "Fetching/Installing Block.h ..."
curl --fail -s -o "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/include/Block.h" "$blocks_h_url"

if [ ! -e "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/bin/swift-autolink-extract" ]; then
  echo "Linking 'swift' to swift-autolink-extract ..."
  ln -s swift "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/bin/swift-autolink-extract"
fi


# TBD: does this have absolute links?
# fix up glibc modulemap
# TBD: weissi was patching the host compiler, we also(?) need to patch the
#      target (https://github.com/SPMDestinations/homebrew-tap/issues/1)
echo "Fixing glibc modulemap"
fix_glibc_modulemap "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/lib/swift/linux/x86_64/glibc.modulemap"
fix_glibc_modulemap "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name/usr/lib/swift/linux/x86_64/glibc.modulemap"

# FIXME: This needs to use absolute pathes?!
#        Hm, does Homebrew tell us the target prefix? We need to use this
# FIXME: the -sdk seems like a bug? but required
cat > "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/destination.json" <<EOF
{
    "version": 1,
    "sdk": "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name",
    "toolchain-bin-dir": "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/bin",
    "target": "x86_64-unknown-linux",
    "extra-cc-flags": [
        "-fPIC"
    ],
    "extra-swiftc-flags": [
        "-use-ld=lld", 
        "-tools-directory", "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$xc_tc_name/usr/bin",
        "-sdk", "${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}/$linux_sdk_name"
    ],
    "extra-cpp-flags": [
        "-lstdc++"
    ]
}
EOF

echo "done:"
echo "  ${BUILD_DIR}/${CROSS_TOOLCHAIN_NAME}"
