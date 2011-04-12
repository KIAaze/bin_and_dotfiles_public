#!/bin/bash
#set -x
set -e

#sudo apt-get -o dir::cache::archives="/the/path/to/temporary/cache/" install packagename

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo "usage :"
        echo "`basename $0` CACHEDIR"
        exit 0
fi

mkdir -p "$1"/partial
if [ -d "$1" ] && [ -d "$1"/partial ]
then
	sudo apt-get -o dir::cache::archives="$1" update
	sudo apt-get -o dir::cache::archives="$1" upgrade
	echo "DONE"
else
	echo "Incorrect directory structure."
fi
