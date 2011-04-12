#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` SRC_DIR"
        exit 0
fi

set -eux

CDPATH=/media/cdrom
MD5=/tmp/md5.txt

SRC_DIR=$1
# DST_DIR=$2

# FULL=$(readlink -f $SRC)
# DIR=$(dirname $SRC)
# BASE=$(basename $SRC)

# md5deep -b -r -o f $CDPATH/* > $MD5

# cd $(dirname $SRC)
# cd $(dirname $DST)

# md5sum $SRC >

find . \( ! -name . -prune \) -type f -print0 | while read -d $'\0' FILE
do
  echo "Processing $FILE ..."
  SRC=$(readlink -f "$SRC_DIR/$FILE")
  if [ -f "$SRC" ]
  then
    md5deep -b "$SRC" >$MD5
    if md5sum -c $MD5
    then
      echo "$FILE burned successfully. Removing it."
      beep
      if zenity --question --text "Remove $SRC?"
      then
        echo "Removing $SRC"
	rm -v "$SRC"
      else
        echo "Keeping $SRC"
      fi
    else
      echo "ERROR: MD5 sums differ for $FILE and $SRC"
    fi
  else
    echo "ERROR: File $SRC not found."
  fi
done

# FILES=$(find . \( ! -name . -prune \) -type f -print)
# echo $FILES
# md5deep -b $SRC >$MD5
# cd $DESTDIR
# if md5sum -c $MD5
# then
#   echo "$BASE burned successfully. Removing it."
#   rm -iv $SRC
# else
#   echo "ERROR!"
# fi

zenity --info --text "DONE!"
