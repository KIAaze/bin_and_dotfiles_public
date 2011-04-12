#!/bin/bash
if which festival &> /dev/null; then
  #echo "There it is"
  echo $* | padsp festival --tts
#else
  #echo "It's not there"
fi
