#
#=============================================================================
#                              WARNING !
#
# The content of the 'doc' subdirectory is entirely generated from the @SLK_LIBNAME@ code.
# Any change in this directory will be lost during the next doc generation.
#
# In order to generate the documentation, you will need the PPC
# utility, available from https://github.com/flaupretre/ppc. Change the PPC_DIR
# variable to reflect the location where it was downloaded. You will also need
# a PHP CLI interpreter, generally available as part of a 'php-cli' package or
# contained in every PHP distribution. Requires PHP version 5.0 or more.
#=============================================================================

PPC_DIR=../../ppc/public

TARGETS = doc

PHP = php

#-----------------

.PHONY: clean doc clean_doc

all: $(TARGETS)

clean: clean_doc

#----------------
# Ignores functions starting with '_', sort functions, clear '@SLK_PREFIX@_' prefix,

clean_doc:
	/bin/rm -rf doc

doc:
	$(MAKE) clean_doc
	mkdir ./doc
	$(PHP) $(PPC_DIR)/shell_doc.php -f gfm -e '_' -c @SLK_PREFIX@_ -o ./doc -S -p ./main_header.md -s ./main_footer.md -H ./header.md -F ./footer.md ../prog/src/*.sh
