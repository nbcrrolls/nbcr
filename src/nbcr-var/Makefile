REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

build:

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/sge 
	install -m 644 sge.php $(ROOT)/$(PKGROOT)/sge/index.php

clean::
