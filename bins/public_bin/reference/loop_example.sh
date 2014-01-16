#! /bin/bash
files=`find . -name "*.sh"`

for f in $files;
do
	echo $f
done

files="file1 file2 foo bar nice_image"

for f in $files;
do
	echo $f
done

for (( index = 0 ; index <= 10 ; index++ ))
do
	echo $index
done

# zenity progress bar examples
for ((i=0;i<=100;i++)); do echo $i; sleep 0.1s; done | zenity --progress

for ((i=0;i<=12;i++)); do echo $(bashcalc.sh 100*$i/12); sleep 0.1s; done | zenity --progress

for ((i=0;i<=12;i++)); do echo $(echo "scale=3; 100*$i/12" | bc); sleep 0.4s; done | zenity --progress

(
for ((i=0;i<=12;i++))
do
        echo $(echo "scale=3; 100*$i/12" | bc)
        sleep 0.4s
done
) | zenity --progress
