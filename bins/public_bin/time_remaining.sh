#! /bin/bash
H=$(date +%H)
M=$(date +%M)

Hlim=$1
Mlim=$2

cur_time=$(expr 60 \* $H + $M )
time_limit=$(expr 60 \* $Hlim + $Mlim )

echo cur_time=$cur_time
echo time_limit=$time_limit

if [ $cur_time -le $time_limit ]
then
echo "cur_time<time_limit"
remaining=$( expr $time_limit - $cur_time )
echo remaining=$remaining
else
echo "cur_time>time_limit"
remaining=$( expr 1440 - $cur_time + $time_limit )
echo remaining=$remaining
fi

remaining_hours=$( expr $remaining / 60 )
remaining_minutes=$( expr $remaining - 60 \* $remaining_hours )

echo remaining_hours=$remaining_hours
echo remaining_minutes=$remaining_minutes

$HOME/bin/totalnotify.sh "You have $remaining_hours hours and $remaining_minutes minutes left."
