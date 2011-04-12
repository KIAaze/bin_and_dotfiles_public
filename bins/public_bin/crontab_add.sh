#!/bin/bash

if [ $# -ne 1 ]
then
	echo "usage : $0 <crontab line>"
	exit 0 
fi

CRONFILE=/tmp/current_crontab

crontab -l >$CRONFILE

if test ! -s $CRONFILE
then
echo "# m h  dom mon dow   command" >$CRONFILE
fi

echo "$1" >>$CRONFILE
crontab $CRONFILE
crontab -l
