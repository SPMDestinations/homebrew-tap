# Makefile
#
# Created by Helge Heß
# Copyright © 2020 ZeeZide GmbH. All rights reserved.

prefix=/usr/local

PLATFORM=x86_64-apple-darwin
VERSION=8.0.0
DESTDIR_PREFIX=$(prefix)/lib/swift/clang-llvm/$(PLATFORM)
DESTDIR=$(DESTDIR_PREFIX)/$(VERSION)
CURRENT_LINK=$(DESTDIR_PREFIX)/current
MKDIR=mkdir
CP=cp
LN_S=ln -s

# -p preserve attributes
# -P do not follow symbolic links
# -R recursive
# -c use clonefile
CP_OPTS=-pPRc

BINDIRS=bin include lib libexec share

all:
	echo "Nothing to do, all prebuilt"

install:
	$(MKDIR) -p $(DESTDIR)
	$(CP) $(CP_OPTS) $(BINDIRS) $(DESTDIR)
	$(LN_S) $(DESTDIR) $(CURRENT_LINK)

# FIXME: only delete current link if it matches!
# TODO:  delete dir if empty
uninstall:
	rm -rf $(DESTDIR)
	rm $(CURRENT_LINK)
