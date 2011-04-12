#!/bin/bash
set -e -u

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo "Lists all files within PATH belonging to group GROUP"
        echo "usage :"
        echo "`basename $0` GROUP"
        exit 0
fi

GRP=$1

TMP1=$(mktemp)
TMP2=$(mktemp)

echo $PATH >$TMP1
sed 's/:/\n/g'  $TMP1 >$TMP2
#cat $TMP2

GID=$( grep ^$GRP /etc/group | awk -F: '{print $3}' )
#echo "GID=$GID"

cat $TMP2 | xargs -n1 -I{} find {} -gid $GID
