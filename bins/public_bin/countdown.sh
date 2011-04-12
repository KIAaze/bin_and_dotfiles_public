#!/bin/bash

export DISPLAY=:0.0

X=$1

while [ $X -gt -1 ]
do
    echo $X
    beep
    echo "$X" | osd_cat -s 2 -c green -p top -A right -f -adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-* -d 1
#    sleep 1
    X=`expr $X - 1`
done

~/bin/totalnotify.sh "TIME IS OVER"
