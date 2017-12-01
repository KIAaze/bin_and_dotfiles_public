#!/bin/bash
# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
  echo "usage :"
	echo "`basename $0` mail file"
  exit 1
fi

MAIL=$1
FILE=$2

# decrypt with gpg -d ...
gpg --symmetric --encrypt --recipient $MAIL $FILE
