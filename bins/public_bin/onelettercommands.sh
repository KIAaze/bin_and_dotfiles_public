#!/bin/bash
for x in {a..z}
do
	if which $x 2>/dev/null
	then
		echo "$x"
	#else
		#echo "not OK"
	fi
done
