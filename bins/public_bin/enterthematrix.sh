#!/bin/sh

# enter the matrix screensaver+music starter B)
# Works for dual monitor setup.
# TODO: clean up + improve

set -ux

# script by luebking
# source: https://forum.kde.org/viewtopic.php?f=289&t=124413

killall glmatrix

xset -dpms

unclutter &
UNCLUTTER_PID=$!

# mplayer /home/music/ost/The\ Matrix/**/* &
mplayer ~/Music/music/FromYoutube/matrix/* &
MPLAYER_PID=$!

# ( sleep 0.5; wmctrl -r glmatrix -b add,fullscreen; wmctrl -a glmatrix ) &
# 
# trap 'kill $MPLAYER_PID >/dev/null 2>&1; unset MPLAYER_PID; kill $UNCLUTTER_PID >/dev/null 2>&1; unset UNCLUTTER_PID; xset +dpms' INT TERM EXIT
# 
# /usr/lib/xscreensaver/glmatrix -fog -waves -rotate -clock

enterthematrix.py

echo "DONE"

[ -z $MPLAYER_PID ] || kill $MPLAYER_PID
[ -z $UNCLUTTER_PID ] || kill $UNCLUTTER_PID
xset +dpms

trap 'killall glmatrix' INT TERM EXIT
