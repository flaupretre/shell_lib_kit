#!%INSTALL_DIR%/shell
#
# Main script. Can be executed or sourced (through '.'). If sourced, the library
# is loaded in the current shell environment.
#
#============================================================================

##----------------------------------------------------------------------------
# Checks if the library is already loaded
#
# Of course, if it can run, the library is loaded. So, it always returns 0.
# Allows to support the 'official' way to load @SLK_LIBNAME@ :
#	@SLK_PREFIX@_loaded 2>/dev/null || . @SLK_LIBNAME@
#
# Args: none
# Returns: Always 0
# Displays: Nothing
#----------------------------------------------------------------------------

function @SLK_PREFIX@_loaded
{
return 0
}

##----------------------------------------------------------------------------
# Displays library version
#
# Args: none
# Returns: Always 0
# Displays: Library version (string)
#-----------------------------------------------------------------------------

function @SLK_PREFIX@_version
{
echo "%SOFTWARE_VERSION%"
}

##----------------------------------------------------------------------------
# Displays help
#
# Args:
#	$*: Optional. Function names or substrings
# Returns: 0
# Displays: Usage if no arg, function doc(s) if arg(s) provided
#-----------------------------------------------------------------------------

function @SLK_PREFIX@_help
{
typeset has_run string func fline fstart nb

if [ $# = 0 ] ; then
	_@SLK_PREFIX@_usage
	return 0
fi

#---- Function help

for string ; do
	for func in `typeset -F | sed 's/^declare -f //' | grep '^@SLK_PREFIX@_' | sed 's/^@SLK_PREFIX@_//' | grep "$string"` ; do
		fline=`cat $_@SLK_LIBNAME_UC@_MAIN_SCRIPT $_@SLK_LIBNAME_UC@_SCRIPT_SH | grep -E -n "^function +@SLK_PREFIX@_$func\$" | head -1 | sed 's/:.*$//g'`
		[ -z "$fline" ] && sf_fatal "@SLK_PREFIX@_$func: Cannot find function in script file"
		fline=`expr $fline - 1`
		fstart=`cat $_@SLK_LIBNAME_UC@_MAIN_SCRIPT $_@SLK_LIBNAME_UC@_SCRIPT_SH | head -$fline | grep -n '^##' | tail -1 | sed 's/:.*$//g'`
		nb=`expr $fline - $fstart + 1`
		if [ -n "$has_run" ] ; then
			echo
			echo "----------------------------------------------------------------------------"
			echo
		fi
		has_run=y
		echo "Command: $func"
		echo
		cat $_@SLK_LIBNAME_UC@_MAIN_SCRIPT $_@SLK_LIBNAME_UC@_SCRIPT_SH \
			| head -$fline | tail -$nb | grep '^#' | grep -v '^##' \
			| grep -v '^#-------' | sed 's/^#//' | sed 's/^ //' 
	done
done
}

##----------------------------------------------------------------------------
# Display error message, usage, and exit
#
# Args:
#	$*: Error message
# Returns: No return
# Displays: Message
#-----------------------------------------------------------------------------

function _@SLK_PREFIX@_fatal
{
sf_error "$*"
echo
_@SLK_PREFIX@_usage
exit 1
}

##----------------------------------------------------------------------------
# Display usage and defined commands
#
# Args: None
# Returns: No return
# Displays: Message
#-----------------------------------------------------------------------------

function _@SLK_PREFIX@_usage
{
echo 'Usage: @SLK_LIBNAME@ <cmd> [args]'
echo
echo "Defined commands (run '@SLK_LIBNAME@ help <command>' for more):"
echo
typeset -F | sed 's/^declare -f //' | grep '^@SLK_PREFIX@_' | sed 's/^@SLK_PREFIX@_//'
}

#=============================================================================
# MAIN
#=============================================================================

#--- Install paths

export _@SLK_LIBNAME_UC@_BASE=%INSTALL_DIR%
export _@SLK_LIBNAME_UC@_BIN_DIR=$_@SLK_LIBNAME_UC@_BASE/bin
export _@SLK_LIBNAME_UC@_MAIN_SCRIPT=$_@SLK_LIBNAME_UC@_BIN_DIR/@SLK_LIBNAME@.sh
export _@SLK_LIBNAME_UC@_PROCESSED_DIR=$_@SLK_LIBNAME_UC@_BASE/processed
export _@SLK_LIBNAME_UC@_SCRIPT_SH=$_@SLK_LIBNAME_UC@_PROCESSED_DIR/script.sh

#-- Clear potentially conflicting f...ing aliases

for i in cp mv rm grep
	do
	unalias $i >/dev/null 2>&1 || :
done

#-- Path
# Using XPG-compliant commands first is mandatory on Solaris, as the
# default syntax is not always compatible with Linux ('tail -n +<number>' for
# instance).

for i in /usr/sbin /bin /usr/bin /sbin /etc /usr/ccs/bin /usr/xpg4/bin /usr/xpg6/bin
	do
	[ -d "$i" ] && PATH="$i:$PATH"
done
export PATH

#-- Load sysfunc

. /usr/bin/sysfunc || :
if ! sf_loaded 2>/dev/null ; then
	echo "ERROR: Sysfunc software not found - Aborting"
	exit 1
fi

#--- Load library functions

. $_@SLK_LIBNAME_UC@_SCRIPT_SH

#-- Variables

[ -z "$@SLK_PREFIX@_install_dir" ] && @SLK_PREFIX@_install_dir="%INSTALL_DIR%"

export @SLK_PREFIX@_install_dir

#-- Check if sourced or executed

_c=`basename "$0" | sed 's/\..*$//g'`
if [ "X$_c" = 'X@SLK_LIBNAME@' ] ; then	# Executed
	# Handle base options

	while getopts 'vynh' flag
		do
		case $flag in
			v) sf_verbose_level=`expr $sf_verbose_level + 1`;;
			y) sf_forceyes=true;;
			n) sf_noexec=true;;
			h) _@SLK_PREFIX@usage; exit 0;;

			?) _@SLK_PREFIX@_usage; exit 1;;
		esac
	done

	[ $OPTIND != 1 ] && shift `expr $OPTIND - 1`

	export sf_forceyes sf_verbose_level sf_noexec

	# Now, handle command

	_cmd="$1"
	[ "X$_cmd" = 'X' ] && _@SLK_PREFIX@_fatal 'No command'
	_func="@SLK_PREFIX@_$_cmd"
	shift
	type "$_func" >/dev/null 2>&1 || _@SLK_PREFIX@_fatal "$_cmd: Unknown command"
	_exec="$_func"
	for arg ; do	# Preserve potential empty strings
		_exec="$_exec '$arg'"
	done
	eval "$_exec ; _rc=\$?"
	exit $_rc
fi

#=============================================================================
