#!/bin/bash
set -e -u -x
YEAR=2009

months[0]=Jan
months[1]=Feb
months[2]=Mar
months[3]=Apr
months[4]=May
months[5]=Jun
months[6]=Jul
months[7]=Aug
months[8]=Sep
months[9]=Oct
months[10]=Nov
months[11]=Dec



echo $CURMON
echo $NEXTMON
echo $YEAR
#git log --after="$CURMON 1 $YEAR" --before="$NEXTMON 1 $YEAR"
