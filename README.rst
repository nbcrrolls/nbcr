.. hightlight:: rst

NBCR roll
============

This roll places NBCR-specific files required for NBCR rolls
developemnt and for user enviornment.

**Building**

To build the roll, execute : ::

    # make 2>&1 | tee make.log

A successful build will create the file ``nbcr*.disk1.iso``.  


**Installation**

To install, execute: ::

    # rocks add roll *.iso
    # rocks enable roll nbcr
    # (cd /export/rocks/install; rocks create distro)
    # rocks run roll nbcr | bash


**What is installed**

Development and user-related scripts are installed in : ::

    /opt/nbcr/bin/ 
    /opt/nbcr/sbin/ 
    /opt/nbcr/lib/ 
    /opt/nbcr/devel/NBCR.mk
    /opt/modulefiles/applications/ - directory for applications environment modules
    /etc/profile.d/nbcr.[sh,csh] - environment profiles

