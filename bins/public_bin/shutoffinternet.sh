#!/bin/sh

isup="$( /bin/cat /etc/network/run/ifstate | /bin/grep -c eth1 )"
if [ "$isup" -gt 0 ] ; then
/sbin/ifdown eth1
fi

