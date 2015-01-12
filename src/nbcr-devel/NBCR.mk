# variables, targets etc that are common for NBCR rolls

ifndef __NBCR_MK
__NBCR_MK = yes

SEDROLLOPT = \
	  -e "s%COMPILERNAME%$(COMPILERNAME)%g" \
	  -e "s%MPINAME%$(ROLLCOMPILER)%g" \
	  -e "s%ROLLCOMPILER%$(ROLLCOMPILER)%g" \
	  -e "s%ROLLMPI%$(ROLLMPI)%g" \
	  -e "s%ROLLOPTS%$(ROLLOPTS)%g" \
	  -e "s%ROLLPY%$(ROLLPY)%g" \
	  -e "s%VERSION%$(VERSION)%g" 

roll-test-install:
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	cp *.t $(ROOT)/$(PKGROOT)/
	$(SED) -i $(SEDROLLOPT) $(ROOT)/$(PKGROOT)/*.t

modulefile-install:
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	for V in $(VERSION) $(EXTRA_MODULE_VERSIONS); do \
	  cp *.module $(ROOT)/$(PKGROOT)/$$V; \
	  cp *.version $(ROOT)/$(PKGROOT)/.version.$$V; \
	  $(SED) -i  $(SEDROLLOPT) -e "s%VERSION%$(V)%g"  $(ROOT)/$(PKGROOT)/.version.$$V $(ROOT)/$(PKGROOT)/$$V; \
	done
	ln -s $(PKGROOT)/.version.$(VERSION) $(ROOT)/$(PKGROOT)/.version


TAR.CMD                 = $(shell which tar)
TGZ.OPTS                = -xzf
TBZ2.OPTS               = -xjf
UNZIP.CMD               = $(shell which unzip)
UNZIP.OPTS              = -q

# ALL packages are part of SRC_PKGS
SRC_PKGS = $(TAR_GZ_PKGS) $(TAR_BZ2_PKGS) $(TGZ_PKGS) $(ZIP_PKGS)

# For cleanup convert that package archive names into directory names.
# This can likely be 'generalized' with a variable I don't know yet...
TAR_GZ_DIRS = $(TAR_GZ_PKGS:%.tar.gz=%)
TAR_BZ2_DIRS = $(TAR_BZ2_PKGS:%.tar.bz2=%)
TGZ_DIRS = $(TGZ_PKGS:%.tgz=%)
ZIP_DIRS = $(ZIP_PKGS:%.zip=%)

# unpack archives 
$(TAR_GZ_DIRS): $(TAR_GZ_PKGS)
	@echo "::: Unbundling $@.tar.gz :::"
	@$(TAR.CMD) $(TGZ.OPTS) $@.tar.gz
	@echo ""

$(TAR_BZ2_DIRS): $(TAR_BZ2_PKGS)
	@echo "::: Unbundling $@.tar.bz2 :::"
	@$(TAR.CMD) $(TBZ2.OPTS) $@.tar.bz2
	@echo ""

$(TGZ_DIRS): $(TGZ_PKGS)
	@echo "::: Unbundling $@.tgz :::"
	@$(TAR.CMD) $(TGZ.OPTS) $@.tgz
	@echo ""

$(ZIP_DIRS): $(ZIP_PKGS)
	@echo "::: Unbundling $@.zip :::"
	@$(UNZIP.CMD) $(UNZIP.OPTS) $@.zip
	@echo ""

# SRC_DIRS is build target 
SRC_DIRS = $(TAR_GZ_DIRS) $(TAR_BZ2_DIRS) $(TGZ_DIRS) $(ZIP_DIRS)

endif # __NBCR_MK

