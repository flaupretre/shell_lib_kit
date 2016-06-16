#
# This scripts generates an empty shell library
#
# Usage : genlib.sh <Target directory>
#
# By security, the target directory must not exist when the script is launched.
#
# The following environment variables must be set:
#
#	- SLK_PREFIX: Function profix (without '_')
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

if [ $# != 1 -o -z "$1" ]; then
	sf_fatal "Usage : $0 <Target directory>"
fi

parent=`dirname $1`
[ -e "$parent" ] || sf_fatal "Directory $parent should exist"
parent=`sf_file_realpath $parent`
SLK_TARGET_DIR=$parent/`basename $1`
[ -e "$SLK_TARGET_DIR" ] && sf_fatal "Directory $SLK_TARGET_DIR must not exist"

export SLK_TARGET_DIR

#-- Get SLK base directory and version

dir=`dirname $0`
SLK_BASE=`sf_file_realpath $dir`
[ -f "$SLK_BASE/config.sh" ] || sf_fatal "$SLK_BASE: Invalid SLK base directory"
. $SLK_BASE/config.sh

export SLK_BASE SLK_VERSION

# Check other variables

[ -n "$SLK_PREFIX" ] || sf_fatal "SLK_PREFIX variable should be set"
[ -n "$SLK_LIBNAME" ] || sf_fatal "SLK_LIBNAME variable should be set"
[ -n "$SLK_OWNER" ] || sf_fatal "SLK_OWNER variable should be set"
[ -n "$SLK_INSTALL_DIR" ] || sf_fatal "SLK_INSTALL_DIR variable should be set"

SLK_LIBNAME_UC=`echo $SLK_LIBNAME | tr '[:lower:]' '[:upper:]'`

export SLK_PREFIX SLK_LIBNAME SLK_LIBNAME_UC SLK_OWNER SLK_INSTALL_DIR

#--------------
# Create library

cd $SLK_BASE/template
cp -rp . $SLK_TARGET_DIR

tfile=`sf_tmpfile`
for path in `find . -type f`
	do
	expand_vars <$path >$SLK_TARGET_DIR/$path
	sf_chmod `sf_file_mode $path` $SLK_TARGET_DIR/$path
done

mv $SLK_TARGET_DIR/prog/src/bin/_main.sh $SLK_TARGET_DIR/prog/src/bin/$SLK_LIBNAME.sh

#--------------

sf_msg "Library creation OK"
sf_finish 0

