#!/bin/bash
export DISPLAY=:0

mplayer ${HOME}/Music/non-music/Starcraft_Sounds_ENG/Terran/Ghost/TGhLas00.wav

for ((i=0;i<=100;i++)); do echo $i; sleep 0.6s; done | zenity --progress --auto-close --text="Shutting down in a minute now..." --title="Automatic shutdown"
if test $? -eq 0
then
  echo "Shutting down"
  /sbin/shutdown -h now
else
  echo "Cancelling shutdown"
  /sbin/shutdown -h +65
fi
#qdbus org.kde.ksmserver /KSMServer &> /tmp/foo.txt
#qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 1 2 3
