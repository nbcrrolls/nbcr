# A collection of make targets, variables and macros for making rolls. 
# Based on SDSC's  base roll.
#

ifndef __NBCR_MK
__NBCR_MK = yes

CC = gcc
CXX = g++
F77 = gfortran
FC = gfortran
ifeq ("$(COMPILERNAME)", "intel")
  CC = icc
  CXX = icpc
  F77 = ifort
  FC = ifort
else ifeq ("$(COMPILERNAME)", "pgi")
  CC = pgcc
  CXX = pgCC
  F77 = pgf77
  FC = pgf90
endif

BIND_MOUNT = mkdir -p -m 755 $(1) || true; mount --bind $(2) $(1)
BIND_UMOUNT = umount $(1); rmdir -p $(1) || true

CHECK_LICENSE_FILES = \
  for F in `find license-files -mindepth 1 -type f`; do \
    echo Checking $$F for changes; \
    /usr/bin/cmp $$F `echo $$F | sed 's/license-files/$(SOURCE_DIR)/'` || exit 2; \
  done

DESCRIBE_CC = echo built with $(CC) $(call GET_EXE_VERSION, $(CC))
DESCRIBE_CXX = echo built with $(CXX) $(call GET_EXE_VERSION, $(CXX))
DESCRIBE_F77 = echo built with $(F77) $(call GET_EXE_VERSION, $(F77))
DESCRIBE_FC = echo built with $(FC) $(call GET_EXE_VERSION, $(FC))
DESCRIBE_PYTHON = echo built with python $(call GET_EXE_VERSION, python)

DESCRIBE_PKG = echo $(NAME) $(VERSION)

DESCRIBE_MPI = echo built with $(ROLLMPI) $(call GET_MODULE_VERSION, $(ROLLMPI))
DESCRIBE_CUDA = echo built with cuda $(call GET_MODULE_VERSION, cuda)
DESCRIBE_MKL = echo built with mkl $(call GET_MODULE_VERSION, mkl)

# Macro to extract the version from running $(1) with --version
GET_EXE_VERSION = \
  `$(1) --version 2>&1 | perl -ne 'print($$1) and exit if m/(\d+(\.\d+)*)/'`

# Macro to extract the version from the whatis text of modulefile $(1)
GET_MODULE_VERSION = \
  `module display $(1) 2>&1 | perl -ne 'print($$1) and exit if m/version\D*(\d+(\.\d+)*)/i'`

INSTALL_LICENSE_FILES = \
  mkdir -p -m 755 $(ROOT)/$(PKGROOT)/license-info/$(NAME); \
  cp -r license-files/* $(ROOT)/$(PKGROOT)/license-info/$(NAME)/

MODULE_LOAD_COMPILER = \
  module load $(1) || true; \
  echo === Compiler and version ===; \
  $(2) --version

MODULE_LOAD_PACKAGE = \
  module load $(1) || true; \
  echo === $(2) ===; \
  echo $${$(strip $(2))}

MODULE_LOAD_CC = $(call MODULE_LOAD_COMPILER, $(ROLLCOMPILER), $(CC))
MODULE_LOAD_CXX = $(call MODULE_LOAD_COMPILER, $(ROLLCOMPILER), $(CXX))
MODULE_LOAD_F77 = $(call MODULE_LOAD_COMPILER, $(ROLLCOMPILER), $(F77))
MODULE_LOAD_FC = $(call MODULE_LOAD_COMPILER, $(ROLLCOMPILER), $(FC))

MODULE_LOAD_MPI = $(call MODULE_LOAD_PACKAGE, $(ROLLMPI), MPIHOME)
MODULE_LOAD_OPENMPI = $(call MODULE_LOAD_PACKAGE, $(ROLLMPI)-$(ROLLCOMPILER)-$(ROLLNETWORK), MPIHOME)
MODULE_LOAD_CUDA = $(call MODULE_LOAD_PACKAGE, cuda, CUDAHOME)
MODULE_LOAD_MKL = $(call MODULE_LOAD_PACKAGE, mkl, MKLHOME)

PKGROOT_BIND_MOUNT = $(call BIND_MOUNT, $(PKGROOT), $(ROOT)/$(PKGROOT))
PKGROOT_BIND_UMOUNT = $(call BIND_UMOUNT, $(PKGROOT))

SEDROLLOPT = \
	  -e "s%COMPILERNAME%$(COMPILERNAME)%g" \
	  -e "s%MPINAME%$(ROLLCOMPILER)%g" \
	  -e "s%ROLLCOMPILER%$(ROLLCOMPILER)%g" \
	  -e "s%ROLLMPI%$(ROLLMPI)%g" \
	  -e "s%ROLLOPTS%$(ROLLOPTS)%g" \
	  -e "s%ROLLNETWORK%$(ROLLNETWORK)%g" \
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
	  $(SED) -i $(SEDROLLOPT) -e "s%VERSION%$(V)%g"  $(ROOT)/$(PKGROOT)/.version.$$V $(ROOT)/$(PKGROOT)/$$V; \
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

