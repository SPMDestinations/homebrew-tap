#!/bin/bash
#
# Based on
#     - https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain

# by Johannes Weiß
# Adjustments by Helge Heß <me@helgehess.eu>

# This script fetches the packages from the upstream Linux distribution.

BUILD_DIR=${PWD}/.build
FETCH_DIR=${PWD}/.fetch

set -eu

export PATH="/bin:/usr/bin"

# set -xv

# config
linux_sdk_name="ubuntu-xenial.sdk"
ubuntu_mirror="http://gb.archive.ubuntu.com/ubuntu"
packages_file="$ubuntu_mirror/dists/xenial/main/binary-amd64/Packages.gz"
pkg_names=( libc6-dev linux-libc-dev libicu55 libgcc-5-dev libicu-dev libc6 libgcc1 libstdc++-5-dev libstdc++6 zlib1g-dev libpq5 libpq-dev libedit2 libedit-dev libsqlite3-dev libxml2 libxml2-dev libncurses5 libncurses5-dev libcurl4 libcurl4-openssl-dev libssl1.1 libssl-dev)
pkgs=()


# ******************* Helper Functions *****************************

# url
function download_stdout() {
    curl --fail -s "$1"
}

# url, key
function download_with_cache() {
    mkdir -p "${FETCH_DIR}"
    local out
    out="${FETCH_DIR}/$2"
    if [[ ! -f "$out" ]]; then
        curl --fail -s -o "$out" "$1"
    fi
    echo "$out"
}


# dst, file
function unpack_rpm() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_rpm_XXXXXX)
    (
      cd "$tmp"
      tar -C "$1" -xf $2
    )
    rm -rf "$tmp"
}
# dst, file
function unpack_deb() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_deb_XXXXXX)
    (
    cd "$tmp"
    ar -x "$2"
    tar -C "$1" -xf data.tar.*
    )
    rm -rf "$tmp"
}

# dst, file
function unpack() {
    ext=${2##*.}
    "unpack_$ext" "$@"
}


# ******************* Switch to target directory *******************

rm -rf   "${BUILD_DIR}/${linux_sdk_name}"
mkdir -p "${BUILD_DIR}/${linux_sdk_name}"

# This is downloading the packages in `pkg_names`,
# first ist fetchs the packages file.
# weissi: Oopsie, this is slow but seemingly fast enough :)
while read -r line; do
    for pkg_name in "${pkg_names[@]}"; do
        if [[ "$line" =~ ^Filename:\ (.*\/([^/_]+)_.*$) ]]; then
            # echo "${BASH_REMATCH[2]}"
            if [[ "${BASH_REMATCH[2]}" == "$pkg_name" ]]; then
                new_pkg="$ubuntu_mirror/${BASH_REMATCH[1]}"
                pkgs+=( "$new_pkg" )
                echo "- will download $new_pkg"
            fi
        fi
    done
done < <(download_stdout "$packages_file" | gunzip -d -c | grep ^Filename:)

# Loop over the packages we want to fetch, and unpack them
tmp=$(mktemp -d "${BUILD_DIR}/tmp_pkgs_XXXXXX")
(
cd "$tmp"
for f in "${pkgs[@]}"; do
    name="$(basename "$f")"
    archive="$(download_with_cache "$f" "$name")"
    unpack "${BUILD_DIR}/$linux_sdk_name" "$archive"
done
)
rm -rf "$tmp"

(
cd $BUILD_DIR

# fix absolute symlinks
find "$linux_sdk_name" -type l | while read -r line; do
    dst=$(readlink "$line")
    if [[ "${dst:0:1}" = / ]]; then
        rm "$line"
        fixedlink=$(echo "./$(dirname "${line#${linux_sdk_name}/}")" | sed 's:/[^/]*:/..:g')"${dst}"
        echo ln -s "${fixedlink#./}" "${line#./}"
        ln -s "${fixedlink#./}" "${line#./}"
    fi
done
ln -s 5 "$linux_sdk_name/usr/lib/gcc/x86_64-linux-gnu/5.4.0"

)
