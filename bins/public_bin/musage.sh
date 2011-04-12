#! /bin/bash
# get RAM usage of a program

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 progname"
	echo "This shellscript will display the RAM usage of $progname"
        echo
        exit 0
fi

# ps -eo %mem,pid,user -o comm= | grep $progname | sort -k1 -n -r | head -1 | awk '{ print $1 }'
ps -eo vsz,rss,pid,user -o comm= | grep $1
