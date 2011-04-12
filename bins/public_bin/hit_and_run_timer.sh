#!/bin/bash
# accidentally closed the timer?
# This script is for you! :)

set -eux

# input
MISSION=$1
END=$2

################
# activate OSD
################
#HOST="$(xrdb -symbols | grep SERVERHOST | cut -d= -f2)"
DISPLAYNUM="$(xrdb -symbols | grep DISPLAY_NUM | cut -d= -f2)"
#THISDISPLAY=$HOST:$DISPLAYNUM.0
THISDISPLAY=:$DISPLAYNUM.0

export DISPLAY=$THISDISPLAY
# export DISPLAY=:0.0

while true
do
    NOW=$(date +%H:%M:%S)
    TIME_LEFT=$($HOME/bin/time_op.py "$END:00 - $NOW")
    echo "$MISSION $TIME_LEFT"

    if [ $TIME_LEFT = "00:00:03" ]
    then
      $HOME/bin/totalnotify.sh "TIME IS OVER"
    fi

    (echo "$MISSION" | osd_cat -s 2 -c green -p top -A left -f -adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-* -d 1)&
    (echo "$TIME_LEFT" | osd_cat -s 2 -c green -p top -A right -f -adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-* -d 1)&

#     echo "$X" | osd_cat -s 2 -c green -p top -A right -f -adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-* -d 1
    sleep 1
done
