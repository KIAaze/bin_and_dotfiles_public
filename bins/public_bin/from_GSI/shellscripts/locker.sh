#! /bin/bash
# This script will lock the PC (and keep it locked) between start_hour and end_hour (i.e: when start_hour<=current_hour<end_hour)

if [ $# -eq 0 ]
then
  echo "Usage: $0 start_hour end_hour"
fi

start_hour=0
end_hour=6
if [ $1 ]; then start_hour=$1; fi;
if [ $2 ]; then end_hour=$2; fi;

echo start_hour=$start_hour
echo end_hour=$end_hour

while true
do
sleep 1
  
  current_hour=$(date +"%H")
#echo current_hour=$current_hour
  
  if [ \( $start_hour -le $current_hour \) -a \( $current_hour -lt $end_hour \) ]
  then
#   Xdialog --title "MESSAGE BOX" \
#         --icon ./warning.xpm \
#         --msgbox "Hi, this is a simple message box. You can use this to
# display any message you like. The box will remain until
# you press the ENTER key.
# You may also add an icon on the left of this text." 0 0

    Xdialog --title "INFO BOX" \
            --infobox "PC usage forbidden from $start_hour o'clock to $end_hour o'clock!" 0 0

#echo "PC usage forbidden"
#echo "Locking PC"
#     killall yakuake
#     killall konsole
#     running=`ps aux | grep -c xscreensaver`;
#     echo $running;
#ls&;
#if [ $running == "1" ]; then; xscreensaver    &; fi;
#    if [ $running == "1" ]; then xscreensaver&; fi;
#     xscreensaver-command -lock
#selse
#echo "PC usage allowed"
  fi
done
