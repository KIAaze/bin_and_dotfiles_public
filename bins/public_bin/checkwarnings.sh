#!/bin/bash
set -eu
qmake
make distclean
qmake 1>qmake.log 2>&1
make 1>build.log 2>&1
if grep -i warning ./build.log 1>warning.log 2>&1
then
	echo "THERE ARE WARNINGS"	
fi
if grep -i error ./build.log 1>error.log 2>&1
then
	echo "THERE ARE ERRORS"
fi
