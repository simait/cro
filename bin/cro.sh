#!/bin/bash

SCRIPT_FILE=$0
test -L $SCRIPT_FILE && SCRIPT_FILE=`readlink $SCRIPT_FILE`
SCRIPT_DIR=`dirname $SCRIPT_FILE`
source $SCRIPT_DIR/cro-common.sh

PREFIX=cro-output-

krun --compiled-def cro-srp-kompiled --no-color "$@" | csplit -s -f $PREFIX - '/<T>/' && cat "${PREFIX}00"

if ! executeOK "${PREFIX}01"
then
	echo "Execution didn't complete successfully! (see ${PREFIX}01)" >> /dev/stderr
	exit 1
fi