REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

build:

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	install -m 755 nbcr.*sh $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(ROOT)/opt/modulefiles/applications

clean::
