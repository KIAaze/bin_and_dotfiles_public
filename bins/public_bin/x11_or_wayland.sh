#!/bin/bash
# Simple script to check whether X11 or Wayland is used:
#
# Useful references:
# https://unix.stackexchange.com/questions/394709/how-to-return-the-currently-active-user-session-on-a-graphical-linux-desktop-ses

# This fails on Arch, due to no "tty" line being present:
# loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}'

# List all sessions and their type:
for sessionid in $(loginctl list-sessions --no-legend | awk '{ print $1 }')
do
    loginctl show-session -p Id -p State -p Type -p Class -p TTY $sessionid | tr '\n' '\t'
    echo
done

# echo "================="
# for sessionid in $(loginctl list-sessions --no-legend | awk '{ print $1 }')
# do loginctl show-session -p Id -p Name -p User -p State -p Type -p Remote $sessionid
# done
#
# echo "================="
# for sessionid in $(loginctl list-sessions --no-legend | awk '{ print $1 }')
# do loginctl show-session -p Id -p Name -p User -p State -p Type -p Remote $sessionid | sort
# done |
# awk -F= '/Name/ { name = $2 } /User/ { user = $2 } /State/ { state = $2 } /Type/ { type = $2 } /Remote/ { remote = $2 } /User/ && remote == "no" && state == "active" && (type == "x11" || type == "wayland") { print user, name }'
#
# echo "================="
# for sessionid in $(loginctl list-sessions --no-legend | awk '{ print $1 }')
# do loginctl show-session -p Id -p Name -p User -p State -p Type -p Remote -p LockedHint $sessionid | sort
# done |
# awk -F= '/Name/ { name = $2 } /User/ { user = $2 } /State/ { state = $2 } /Type/ { type = $2 } /Remote/ { remote = $2 } /LockedHint/ { locked = $2 } /User/ && remote == "no" && state == "active" && (type == "x11" || type == "wayland") { print user, name, locked == "yes" ? "locked" : "unlocked" }'
