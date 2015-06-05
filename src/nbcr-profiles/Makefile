REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

MODULESFILES = $(GNUNAME).module $(GNUNAME).version
MODULESDIR = /opt/modulefiles

ADDSED = -e s%@GNUVERSION@%$(GNUVERSION)%g 

%: %.in
	$(SED) $(SEDSCRIPT) $(ADDSED)  $^ > $@

build: $(MODULESFILES)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	install -m 755 nbcr.*sh $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(ROOT)/$(MODULESDIR)/applications
	mkdir -p -m 755 $(ROOT)/$(MODULESDIR)/compilers/$(GNUNAME)
	install -m 644 gnu.module $(ROOT)/$(MODULESDIR)/compilers/$(GNUNAME)/$(GNUVERSION)
	install -m 644 gnu.version $(ROOT)/$(MODULESDIR)/compilers/$(GNUNAME)/.version.$(GNUVERSION)
	ln -s $(MODULESDIR)/compilers/$(GNUNAME)/.version.$(GNUVERSION) $(ROOT)/$(MODULESDIR)/compilers/$(GNUNAME)/.version

clean::
	rm -rf $(MODULESFILES)
