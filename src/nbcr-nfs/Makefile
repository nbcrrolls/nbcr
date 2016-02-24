REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

build:

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	install -m 755 bin/*  $(ROOT)/$(PKGROOT)/bin
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/info
	install -m 644 info/*  $(ROOT)/$(PKGROOT)/info

clean::
