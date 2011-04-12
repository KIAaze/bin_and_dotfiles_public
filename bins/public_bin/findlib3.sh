#!/bin/bash
#This script searches for function $1 in all libraries listed in FILE

if [ $# -ne 1 ]
then
        echo 'This script searches for function $1 in all libraries listed in FILE'
	echo "usage : $0 func < FILE"
	exit 0
fi

while read -r FILE ;
do
    if readlink -f $FILE 1>/dev/null 2>&1
    then
	if ( nm $FILE | grep $1 ) 1>/dev/null 2>&1
	then
	    echo "------->$FILE"
	    nm $FILE | grep $1
	fi
    fi
done
