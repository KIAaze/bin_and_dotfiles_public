#!/bin/bash
echo "size in kB,%mem,pid,user"
if [ $# -eq 0 ]
then
	ps -eo rss,%mem,pid,user -o comm= | sort -k1 -n -r 
else
	for prog in $@;
	do
		ps -eo rss,%mem,pid,user -o comm= | grep $prog
	done
fi
