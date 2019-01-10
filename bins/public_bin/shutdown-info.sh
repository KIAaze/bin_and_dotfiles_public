#!/bin/bash
# display scheduled shutdown time, if any. Exit with error if none scheduled.

# https://unix.stackexchange.com/questions/229745/systemd-how-to-check-scheduled-time-of-a-delayed-shutdown/491262#491262
# https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdVersionOfShutdown
# https://blog.sleeplessbeastie.eu/2015/11/26/how-to-schedule-system-reboot/
# https://askubuntu.com/questions/994339/check-if-shutdown-schedule-is-active-and-when-it-is

# old versions
# systemctl status systemd-shutdownd.service

# newer versions
# journalctl -u systemd-shutdownd
if [ -f /run/systemd/shutdown/scheduled ]; then
  perl -wne 'm/^USEC=(\d+)\d{6}$/ and printf("Shutdown scheduled for %s, use '\''shutdown -c'\'' to cancel.\n", scalar localtime $1)' < /run/systemd/shutdown/scheduled

  # this works but uses $1 of the script. Why?
  #   perl -wne "m/^USEC=(\d+)\d{6}$/ and printf(\"Shutdown scheduled for %s, use 'shutdown -c' to cancel.\n\", scalar localtime $1)" < /run/systemd/shutdown/scheduled
  exit 0
else
  exit 1
fi
# busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager ScheduledShutdown
# USECS=$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager ScheduledShutdown | cut -d ' ' -f 3); SECS=$((USECS / 1000000)); date --date=@$SECS
# qdbus --literal --system org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.DBus.Properties.Get org.freedesktop.login1.Manager ScheduledShutdown
# date -d @$(echo "(1445770800000000/1000000)" | bc)
# echo "(1445770800000000/1000000)" | bc
# date -d @1445770800
# busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager ScheduledShutdown
