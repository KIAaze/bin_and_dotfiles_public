#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

FILES=$(ls | while read x; do echo "`expr $RANDOM % 1000`:$x"; done      | sort -n| sed 's/[0-9]*://' | head -3)

#note: "sort -R FILES" works too to sort files randomly.

for i in $FILES
do
  vlc "$i" &
  sleep 1
done

# restore $IFS
IFS=$SAVEIFS
