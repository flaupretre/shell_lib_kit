
PPC_DIR=../../../ppc/public

TARGETS = Function-reference.md

#-----------------

.PHONY: clean install

all: $(TARGETS)

clean:
	/bin/rm -rf $(TARGETS) doc.tmp

#----------------
# Ignores functions starting with '_', sort functions

Function-reference.md:
	cat ../src/scripts/@SLK_PREFIX@_*.sh >doc.tmp
	$(PPC_DIR)/mk_sh_doc.sh doc.tmp "$@" md -e '_' -s
	/bin/rm -f doc.tmp

#----------------
