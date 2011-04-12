#!/bin/bash

if [ $# -ne 2 ]
then
	echo "usage : $0 <period> <message>"
	exit 0
fi

#Figure out which display we're using

#
# Ubuntu version of osd_cat does not like "host name" in front of display
#

#HOST="$(xrdb -symbols | grep SERVERHOST | cut -d= -f2)"
DISPLAYNUM="$(xrdb -symbols | grep DISPLAY_NUM | cut -d= -f2)"
#THISDISPLAY=$HOST:$DISPLAYNUM.0
THISDISPLAY=:$DISPLAYNUM.0

PERIOD=$1
MESSAGE=$2

#check to see if the reminders directory exists (create if not)
if [ ! -e ~/reminders ] ; then
  mkdir ~/reminders
fi

unique=`date +%F-%H-%M-%S`
reminder="reminders/reminder-"$unique

#Now output the reminder script
echo '#!/bin/bash' > ~/$reminder
echo -n 'export DISPLAY=' >> ~/$reminder
echo $THISDISPLAY >> ~/$reminder
echo "echo \"$MESSAGE\" | osd_cat -s 2 -c green -p middle -A center \
-f -adobe-helvetica-bold-r-normal-*-*-240-*-*-p-*-*-* -d 5" >> ~/$reminder

#Make the reminder script executable
chmod +x ~/$reminder

#Schedule it to run
# at $TIME -f ~/$reminder
crontab_add.sh "*/$PERIOD * * * * ~/$reminder"
