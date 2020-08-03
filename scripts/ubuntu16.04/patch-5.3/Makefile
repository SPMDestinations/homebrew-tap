# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

prefix=/usr/local

DESTINATION_PREFIX=/usr/local
REL_INSTALL_PATH=lib/swift/destinations

VERSION=5.3
BRANCH=swift-$(VERSION)-branch
SNAPSHOT=DEVELOPMENT-SNAPSHOT-2020-07-31-a

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

APT_DISTRIBUTION_NAME=xenial
APT_PLATFORM=amd64
APT_REPOSITORY_URL=http://de.archive.ubuntu.com/ubuntu
APT_PACKAGES_FILE_URL=$(APT_REPOSITORY_URL)/dists/$(APT_DISTRIBUTION_NAME)/main/binary-$(APT_PLATFORM)/Packages.gz

PACKAGE_NAMES = \
	libc6-dev linux-libc-dev libicu55 libgcc-5-dev libicu-dev \
	libc6 libgcc1 libstdc++-5-dev libstdc++6 zlib1g-dev \
	libpq5 libpq-dev libedit2 libedit-dev libsqlite3-dev \
	libxml2 libxml2-dev libncurses5 libncurses5-dev \
	libcurl4 libcurl4-openssl-dev libssl1.1 libssl-dev

MKDIR=mkdir
CP=cp
LN_S=ln -s

all: retrieve-packages build-toolchain

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
