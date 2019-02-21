#!/bin/bash
# Script to monitor screenlocker lock/unlock times
# cf:
#   https://superuser.com/questions/662974/logging-lock-screen-events
#   https://superuser.com/questions/820596/kde-screen-lock-log

set -eu

LOGFILE=${1:-${HOME}/log/lock_screen.log}

# detect system
if grep -q org.freedesktop.ScreenSaver <(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames)
then
  INTERFACE=org.freedesktop.ScreenSaver
elif grep -q org.gnome.ScreenSaver <(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames)
then
  INTERFACE=org.gnome.ScreenSaver
else
  echo "No known screensaver interface found."
  exit 1
fi

# create trap
exit_report(){
echo "$(date) Monitoring Terminated."
}
trap "exit_report; exit;" 0

# main logging function
lockmon() {
  adddate() {
      while IFS= read -r line; do
        echo "$(date) $line" | grep "boolean" | sed 's/   boolean true/Screen Locked/' | sed 's/   boolean false/Screen Unlocked/'
      done
  }
  echo "$(date) Monitoring Started."
  dbus-monitor --session "type='signal',interface='${INTERFACE}'" | adddate
}

# start logging
lockmon >> ${LOGFILE}
