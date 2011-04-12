#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Shreds a file so it can't be recovered. Use carefully."
        echo "usage :"
        echo "`basename $0` [FILE]"
        exit 0
fi

FILE=$(readlink -f $1)

echo "Shred $FILE ? (y/n)"
read ans
case $ans in
	y|Y|yes) shred -f -v -z -u $FILE ;;
	*) exit 1;;
esac
