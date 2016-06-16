#
# Build script. Combine source files and replace variables in code.
#
#============================================================================

CMD=`basename $0`
cd `dirname $0`/..
BASE_DIR=`/bin/pwd`
PROCESSED_DIR=$BASE_DIR/processed
SOFTWARE_VERSION="$1"
INSTALL_DIR="$2"

export BASE_DIR PROCESSED_DIR SOFTWARE_VERSION INSTALL_DIR

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
for i in $BASE_DIR/src/bin/* ; do
	expand_vars <$i >$BASE_DIR/bin/`basename $i`
done

#-- Create the files in the 'processed' subdir

sf_create_dir $PROCESSED_DIR

cd $BASE_DIR/src/scripts

for i in *.sh ; do
	[ -f "$i" ] || continue	# Handle case where dir is empty
	cat $i
	echo # force newline at EOF
done | expand_vars >$PROCESSED_DIR/script.sh

#-- The end

sf_finish 0

###############################################################################
