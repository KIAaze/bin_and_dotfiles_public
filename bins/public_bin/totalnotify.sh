#!/bin/bash
#### Script to notify the user using different notifying methods.

messagebox_func()
{
  if which zenity &> /dev/null; then
    zenity --info --text="$*" 2>/dev/null
  fi
}

cowsay_func()
{
  if which cowsay &> /dev/null; then
    echo "$*" | cowsay
  fi
}

notify_knotify_func()
{
  if which knotify &> /dev/null; then
    dcop knotify default notify eventname appname "$*" '' '' 2 0
  fi
}

notify_zenity_func()
{
  if which zenity &> /dev/null; then
    zenity  --notification  --text "$*"
  fi
}

notify_notifysend_func()
{
  if which notify-send &> /dev/null; then
    notify-send "$*"
  fi
}

mailme_func()
{
  if ! [ -z ${EMAIL+x} ]; then
    if which mail &> /dev/null; then
      echo "$@" | mail -s "$1" ${EMAIL}
    fi
  fi
}

# choose which methods you prefer here
echo "$*"
say.sh "$*" &
messagebox_func "$*" &
#cowsay_func "$*" &
#notify_knotify_func "$*" &
#notify_zenity_func "$*" &
notify_notifysend_func "$*" &
# mailme_func "$*" &
