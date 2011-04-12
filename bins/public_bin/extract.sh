#!/bin/bash
set -e -u

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
	echo "Extracts an archive to a directory with the same basename using tar."
        echo "usage :"
        echo "`basename $0` ARCHIVE EXTENSION"
        exit 0
fi

ARCHIVE=$1
EXT=$2
DESTDIR=$( dirname $ARCHIVE )/$( basename $ARCHIVE $EXT )

extract()
{
	if [ -e $DESTDIR ]
	then
	    echo "$DESTDIR already exists. Extract anyway?(y/n)"
	    read ans
	    case $ans in
	    y|Y|yes) "Proceeding...";;
	    *) exit 0;;
	    esac
	fi
	mkdir $DESTDIR
	tar -C $DESTDIR -xvf $ARCHIVE
}

echo "Extract to $DESTDIR ? (y/n)"
read ans
case $ans in
  y|Y|yes) extract && exit 0;;
  *) exit 0;;
esac
