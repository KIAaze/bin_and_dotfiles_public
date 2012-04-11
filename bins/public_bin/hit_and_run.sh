#!/bin/bash
# Script to run at login.
# It asks for a mission description and estimated time of completion delta_T.
# A logout will then be scheduled at NOW+delta_T
# Mission description and time left will be displayed permanently via OSD.
# After forced logout occurs, it will be impossible to log back in for 15 minutes.

set -eux

# For the greeter mod to work, you need to change the theme in /etc/lxdm/default.conf
GREETER_UI="$HOME/Lubuntu2/greeter.ui"
GREETER_UI_TEMPLATE="$HOME/Lubuntu2/greeter.ui.template"

# input
MISSION=$(zenity --entry --text="Mission description:" --entry-text="Get things done!")
delta_T=$(zenity --entry --text="Estimated time of completion (HH:MM:SS):" --entry-text="00:15:00")
delta_T2=$(zenity --entry --text="Out time (HH:MM:SS):" --entry-text="00:15:00")
zenity --warning --text="If the internet is not required, disconnect it now."

NOW=$(date +%H:%M:%S)
END=$($HOME/bin/time_op.py "$NOW + d$delta_T" "%H:%M")
END2=$($HOME/bin/time_op.py "$END:00 + d$delta_T2" "%H:%M")

# add time to login screen :)
sed s/LOGIN_TEXT/"Next login allowed at: $END2"/ $GREETER_UI_TEMPLATE > $GREETER_UI

# schedule logout time
# at $END -f $HOME/bin/logout.sh

# schedule out time
# $HOME/bin/forcelogout.sh force-on $END2

# schedule logout time
#echo "$HOME/bin/logout_until.sh $END2" | at $END
echo "$HOME/bin/logout_until.sh" | at $END
echo "$HOME/bin/forcelogout.sh off" | at $END2

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
