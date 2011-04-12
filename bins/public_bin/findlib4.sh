#!/bin/bash
#This script searches for function $1 in all libraries available in the directory $2.

if [ $# -ne 2 ]
then
        echo 'This script searches for function $1 in all libraries available in the directory $2.'
	echo "usage : $0 <func> <dir>"
	exit 0 
fi

for FILE in $( find -L $2 -type f );
do
#     echo $FILE
    if ( file $FILE | grep LSB ) 1>/dev/null 2>&1
    then
	if ( nm $FILE | grep $1 | grep ' T ') 1>/dev/null 2>&1
	then
	    echo "------->$FILE"
	    nm $FILE | grep $1 | grep ' T '
	fi
    fi
done
