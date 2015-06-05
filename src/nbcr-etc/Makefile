REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

build:

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/cron.monthly
	install -m 755 root-mail-rotate $(ROOT)/$(PKGROOT)/cron.monthly

clean::
