#!/bin/bash

KRUN=`which krun`
PREFIX=cro-solution-
SOLUTIONS=0
SOLUTIONS_ALL=`mktemp`
SOLUTIONS_MAX=10000

$KRUN --no-color --search "$@" > $SOLUTIONS_ALL

SOLUTIONS=`grep Solution $SOLUTIONS_ALL | wc -l`
if test $SOLUTIONS -gt $SOLUTIONS_MAX
then
	echo "Too many solutions: ${SOLUTIONS} (maximum ${SOLUTIONS_MAX})."
	exit 1
fi

rm -f $PREFIX*
rm -f $PREFIX*.bak

csplit  -n 4 -s -f $PREFIX $SOLUTIONS_ALL '/Solution/' {*}

rm $SOLUTIONS_ALL

for i in "${PREFIX}*"
do
	sed --in-place --expression '/Solution/d' $i
done

rm -f $PREFIX*.bak
