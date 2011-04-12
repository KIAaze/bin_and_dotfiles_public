#!/bin/bash
set -eux
DIR1=$1
DIR2=$2
for f in $DIR1/*
do
	BASE=$(basename $f)
	if [ -f $DIR1/$BASE ]
	then
		echo "$DIR1/$BASE is a file"
		if [ -f $DIR2/$BASE ]
		then
			echo "$DIR2/$BASE is a file"
			if diff $DIR1/$BASE $DIR2/$BASE 1>/dev/null 2>&1
			then
				echo "Files do not differ."
			else
				echo "Files differ."
				meld $DIR1/$BASE $DIR2/$BASE
			fi
		else
			echo "$DIR2/$BASE is not a file"
		fi
	else
		echo "$DIR1/$BASE is not a file"
	fi
done
