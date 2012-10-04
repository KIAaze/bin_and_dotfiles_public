#!/bin/bash
#This script searches for function $1 in all libraries available in the directory $2.

if [ $# -ne 2 ]
then
        echo 'This script searches for function $1 in all libraries available in the directory $2.'
	echo "usage : $0 <func> <dir>"
	exit 0 
fi

for file in `find $2`;
do
echo "------->$file"
nm $file | grep $1
done
