#!/bin/bash
set -e -u -x

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` SOURCEDIR (dir containing configure script)"
        exit 0
fi

echo "sourcedir=$1"

cd $1
./configure && make clean && make dist
