# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

# This is a Makefile variant for direct consumption. Plus some extra stuff
# for testing purposes.

prefix=/usr/local
# This is required because we need to hardcode the destination.json to the
# actual location.
ACTUAL_DESTINATION_PREFIX=/usr/local

VERSION=5.3
BRANCH=swift-$(VERSION)-branch
SNAPSHOT=DEVELOPMENT-SNAPSHOT-2020-07-31-a
#VERSION=5.2.4
#BRANCH=swift-$(VERSION)-release
#SNAPSHOT=RELEASE

ARCH=x86_64
TARGET=$(ARCH)-unknown-linux
LINUX_TARGET_TRIPLE=$(ARCH)-linux-gnu
PLATFORM=ubuntu16.04
PACKAGE_URL=https://swift.org/builds/$(BRANCH)/$(subst .,,$(PLATFORM))/swift-$(VERSION)-$(SNAPSHOT)/swift-$(VERSION)-$(SNAPSHOT)-$(PLATFORM).tar.gz

BUILD_DIR=$(PWD)/.build
FETCH_DIR=$(PWD)/.fetch
PATCH_DIR=$(BUILD_DIR)/patch

DESTDIR_PREFIX=$(prefix)/lib/swift/dst/x86_64-unknown-linux/

PACKAGE_FETCH_FILENAME=swift-$(VERSION)-$(PLATFORM).tar.gz
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)

APT_DISTRIBUTION_NAME=xenial
APT_PLATFORM=amd64
APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/$(APT_DISTRIBUTION_NAME)/main/binary-$(APT_PLATFORM)/Packages.gz

MKDIR=mkdir
CP=cp
LN_S=ln -s
RM_RF=rm -rf
PGK_FETCHER=curl -L
DIRDIFF=diff -ruN

all: patch-5.3/build.patch
	
help:
	echo $(PACKAGE_URL)
	echo "make retrieve-packages"
	echo "make build-toolchain"
	echo "testbuild"

local-build: $(PACKAGE_FETCH_FILE) retrieve-packages build-toolchain

$(PACKAGE_FETCH_FILE):
	$(MKDIR) -p $(FETCH_DIR)
	(if ! test -f $@; then $(PGK_FETCHER) -o $@ $(PACKAGE_URL); fi)

install:
	echo TODO
	exit 42

clean:
	$(RM_RF) $(BUILD_DIR)

distclean: clean
	$(RM_RF) $(FETCH_DIR)
	
	
# patches

swift-5.3-patch: patch-5.3/build.patch
	
patch-5.3/build.patch: Makefile retrieve-sdk-packages.sh patch-5.3/build-toolchain.sh patch-5.3/Makefile
	$(RM_RF) $@
	$(RM_RF) $(PATCH_DIR)
	$(MKDIR) -p $(PATCH_DIR)/empty
	$(MKDIR) -p $(PATCH_DIR)/patched
	$(CP) -ac retrieve-sdk-packages.sh     $(PATCH_DIR)/patched/
	$(CP) -ac patch-5.3/build-toolchain.sh $(PATCH_DIR)/patched/
	$(CP) -ac patch-5.3/Makefile           $(PATCH_DIR)/patched/
	(cd $(PATCH_DIR); $(DIRDIFF) empty patched > $(PWD)/$@ ; [ $$? -eq 1 ])
	cat patch-5.3/build.patch | shasum -a 256

# package download

PACKAGE_NAMES = \
	libc6-dev linux-libc-dev libicu55 libgcc-5-dev libicu-dev \
	libc6 libgcc1 libstdc++-5-dev libstdc++6 zlib1g-dev \
	libpq5 libpq-dev libedit2 libedit-dev libsqlite3-dev \
	libxml2 libxml2-dev libncurses5 libncurses5-dev \
	libcurl4 libcurl4-openssl-dev libssl1.1 libssl-dev

retrieve-packages:
	BUILD_DIR=$(BUILD_DIR) FETCH_DIR=$(FETCH_DIR)	\
	TARGET_ARCH=$(ARCH)				\
	LINUX_TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)	\
	TARGET_PLATFORM=$(PLATFORM)			\
	TARGET_SDK_NAME=$(ARCH)-$(PLATFORM).sdk 	\
	APT_REPOSITORY_URL=$(APT_REPOSITORY_URL)	\
	APT_PACKAGES_FILE_URL=$(APT_PACKAGES_FILE_URL)	\
	./retrieve-sdk-packages.sh "$(PACKAGE_NAMES)"


# toolchain builder

build-toolchain: $(PACKAGE_FETCH_FILE)
	SWIFT_VERSION=$(VERSION) ./build-toolchain.sh $(PWD)/.fetch/swift-$(VERSION)-$(PLATFORM).tar.gz

testbuild:
	rm -rf my-test-app
	mkdir -p my-test-app && cd my-test-app && swift package init --type=executable
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(VERSION)-$(PLATFORM).xtoolchain/destination.json

test-rebuild:
	cd my-test-app && swift build --destination $(BUILD_DIR)/swift-$(VERSION)-$(PLATFORM).xtoolchain/destination.json

DOCKER_IMAGE=swiftlang/swift:nightly-5.3-xenial

# ld.so doesn't seem to be setup properly, ld.so.conf.d doesn't include
# the `/usr/lib/swift/linux`
testbuild-run:
	docker run --rm -t 		\
		--name test-x-build \
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash -c "LD_LIBRARY_PATH=/usr/lib/swift/linux ./my-test-app"

testbuild-bash:
	docker run --rm -it 		\
		--name test-x-build \
		--volume "$(PWD)/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		bash
	