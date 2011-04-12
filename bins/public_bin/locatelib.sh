#! /bin/bash
for f in *;
do
	var=$(nm "$f" 2>/dev/null | grep -c $1)
	if test $var -ne 0
	then
		echo "$f"
		nm "$f" 2>/dev/null | grep $1
	fi
done

