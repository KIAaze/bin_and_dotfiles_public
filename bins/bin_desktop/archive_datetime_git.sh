#!/bin/bash
# set -x

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo
	echo 'archives a git repository as <dir>_$(date +%Y%m%d_%H%M%S).tar.gz'
	echo "usage :"
	echo "$0 <dir>"
        echo
        exit 0
fi

DIR=$(readlink -f $1)
BASE=`basename $DIR`
ORIG=`pwd`

DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE=$ORIG/$BASE\_$DATE.tar.gz

# exit 0

cd $DIR
if [ $? -ne 0 ]
then
	echo "ERROR: Could not change directory"
	exit 2
fi

git status
if [ $? -eq 128 ]
then
	echo "ERROR: No git repository found."
	exit 2
fi

if [ $( git status | wc -l ) -ne 2 ]
then
	echo "Please commit latest changes before archiving. ;)"
	echo "Do you want to force archival anyway?(y/n)"
	read ans
	case $ans in
	  y|Y|yes) echo "Archiving anyway...";;
	  *) echo "Exiting"
	     exit 2;;
	esac
fi

#hg archive -v -t"tgz" $ARCHIVE
git archive --format=tar --prefix=$BASE/ HEAD | gzip >$ARCHIVE

if [ $? -eq 0 ]
then
	echo "All archived in $ARCHIVE"
	exit 0
else
	echo "ERROR: Archiving failed"
	exit 1
fi

cd $ORIG
