#!/bin/sh
# @SLK_LIBNAME@ library tests
#
# This code is executed with the '-e' shell flag (non-zero return code from
# any statement aborts the run).
#=============================================================================

#The code below is just an example
# Feel free to replace it with your own tests

make rpm

make -k clean install

@SLK_LIBNAME@ version

. @SLK_LIBNAME@

@SLK_PREFIX@_loaded

#=============================================================================
