#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo
	echo 'archives a directory as <dir>_$(date +%Y%m%d_%H%M%S).tar.gz'
	echo "usage :"
	echo "$0 <dir>"
        echo
        exit 0
fi

DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE=$1_$DATE.tar.gz

tar -czvf $ARCHIVE $1
echo "All archived in $ARCHIVE"
