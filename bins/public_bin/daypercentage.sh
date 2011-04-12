#! /bin/bash

H=$1
M=$2
S=$3
# H=$(date +%H)
# M=$(date +%M)
# S=$(date +%S)
echo $H:$M:$S

t=`expr $S + $M \* 60 + $H \* 60 \* 60`
echo $t

day_start=`expr 0 + 0 \* 60 + 0 \* 60 \* 60`
day_mid=`expr 0 + 0 \* 60 + 12 \* 60 \* 60`
day_end=`expr 0 + 0 \* 60 + 24 \* 60 \* 60`
echo $day_start
echo $day_mid
echo $day_end

if [ $t -lt $day_mid ]
then
brightness=`expr 100 \* $t / $day_mid`
else
brightness=`expr 100 \* \( $day_end - $t \) / $day_mid`
fi

echo $brightness

# ORIGINAL=`gconftool-2 --get /desktop/gnome/background/picture_filename`
# echo $ORIGINAL
# ORIGINAL_BASE=`gconftool-2 --get /desktop/gnome/background/picture_filename | xargs -0 basename`
# echo $ORIGINAL_BASE
# NEW=~/Pictures/wallpapers/_$ORIGINAL_BASE
# echo $NEW
# 
# convert $ORIGINAL -modulate $brightness $NEW
