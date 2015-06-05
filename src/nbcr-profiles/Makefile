REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

MODULESFILES = $(GNUNAME).module $(GNUNAME).version

ADDSED = -e s%@GNUVERSION@%$(GNUVERSION)%g 

%: %.in
	$(SED) $(SEDSCRIPT) $(ADDSED)  $^ > $@

build: $(MODULESFILES)

install::
	mkdir -p -m 755 $(ROOT)/etc/profile.d
	install -m 755 nbcr.*sh $(ROOT)/etc/profile.d
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/applications
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/compilers/$(GNUNAME)
	install -m 644 gnu.module $(ROOT)/$(PKGROOT)/compilers/$(GNUNAME)/$(GNUVERSION)
	install -m 644 gnu.version $(ROOT)/$(PKGROOT)/compilers/$(GNUNAME)/.version.$(GNUVERSION)
	ln -s $(PKGROOT)/compilers/$(GNUNAME)/.version.$(GNUVERSION) $(ROOT)/$(PKGROOT)/compilers/$(GNUNAME)/.version

clean::
	rm -rf $(MODULESFILES)
