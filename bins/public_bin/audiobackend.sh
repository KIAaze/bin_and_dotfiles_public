#!/bin/bash
##### https://www.reddit.com/r/kdeneon/comments/1bobndb/switch_between_pipewire_and_pulseaudio/

if [ "$1" == "status" ]
then
# presumably if both were running that's a problem
    if systemctl --user is-active --quiet pipewire
    then
      echo "Pipewire is running"
    fi
    if systemctl --user is-active --quiet pulseaudio
    then
      echo "Pulseaudio is running"
    fi
    if ! systemctl --user is-active --quiet pipewire && ! systemctl --user is-active --quiet pulseaudio
    then
      echo "Pipewire and pulseaudio systems not running."
      echo "===> Processes using sound sockets: fuser -v /dev/snd/*"
      fuser -v /dev/snd/*
    fi
    exit 0
fi

if [ "$1" == "pipe" -o "$1" == "pipewire" ]
then
  systemctl --user disable pulseaudio pulseaudio.socket pulseaudio-x11
  systemctl --user stop pulseaudio pulseaudio.socket pulseaudio-x11
  systemctl --user mask pulseaudio pulseaudio.socket pulseaudio-x11

  systemctl --user unmask pipewire pipewire.socket wireplumber pipewire-pulse pipewire-pulse.socket
  systemctl --user enable pipewire pipewire.socket wireplumber pipewire-pulse pipewire-pulse.socket
  systemctl --user start pipewire wireplumber pipewire-pulse pipewire-pulse.socket
  echo Set to Pipewire
  exit 0
fi

if [ "$1" == "pulse" -o "$1" == "pulseaudio" ]
then
  systemctl --user disable pipewire pipewire.socket wireplumber pipewire-pulse pipewire-pulse.socket
  systemctl --user stop pipewire wireplumber pipewire-pulse pipewire-pulse.socket
  systemctl --user mask pipewire disable pipewire.socket wireplumber pipewire-pulse    pipewire-pulse.socket
  systemctl --user unmask pulseaudio pulseaudio.socket pulseaudio-x11
  systemctl --user enable pulseaudio pulseaudio.socket pulseaudio-x11
  systemctl --user start pulseaudio pulseaudio.socket pulseaudio-x11
  echo Set to Pulseaudio
  exit 0
fi


echo "Usage audiobackend pipewire|pulse|status"
exit 1
