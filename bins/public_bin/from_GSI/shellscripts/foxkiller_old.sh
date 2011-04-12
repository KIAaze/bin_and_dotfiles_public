#! /bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
        echo
        echo "usage :"
        echo "$0 max_time"
	echo "This shellscript will kill all firefox, konqueror and lynx processes if timer.txt contains a number greater than max_time"
        echo "To allow browser usage for x seconds, run \"foxkiller.sh 60\" for example."
        echo
        echo "Now using default max_time=5."
        echo
        max_time=5;
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
	time=$(cat timer.txt)
	if test $time -ge $max_time
	then
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
          cp timer.txt tmp
          sed s/$time/0/ tmp >timer.txt
          echo "time reset"
        else
          newtime=`expr $time + 1`
          cp timer.txt tmp
          sed s/$time/$newtime/ tmp >timer.txt
          echo $newtime
	fi
done
