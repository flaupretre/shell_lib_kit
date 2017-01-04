#
# Build script. Combine source files and replace variables in code.
#
#============================================================================

CMD=`basename $0`
cd `dirname $0`/../..
BASE_DIR=`/bin/pwd`
PPC_DIR=$BASE_DIR/ppc
SOFTWARE_VERSION="$1"
INSTALL_DIR="$2"

export BASE_DIR PPC_DIR SOFTWARE_VERSION INSTALL_DIR

. sysfunc
if ! sf_loaded 2>/dev/null ; then
	echo "** ERROR: Cannot load sysfunc library"
	exit 1
fi

#------------------------------------------------

function expand_vars
{
sed -e "s,%INSTALL_DIR%,$INSTALL_DIR,g" \
	-e "s,%SOFTWARE_VERSION%,$SOFTWARE_VERSION,g"
}

#==== MAIN ====

sf_create_dir $BASE_DIR/bin

expand_vars <$BASE_DIR/engine/bin/_main.sh >$BASE_DIR/bin/@SLK_LIBNAME@.sh
expand_vars <$BASE_DIR/engine/bin/set-shell.sh >$BASE_DIR/bin/set-shell.sh

#-- Create the files in the 'ppc' subdir

sf_create_dir $PPC_DIR

cd $BASE_DIR/src

for i in *.sh ; do
	[ -f "$i" ] || continue	# Handle case where dir is empty
	cat $i
	echo # force newline at EOF
done | expand_vars >$PPC_DIR/script.sh

#-- The end

sf_finish 0

###############################################################################
