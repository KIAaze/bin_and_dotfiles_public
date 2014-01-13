#!/usr/bin/env bash

# TODO: display multiple animated gifs with transparency over desktop, with sound: desktop nuclear annihilation! :D

for (( i = 0 ; i <= 10 ; i++ ))
do
  for (( j = 0 ; j <= 10 ; j++ ))
  do
    x=$(expr 200 \* $i)
    y=$(expr 200 \* $j)
    echo "x=$x y=$y"
    xteddy -geometry +$x+$y &
  done
done

echo "sleeping..."
sleep 5s
echo "killing..."
killall xteddy
