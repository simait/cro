#!/bin/bash

KRUN=`which krun`
PREFIX=cro-solution-
SOLUTIONS=0
SOLUTIONS_ALL=`mktemp`
SOLUTIONS_MAX=10000

SCRIPT_FILE=$0
test -L $SCRIPT_FILE && SCRIPT_FILE=`readlink $SCRIPT_FILE`
SCRIPT_DIR=`dirname $SCRIPT_FILE`
source $SCRIPT_DIR/cro-common.sh

$KRUN --compiled-def cro-srp-kompiled --no-color --search "$@" |tail -n+3 > $SOLUTIONS_ALL
cp $SOLUTIONS_ALL test.output.tmp

SOLUTIONS=`grep Solution $SOLUTIONS_ALL | wc -l`
if test $SOLUTIONS -gt $SOLUTIONS_MAX
then
	echo "Too many solutions: ${SOLUTIONS} (maximum ${SOLUTIONS_MAX})."
	exit 1
fi

rm -f $PREFIX*
rm -f $PREFIX*.bak

csplit  -z -n 4 -s -f $PREFIX $SOLUTIONS_ALL '/Solution/' {*}

rm $SOLUTIONS_ALL

for i in "${PREFIX}*"
do
	sed --in-place --expression '/Solution/d' $i
	if ! executeOK $i
	then
		echo "Execution didn't complete successfully! (see ${i})" >> /dev/stderr
		exit 1
	fi
done

rm -f $PREFIX*.bak
