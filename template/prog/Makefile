#
# Makefile
#
#============================================================================

SOFTWARE_NAME = @SLK_LIBNAME@

include config.mk

TGZ_PREFIX = $(SOFTWARE_NAME)-$(SOFTWARE_VERSION)
TGZ_FILE = $(TGZ_PREFIX).tar.gz

#=====================================

all: processed

.PHONY: processed clean tgz install all rpm

processed: processed/script.sh

processed/script.sh:
	chmod +x build/build.sh
	build/build.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

install: processed/script.sh
	chmod +x build/install.sh
	build/install.sh $(INSTALL_DIR)

specfile: specfile.in
	chmod +x build/mkspec.sh
	build/mkspec.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

tgz: $(TGZ_FILE)

$(TGZ_FILE): clean
	/bin/rm -rf /tmp/$(TGZ_PREFIX)
	mkdir /tmp/$(TGZ_PREFIX)
	tar cf - . | ( cd /tmp/$(TGZ_PREFIX) ; tar xpf - )
	( cd /tmp ; rm -rf $(TGZ_PREFIX)/.git ; tar cf - ./$(TGZ_PREFIX) ) | gzip >$(TGZ_FILE)
	/bin/rm -rf /tmp/$(TGZ_PREFIX)

rpm: tgz specfile
	chmod +x build/dist.sh
	rpmbuild -bb --define="_sourcedir `pwd`" --define="dist `build/dist.sh`" specfile
	
clean:
	/bin/rm -rf processed bin specfile $(TGZ_FILE)

#============================================================================
