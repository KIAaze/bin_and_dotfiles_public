#!/bin/bash
set -e -u

# Check if all parameters are present
# If no, exit
if [ $# -lt 1 ]
then
        echo "usage :"
        echo "`basename MOVE? $0` FILE/DIR"
	echo "MOVE=0 => use cp -riv"
	echo "MOVE=1 => use mv -iv"
        exit 0
fi

MOVE=$1

shift

#echo $@

for file in "$@"
do
    FULLPATH=$(readlink -f "$file")
    DIR=$(dirname "$FULLPATH")
    FILE=$(basename "$FULLPATH")
    DATE=$(date +%Y%m%d_%H%M%S)
    NEWNAME="$FULLPATH.$DATE"
    if [ $MOVE = "0" ]
    then
      echo "cp -riv $FULLPATH $NEWNAME"
      cp -riv "$FULLPATH" "$NEWNAME"
    elif [ $MOVE = "1" ]
    then
      echo "mv -iv $FULLPATH $NEWNAME"
      mv -iv "$FULLPATH" "$NEWNAME"
    else
      echo "invalid MOVE argument"
    fi
done
