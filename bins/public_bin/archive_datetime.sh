#!/bin/bash

set -eux

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
	echo
	echo 'archives a directory as DIR_$(date +%Y%m%d_%H%M%S).tar.gz'
	echo "usage :"
	echo "$(basename $0) <0=archive in current dir / 1=archive in dirname DIR> <DIR>"
        echo
        exit 1
fi

FULLDIR=$( readlink -f "$2" )

BASE=$(basename "$FULLDIR")
DIR=$(dirname "$FULLDIR")
ORIG=$(pwd)

DATE=$(date +%Y%m%d_%H%M%S)

if [ $1 -eq 0 ]
then
  DEST=$ORIG
else
  DEST=$DIR 
fi

echo "DEST=$DEST"

ARCHIVE=$DEST/$BASE\_$DATE.tar.gz

tar -C "$DIR" -czvf "$ARCHIVE" "$BASE"

if [ $? -eq 0 ]
then
	echo "All archived in $ARCHIVE"
#         echo "Check contents?(y/n)"
#         read ans
#         case $ans in
#           y|Y|yes) tar -tzvf $ARCHIVE | less;;
#         esac
	exit 0
else
	echo "ERROR: Archiving failed"
	exit 1
fi
