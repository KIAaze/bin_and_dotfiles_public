#!/bin/bash
#Shows a popup message + says the message using festival.

if which zenity &> /dev/null; then
  #echo "There it is"
  zenity --info --text="$*" &
#else
  #3echo "It's not there"
fi
say.sh "$*" &
echo "$*"
