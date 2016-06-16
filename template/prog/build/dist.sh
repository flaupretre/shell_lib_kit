#
# Compute and display the 'dist' variable to transmit to rpm
#
# This script is needed because, unlike RHEL 6, RHEL 4 & 5 don't provide
# this value in their rpm build system
#
#============================================================================

. sysfunc

if [ `sf_os_family` = Linux -a `sf_os_distrib` = RHEL ] ; then
	echo ".el`sf_os_version`"
fi

###############################################################################
