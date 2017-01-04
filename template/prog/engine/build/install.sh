#
# Install script. Create target tree and move pre-built files there.
#
#============================================================================

# $INSTALL_ROOT variable can be set by the calling environment and is optional.
# If not set, everything will be installed relative to '/'.

#----------

CMD=`basename $0`
cd `dirname $0`/../..
BASE_DIR=`/bin/pwd`

INSTALL_TARGET_DIR="$1"
INSTALL_DIR="$INSTALL_ROOT$1"

export BASE_DIR INSTALL_DIR

. sysfunc
if ! sf_loaded 2>/dev/null ; then
	echo "** ERROR: Cannot load sysfunc library"
	exit 1
fi

cd $BASE_DIR

#-- Re-create target tree and copy base files

sf_delete $INSTALL_DIR
sf_create_dir $INSTALL_DIR root 555

sf_create_dir $INSTALL_DIR/bin root 555
for i in bin/* ; do
	[ -f "$i" ] || continue	# Handle case where dir is empty
	sf_check_copy $i $INSTALL_DIR/$i 555
done

sf_check_link $INSTALL_TARGET_DIR/bin/@SLK_LIBNAME@.sh $INSTALL_ROOT/usr/bin/@SLK_LIBNAME@

$INSTALL_DIR/bin/set-shell.sh # Determine shell to use

sf_create_dir $INSTALL_DIR/ppc root 555
for i in ppc/* ; do
	[ -f "$i" ] || continue	# Handle case where dir is empty
	sf_check_copy $i $INSTALL_DIR/$i 444
done

sf_finish 0

###############################################################################
