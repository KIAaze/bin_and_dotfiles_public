#!/bin/bash
set -eu

if [ $# -lt 1 ]
then
	echo "Shreds a file so it can't be recovered. Use carefully."
        echo "usage :"
        echo "`basename $0` [FILE]"
        exit 0
fi

ASK=1

for f in "$@"
do
  FILE=$(readlink -f "$f")

  if [ $ASK -eq 1 ]
  then
    echo "Shred $FILE ? (y/n/all)"
    read ans
    case $ans in
	    y|Y|yes) shred -f -v -z -u "$FILE" ;;
	    all) ASK=0; shred -f -v -z -u "$FILE";;
	    *) exit 1;;
    esac
  else
    echo "Shredding $FILE ..."
    shred -f -v -z -u "$FILE"
  fi
done
