#!/bin/bash
#
# This script builds the RPM spec file
#
#============================================================================

CMD=`basename $0`
cd `dirname $0`/../..
BASE_DIR=`/bin/pwd`
SOFTWARE_VERSION="$1"
INSTALL_DIR="$2"

export BASE_DIR SOFTWARE_VERSION INSTALL_DIR

sed -e "s,%SOFTWARE_VERSION%,$SOFTWARE_VERSION,g" \
	-e "s,%INSTALL_DIR%,$INSTALL_DIR,g" \
	<$BASE_DIR/specfile.in >$BASE_DIR/specfile

###############################################################################
