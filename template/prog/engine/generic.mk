#
# Generic Makefile
# Must be included from the root Makefile after vars.mk and config.mk
#
#============================================================================

TGZ_PREFIX = $(SOFTWARE_NAME)-$(SOFTWARE_VERSION)
TGZ_FILE = $(TGZ_PREFIX).tar.gz
RPM_PATTERN=$(TGZ_PREFIX)-*.noarch.rpm

#=====================================

all: ppc

.PHONY: ppc clean tgz install all rpm test deploy

ppc: ppc/script.sh

ppc/script.sh:
	chmod +x engine/build/build.sh
	engine/build/build.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

install: ppc/script.sh
	chmod +x engine/build/install.sh
	engine/build/install.sh $(INSTALL_DIR)

specfile: specfile.in
	chmod +x engine/build/mkspec.sh
	engine/build/mkspec.sh "$(SOFTWARE_VERSION)" "$(INSTALL_DIR)"

tgz: $(TGZ_FILE)

$(TGZ_FILE): clean
	/bin/rm -rf /tmp/$(TGZ_PREFIX)
	mkdir /tmp/$(TGZ_PREFIX)
	tar cf - . | ( cd /tmp/$(TGZ_PREFIX) ; tar xpf - )
	( cd /tmp ; rm -rf $(TGZ_PREFIX)/.git ; tar cf - ./$(TGZ_PREFIX) ) | gzip >$(TGZ_FILE)
	/bin/rm -rf /tmp/$(TGZ_PREFIX)

rpm: tgz specfile
	/bin/rm -rf $(HOME)/rpmbuild/RPMS/noarch/$(RPM_PATTERN)
	rpmbuild -bb --define="_sourcedir `pwd`" --define="dist `sysfunc os_dist_macro`" specfile
	mv -f $(HOME)/rpmbuild/RPMS/noarch/$(RPM_PATTERN) .
	/bin/rm -rf $(HOME)/rpmbuild/BUILD/$(TGZ_PREFIX)

test:
	chmod +x engine/ci/run.sh
	engine/ci/run.sh $@ $(TEST_ARGS)

deploy:
	chmod +x engine/ci/run.sh
	engine/ci/run.sh $@ $(DEPLOY_ARGS)

clean:
	/bin/rm -rf ppc bin specfile $(TGZ_FILE) $(RPM_PATTERN)

#============================================================================
