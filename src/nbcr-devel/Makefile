REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

SCRIPTS = NBCR.mk bootstrap-values.sh

build:

install::
	/bin/mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(INSTALL) -m 644 $(SCRIPTS) $(ROOT)/$(PKGROOT)/

clean::
