#!/bin/bash

set -ux

MAIL=$USER
SUBJECT='Default subject'

LOGFILE=super.log
echo > $LOGFILE

main_function()
{
	echo "hello world!"
	ls $1
}

main_function $1  1>>$LOGFILE 2>&1
if [ $? -ne 0 ]
then
    SUBJECT="webserver backup failed"
else
    SUBJECT="webserver backup succeeded"
fi

#mail the LOGFILE
mailx -s "$SUBJECT" $MAIL < $LOGFILE

