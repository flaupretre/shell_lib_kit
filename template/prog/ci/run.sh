#!/bin/sh
# Run an action (test, deployment, etc)
#
# 1st arg: action to execute
#=============================================================================

env
set -x
set -e	# Exit on non-zero status

#-----

RUNTYPE=local
[ -n "$GITLAB_CI" ] && RUNTYPE=gitlab

WS_BASE=`pwd`
[ $RUNTYPE = local ] && WS_BASE="`dirname $WS_BASE`"

ret=0

SOFTWARE_NAME=@SLK_LIBNAME@
SOFTWARE_VERSION=`grep '^SOFTWARE_VERSION' $WS_BASE/config.mk | sed 's/^.* //g'`

export RUNTYPE WS_BASE SOFTWARE_NAME SOFTWARE_VERSION

#---------------------------------------------------------------------------

action="$1"
if [ -z "$action" ] ; then
	echo 'Usage: run.sh <action> [args]'
	exit 1
fi
shift

cd $WS_BASE

echo "--- cleanup ---"

make clean || ret=$?

#-- Run library-specific script if it exists

LIB_SCRIPT="$WS_BASE/ci/actions/$action.sh"
if [ -f "$LIB_SCRIPT" ] ; then
	echo "--- Ruuning action: $action ---"
	. "$LIB_SCRIPT"
else
	echo "--- Nothing to do"
fi

echo "--- cleanup ---"

make clean || ret=$?

#----

if [ "$ret" = 0 ] ;then
	echo "======== SUCCESS ============="
else
	echo "************ One or more errors were encoutered **************"
fi

exit $ret
