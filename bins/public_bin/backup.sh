#!/bin/bash
set -e -u

# Check if all parameters are present
# If no, exit
if [ $# -lt 1 ]
then
        echo "usage :"
        echo "`basename $0` FILE/DIR"
        exit 0
fi

for file in "$@"
do
    FULLPATH=$(readlink -f "$file")
    DIR=$(dirname "$FULLPATH")
    FILE=$(basename "$FULLPATH")
    DATE=$(date +%Y%m%d_%H%M%S)
    NEWNAME="$FULLPATH.$DATE"
    echo "cp -riv $FULLPATH $NEWNAME"
    cp -riv "$FULLPATH" "$NEWNAME"
done
