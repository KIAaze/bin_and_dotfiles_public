#!/bin/bash
# set nono to ko,ki or ka based on interactive user input. Use ctrl+D to exit.
select nono in ko ki ka;
do
	echo "nono = $nono";
	echo "REPLY = $REPLY";
done
