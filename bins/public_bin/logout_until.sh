#!/bin/bash
#set -eux

echo $(date)  >>$HOME/LU.log
echo $LINENO  >>$HOME/LU.log
$HOME/bin/forcelogout.sh on


echo $LINENO  >>$HOME/LU.log
sleep 1

echo $LINENO  >>$HOME/LU.log
$HOME/bin/logout.sh
echo $LINENO  >>$HOME/LU.log
# pkill -KILL -v pkill
