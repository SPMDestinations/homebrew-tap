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

TARGET=x86_64-unknown-linux
ARCH=x86_64
PLATFORM=ubuntu16.04
PACKAGE_URL=https://swift.org/builds/$(BRANCH)/$(subst .,,$(PLATFORM))/swift-$(VERSION)-$(SNAPSHOT)/swift-$(VERSION)-$(SNAPSHOT)-$(PLATFORM).tar.gz
	
BUILD_DIR=.build
FETCH_DIR=.fetch

DESTDIR_PREFIX=$(prefix)/lib/swift/sdks/
PACKAGE_FETCH_FILENAME=swift-$(VERSION)-$(PLATFORM).tar.gz
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)

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


retrieve-packages:
	./retrieve-sdk-packages.sh

build-toolchain: $(PACKAGE_FETCH_FILE)
	SWIFT_VERSION=$(VERSION) ./build-toolchain.sh $(PWD)/.fetch/swift-$(VERSION)-$(PLATFORM).tar.gz

testbuild:
	rm -rf my-test-app
	mkdir -p my-test-app && cd my-test-app && swift package init --type=executable
	cd my-test-app && swift build --destination ../$(BUILD_DIR)/swift-$(VERSION)-$(PLATFORM).xtoolchain/destination.json

DOCKER_IMAGE=swiftlang/swift:nightly-5.3-xenial

testbuild-run:
	docker run --rm -t 		\
		--name test-x-build \
		--volume "${PWD}/my-test-app/.build/debug:/run" \
		--workdir "/run" 		\
		$(DOCKER_IMAGE) 		\
		./my-test-app
