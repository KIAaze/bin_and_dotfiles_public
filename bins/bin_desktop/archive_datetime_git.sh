#!/bin/bash
# set -x
set -eu

# Check if all parameters are present
# If no, exit
if ( [ $# -ne 1 ] || [ $1 = "-f" ] ) && ( [ $# -ne 2 ] || [ $1 != "-f" ] )
then
	echo
	echo 'archives a git repository as <dir>_$(date +%Y%m%d_%H%M%S).tar.gz'
	echo "usage :"
	echo "$0 <dir>"
	echo "force archival:"
	echo "$0 -f <dir>"
        echo
        exit 0
fi

# TODO Learn to use shift and use it
if [ $1 = "-f" ]
then
  DIR=$(readlink -f $2)
else
  DIR=$(readlink -f $1)
fi

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
  if [ $1 = "-f" ]
  then
    #force archival
    echo "Warning: Forcing archival"
  else
    #do nothing
    echo "Please commit latest changes before archiving. ;)"
    echo "If you want to force archival, use:"
    echo " cd $DIR"
    echo " git archive --format=tar --prefix=$BASE/ HEAD | gzip >$ARCHIVE"
    echo "...or the -f flag. :)"
    exit 2
  fi
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
