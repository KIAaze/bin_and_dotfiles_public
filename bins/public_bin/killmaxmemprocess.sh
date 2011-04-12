#! /bin/bash
# kill the most memory intensive user process

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 license_to_kill"
	echo "This shellscript will kill the most memory intensive user process if license_to_kill!=0."
	echo "Otherwise, it just locates it without killing it."
	echo "All missions will be logged in memwatch.log."
        echo
        exit 0
fi

USAGE=`ps -eo %mem,pid,user -o comm= | grep $USER | sort -k1 -n -r | head -1 | awk '{ print $1 } '`
PID=`ps -eo %mem,pid,user -o comm= | grep $USER | sort -k1 -n -r | head -1 | awk '{print $2 }'`
PNAME=`ps -eo %mem,pid,user -o comm= | grep $USER | sort -k1 -n -r | head -1 | awk '{print $4 }'`

echo $(date)
echo "Hostile process detected:"
echo "memory used: $USAGE%"
echo "PID: $PID"
echo "Name: $PNAME"

echo "=========================" >>memwatch.log
echo $(date) >>memwatch.log
echo "Hostile process detected:" >>memwatch.log
echo "memory used: $USAGE%" >>memwatch.log
echo "PID: $PID" >>memwatch.log
echo "Name: $PNAME" >>memwatch.log

if [ $1 -ne 0 ]
then
	echo "killing process..." >>memwatch.log

	kill_1=0
	kill_2=0

	#clean kill
	killall $PNAME
	if [ $? -eq 0 ]
	then
		kill_1=1
	fi

	#messy kill
	kill -9 $PID
	if [ $? -eq 0 ]
	then
		kill_2=1
	fi

	if [ $kill_1 -eq 1 ] || [ $kill_2 -eq 1 ]
	then
		echo "Target successfully eliminated." >>memwatch.log
		echo "kill_1=$kill_1" >>memwatch.log
		echo "kill_2=$kill_2" >>memwatch.log
		zenity --info --text "$PNAME was killed because of excessive RAM usage.\n kill_1=$kill_1 \n kill_2=$kill_2" ||
		kdialog --msgbox "$PNAME was killed because of excessive RAM usage.\n kill_1=$kill_1 \n kill_2=$kill_2" ||
		xmessage -buttons okay -default okay "$PNAME was killed because of excessive RAM usage.\n kill_1=$kill_1 \n kill_2=$kill_2" &
	else
		echo "Mission failed." >>memwatch.log
	fi
	
# 	#messy kill
# 	kill -9 $PID
# 	if [ $? -eq 0 ]
# 	then
# 		echo "Target successfully eliminated." >>memwatch.log
# 		zenity --info --text "$PNAME was killed because of excessive RAM usage." ||
# 		kdialog --msgbox "$PNAME was killed because of excessive RAM usage." ||
# 		xmessage -buttons okay -default okay "$PNAME was killed because of excessive RAM usage."
# 	else
# 		echo "kill -9 failed." >>memwatch.log
# 	fi

fi
