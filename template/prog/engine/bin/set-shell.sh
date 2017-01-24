#
# This script (re)creates a symbolic link to a POSIX-compatible shell in
# INSTALL_DIR/shell.
# It is called by install.sh and can be called again at any time after
# installation to change the shell to be used.
#=============================================================================

. sysfunc

#--- Create a posix-compatible shell link

link_source=$INSTALL_ROOT%INSTALL_DIR%/shell

if [ $# != 0 ] ; then
	shell="$1"
else
	shell=`sf_find_posix_shell`
fi

if [ -n "$shell" ] ; then
	sf_msg "This shell will be used: $shell"
	sf_check_link $shell $link_source
else
	sf_error "Cannot find any POSIX-compatible shell on this host"
fi

sf_finish

#=============================================================================
