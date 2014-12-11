#! /bin/bash

default_max_time=15

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 max_time"
	echo "This shellscript will kill all firefox, konqueror and lynx processes max_time seconds after their launch."
        echo "To allow browser usage for x seconds, run \"foxkiller.sh 60\" for example."
        echo
        echo "Now using default max_time=$default_max_time."
        echo
        max_time=$default_max_time;
#exit 0
else
        max_time=$1;
fi

#create a timer.txt file if it doesn't exist
if [ ! -f timer.txt ]
then
echo "timer.txt not found. Creating it..."
cat >timer.txt <<\_ACEOF
0
_ACEOF
fi

#launch killer spree
while true
do
	sleep 1
        var=$(ps -u $USER_flast | egrep -c 'konqueror|firefox-bin|lynx')
        if [ $var -ne 0 ]
        then
          echo "Browser usage detected. Starting termination process."
          echo "You don't know it yet, but you're already dead."
          sleep $max_time
          killall konqueror 2>/dev/null
          if [ $? -eq 0 ]
          then
            echo "konqueror terminated." >>frags.txt
          fi
          killall firefox-bin 2>/dev/null
          if [ $? -eq 0 ]
          then
            echo "firefox terminated." >>frags.txt
          fi
          killall lynx 2>/dev/null
          if [ $? -eq 0 ]
          then
            echo "lynx terminated." >>frags.txt
          fi          
        fi
done
