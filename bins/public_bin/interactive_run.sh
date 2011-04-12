#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
      echo "usage :"
      echo "`basename $0` COMMAND"
      exit 0
fi


if zenity --question --text "Run $1 ?"
then
	echo OK
	$1
else
	echo "not OK"
fi

#skype &
#pidgin &
#xchat --minimize=2 &

