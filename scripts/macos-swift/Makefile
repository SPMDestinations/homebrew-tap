# Makefile
#
# Based on
#     - https://github.com/apple/swift-package-manager/blob/master/Utilities/build_ubuntu_cross_compilation_toolchain
#
# by Johannes Weiß
# Adjustments by Helge Heß <me@helgehess.eu>

prefix=/usr/local

#VERSION=5.2.4
#BRANCH=swift-$(VERSION)-release
#SNAPSHOT=RELEASE
VERSION=5.3
BRANCH=swift-$(VERSION)-branch
SNAPSHOT=DEVELOPMENT-SNAPSHOT-2020-07-31-a

BUILD_DIR=.build
FETCH_DIR=.fetch
PACKAGE_FETCH_FILENAME=swift-$(VERSION).pkg.xar
PACKAGE_FETCH_FILE=$(FETCH_DIR)/$(PACKAGE_FETCH_FILENAME)
DESTDIR_PREFIX=$(prefix)/lib/swift/toolchains/osx
DESTDIR=$(DESTDIR_PREFIX)/$(VERSION)
CURRENT_LINK=$(DESTDIR_PREFIX)/current
MKDIR=mkdir
CP=cp
LN_S=ln -s
PKG_UNPACKER=xar -xf
PGK_FETCHER=curl -L
	
# -p preserve attributes
# -P do not follow symbolic links
# -R recursive
# -c use clonefile
CP_OPTS=-pPRc

BINDIRS=bin include lib libexec share

all: unpack-package
	
unpack-package: $(PACKAGE_FETCH_FILE)
	@echo "Unpacking toolchain pkg .."
	@$(MKDIR) -p $(BUILD_DIR)
	(cd $(BUILD_DIR);\
	 $(PKG_UNPACKER) ../$(PACKAGE_FETCH_FILE);\
	 $(MKDIR) -p swift.xctoolchain; cd swift.xctoolchain;\
	 cat ../*.pkg/Payload | gunzip -dc | cpio -i )
	@echo "Toolchain unpacked."

$(PACKAGE_FETCH_FILE):
	$(MKDIR) -p $(FETCH_DIR)
	(if ! test -f $@; then \
	 $(PGK_FETCHER) -o $@ https://swift.org/builds/$(BRANCH)/xcode/swift-$(VERSION)-$(SNAPSHOT)/swift-$(VERSION)-$(SNAPSHOT)-osx.pkg;\
	 fi)
	
clean:
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -rf $(FETCH_DIR)

install:
	$(MKDIR) -p $(DESTDIR)
	$(CP) $(CP_OPTS) $(BINDIRS) $(DESTDIR)
	$(LN_S) $(DESTDIR) $(CURRENT_LINK)

# FIXME: only delete current link if it matches!
# TODO:  delete dir if empty
uninstall:
	rm -rf $(DESTDIR)
	rm $(CURRENT_LINK)

