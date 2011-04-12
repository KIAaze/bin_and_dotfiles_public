#!/bin/bash
# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
        echo "usage :"
	echo "`basename $0` e-mail file"
        exit 0
fi

gpg -c -e -r $1 $2
