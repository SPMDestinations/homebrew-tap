# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

prefix=/usr/local

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

DESTDIR_PREFIX=$(prefix)/lib/swift/sdks/
PACKAGE_FETCH_FILENAME=swift-$(VERSION)-$(PLATFORM).tar.gz
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)

APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/xenial/main/binary-amd64/Packages.gz

MKDIR=mkdir
CP=cp
LN_S=ln -s
PGK_FETCHER=curl -L

all: $(PACKAGE_FETCH_FILE)
	echo "make retrieve-packages"
	echo "make build-toolchain"
	echo "testbuild"

$(PACKAGE_FETCH_FILE):
	$(MKDIR) -p $(FETCH_DIR)
	(if ! test -f $@; then $(PGK_FETCHER) -o $@ $(PACKAGE_URL); fi)

install:
	echo TODO
	exit 42

clean:
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -rf $(FETCH_DIR)


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
	TARGET_TRIPLE=$(LINUX_TARGET_TRIPLE)		\
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
	