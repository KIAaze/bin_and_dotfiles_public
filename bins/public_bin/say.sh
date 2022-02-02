#!/bin/bash
#### very simple wrapper using whatever text-to-speech software is available

if which espeak-ng &> /dev/null; then
  espeak-ng "$*"
elif which espeak &> /dev/null; then
  espeak "$*"
elif which festival &> /dev/null; then
  echo "$*" | festival --tts
  # echo $* | padsp festival --tts # only needed on older systems
fi
