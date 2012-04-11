#!/bin/sh
APP="/usr/bin/esd"
ARGS="-nobeeps"
if [ `pidof $APP` ]; then
#Do Nothing - already running
return
else
$APP $ARGS&
fi;

