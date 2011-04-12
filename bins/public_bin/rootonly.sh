#!/bin/bash
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
else
   echo "You are root."
fi

if [[ -w / ]]
then
	echo "/ is writable"
else
	echo "/ is NOT writable"
fi
