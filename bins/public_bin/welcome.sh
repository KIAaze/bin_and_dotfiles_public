#!/bin/bash
cd ~/stage_master
days_left=`./get_date_stage.sh`
text="Good day commander. You have $days_left days left."
echo 1
echo  $text 1>$HOME/welcome.log 2>&1
echo 2
zenity --info --text="$text" 1>$HOME/welcome.log 2>&1 &
echo 3
$HOME/bin/say.sh "$text" 1>$HOME/welcome.log 2>&1 &
