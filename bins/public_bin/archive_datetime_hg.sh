#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo
	echo 'archives a mercurial repository as <dir>_$(date +%Y%m%d_%H%M%S).tar.gz'
	echo "usage :"
	echo "$0 <dir>"
        echo
        exit 0
fi

DIR=$1
BASE=`basename $1`
ORIG=`pwd`

DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE=$ORIG/$BASE\_$DATE.tar.gz

cd $DIR
if [ $? -ne 0 ]
then
	echo "ERROR: Could not change directory"
	exit 2
fi

if ! ( hg status )
then
	echo "ERROR: No mercurial repository found."
	exit 2
fi

if [ $( hg status | wc -l ) -ne 0 ]
then
	echo "Please commit latest changes before archiving. ;)"
	exit 2
fi

hg archive -v -t"tgz" $ARCHIVE
if [ $? -eq 0 ]
then
	echo "All archived in $ARCHIVE"
	exit 0
else
	echo "ERROR: Archiving failed"
	exit 1
fi

cd $ORIG
