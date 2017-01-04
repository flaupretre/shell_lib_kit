#
# This scripts generates an empty shell library
#
# Usage : genlib.sh [Target directory]
#
# By security, the target directory must not exist when the script is launched.
#
# The following environment variables will be used if set:
#
#	- SLK_PREFIX: Function prefix (without '_')
#	- SLK_LIBNAME: Library name (ex: saplib, dblib)
#	- SLK_OWNER: Library owner
#	- SLK_INSTALL_DIR: Installation directory
#
#============================================================================

function expand_vars
{
sed \
	-e "s,@SLK_VERSION@,$SLK_VERSION,g" \
	-e "s,@SLK_PREFIX@,$SLK_PREFIX,g" \
	-e "s,@SLK_LIBNAME@,$SLK_LIBNAME,g" \
	-e "s,@SLK_LIBNAME_UC@,$SLK_LIBNAME_UC,g" \
	-e "s,@SLK_OWNER@,$SLK_OWNER,g" \
	-e "s,@SLK_INSTALL_DIR@,$SLK_INSTALL_DIR,g"
}

#--------------- MAIN ----------------

#-- Load sysfunc

. sysfunc
if ! sf_loaded 2>/dev/null ; then
	echo "ERROR: Sysfunc software not found - Aborting"
	exit 1
fi

#-- Validate target dir

if [ -n "$1" ]; then
	target="$1"
else
	target=`sf_ask 'Target directory : '`
fi

parent=`dirname $target`
[ -e "$parent" ] || sf_fatal "Directory $parent should exist"
parent=`sf_file_realpath $parent`
SLK_TARGET_DIR=$parent/`basename $target`
[ -e "$SLK_TARGET_DIR" ] && sf_fatal "Directory $SLK_TARGET_DIR must not exist"

export SLK_TARGET_DIR

#-- Get SLK base directory and version

dir=`dirname $0`
SLK_BASE=`sf_file_realpath $dir`
[ -f "$SLK_BASE/config.sh" ] || sf_fatal "$SLK_BASE: Invalid SLK base directory"
. $SLK_BASE/config.sh

export SLK_BASE SLK_VERSION

#-- Get other variables

[ -z "$SLK_PREFIX"      ] && SLK_PREFIX=`sf_ask 'Function prefix (without trailing _) : '`
[ -z "$SLK_LIBNAME"     ] && SLK_LIBNAME=`sf_ask 'Library name : '`
[ -z "$SLK_OWNER"       ] && SLK_OWNER=`sf_ask 'Library owner : '`
[ -z "$SLK_INSTALL_DIR" ] && SLK_INSTALL_DIR=`sf_ask 'Install directory : '`

SLK_LIBNAME_UC=`echo $SLK_LIBNAME | tr '[:lower:]' '[:upper:]'`

export SLK_PREFIX SLK_LIBNAME SLK_LIBNAME_UC SLK_OWNER SLK_INSTALL_DIR

#--------------
# Create library

sf_msg "Generating library..."

cd $SLK_BASE/template
cp -rp . $SLK_TARGET_DIR

tfile=`sf_tmpfile`
for path in `find . -type f`
	do
	expand_vars <$path >$SLK_TARGET_DIR/$path
	sf_chmod `sf_file_mode $path` $SLK_TARGET_DIR/$path
done

mv $SLK_TARGET_DIR/prog/src/dummy.sh $SLK_TARGET_DIR/prog/src/${SLK_PREFIX}_dummy.sh

#--------------

sf_msg "Library creation OK"
echo
sf_msg "Note: Remember to delete the example source file ($SLK_TARGET_DIR/prog/src/${SLK_PREFIX}_dummy.sh) when you don't need it anymore..."

sf_finish 0

