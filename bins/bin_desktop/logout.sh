#!/bin/bash
#How to kill and logout user $1

if [ $# -eq 0 ]
then
skill -KILL -u $USER
fi

if [ $# -eq 1 ]
then
skill -KILL -u $1
fi

echo "usage : $0 [username]"
exit 0
