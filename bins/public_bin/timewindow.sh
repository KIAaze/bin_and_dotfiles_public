#! /bin/bash -e
#This script returns 0 if Hmin:Mmin<=H:M<=Hmax:Mmax and 1 otherwise
#It also works with inverse timewindows where Tmax<Tmin :)

if [ $# -ne 4 ]
then
	echo "This script returns true (exit 0) if Hmin:Mmin<=H:M<=Hmax:Mmax where H:M is the current time."
	echo "Otherwise it returns false (exit 1)."
	echo "usage : $0 Hmin Mmin Hmax Mmax"
	echo "It also works with inverse timewindows where Tmax<Tmin :)"
	exit 0 
fi

# Because expr exits with 1 if the result is 0, we need to use a special test to avoid exiting when using bash -e
time_in_minutes()
{
	if [ $1 -eq 0 ] && [ $2 -eq 0 ];
	then
		echo 0
	else
		echo `expr 60 \* $1 + $2`
	fi
}

#timewindow function that works with normal timewindows (Tmin<=Tmax)
normaltimewindow()
{
	if [ $1 -le $2 ] && [ $2 -le $3 ];
	then
		echo "we are inside the time window"
		return 0
	else
		echo "we are outside the time window"
		return 1
	fi;
}

H=`date +%H`
M=`date +%M`

Hmin=$1
Mmin=$2

Hmax=$3
Mmax=$4

T=$(time_in_minutes $H $M)
echo "T=$T"

Tmin=$(time_in_minutes $Hmin $Mmin)
echo "Tmin=$Tmin"

Tmax=$(time_in_minutes $Hmax $Mmax)
echo "Tmax=$Tmax"

if [ $Tmin -le $Tmax ]
then
	echo "normal timewindow"
	if (normaltimewindow $Tmin $T $Tmax)
	then
		echo "we are inside the normal timewindow"
		exit 0
	else
		echo "we are outside the normal timewindow"
		exit 1
	fi
else
	echo "inverse timewindow"
	#Note: 1440=24:00
	if (normaltimewindow 0 $T $Tmax) || (normaltimewindow $Tmin $T 1440)
	then
		echo "we are inside the inverse timewindow"
		exit 0
	else
		echo "we are outside the inverse timewindow"
		exit 1
	fi
fi
