#!/bin/bash

PREFIX=cro-output-

krun --no-color "$@" | csplit -s -f $PREFIX - '/<T>/' && cat "${PREFIX}00"
