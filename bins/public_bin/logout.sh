#!/bin/bash
#How to kill and logout user $1

if [ $# -eq 0 ]
then
pkill -KILL -u $USER
fi

if [ $# -eq 1 ]
then
pkill -KILL -u $1
fi

echo "usage : $0 [username]"
exit 0
