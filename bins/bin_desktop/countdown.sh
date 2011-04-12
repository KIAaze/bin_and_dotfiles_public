#!/bin/bash

set -u

export DISPLAY=:0.0

#SIZE=240
SIZE=480

# Check if all parameters are present
# If no, exit
if ( [[ $# -lt 1 ]] || [[ $# -gt 2 ]] )
then
        echo "usage :"
        echo "`basename $0` time_in_seconds [size of text]"
	echo "size should be around 240"
	echo "default size = $SIZE"
        exit 0
fi

echo "setting X"
X=$1

echo "setting size"
if [ $# -eq 2 ]; then SIZE=$2; fi

# exit 0

while [ $X -gt -1 ]
do
    echo $X
    #beep
    echo "$X" | osd_cat -s 10 -c green -p top -A right -f -adobe-helvetica-bold-r-normal-*-*-$SIZE-*-*-p-*-*-* -d 1
#     sleep 1
    X=`expr $X - 1`
done

# echo "Notifying user."
$HOME/bin/totalnotify.sh "TIME IS OVER"
