#!/bin/bash
export DISPLAY=:0

mplayer ${HOME}/Music/non-music/Starcraft_Sounds_ENG/Terran/Ghost/TGhLas00.wav

for ((i=0;i<=100;i++)); do echo $i; sleep 0.1s; done | zenity --progress --auto-close --text="Shutting down in a few seconds..." --title="Automatic shutdown"
if test $? -eq 0
then
  echo "Shutting down"
  /sbin/shutdown -h now
else
  echo "Cancelling shutdown"
fi
#qdbus org.kde.ksmserver /KSMServer &> /tmp/foo.txt
#qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 1 2 3
