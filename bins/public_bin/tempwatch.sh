#! /bin/bash
# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 max_temp"
	echo "This shellscript will kill the most CPU-intensive process if the temperature goes above max_temp"
        echo
        exit 0
fi

while true
do
	sleep 1
	temp=$(cat /proc/acpi/thermal_zone/THRM/temperature | sed -e 's/[^0-9]//g')
	if test $temp -ge $1
	then
		USAGE=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $1 } '`
		PID=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $2 }'`
		PNAME=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{print $3 }'`
		echo date >>tempwatch.log
		echo "too hot: $temp C" >>tempwatch.log
		echo $USAGE >>tempwatch.log
		echo $PID >>tempwatch.log
		echo $PNAME >>tempwatch.log
		killall $PNAME >>tempwatch.log 2>&1
	fi
done

