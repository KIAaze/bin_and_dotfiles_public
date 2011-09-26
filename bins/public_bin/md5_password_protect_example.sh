#!/bin/bash
set -eux

#getting hash from password
#$  echo hello | md5sum
#b1946ac92492d2347c6235b4d2611184  -

#$ echo -n hello | md5sum
#5d41402abc4b2a76b9719d911017c592  -

#$ md5sum <<< hello
#b1946ac92492d2347c6235b4d2611184  -

echo "password"
read x;
#rm -iv /tmp/tmpfifo;
#mkfifo /tmp/tmpfifo;
#echo $x > tmpfifo;

#echo $x | md5sum
#echo -n $x | md5sum
#md5=$(echo md5sum <<< $x)
#md5=$(echo $x | md5sum | awk '{print $1;}');
md5=$(echo -n $x | md5sum | awk '{print $1;}');

if [ $md5 == "5d41402abc4b2a76b9719d911017c592" ]
#if [ $md5 == "b1946ac92492d2347c6235b4d2611184" ]
then
	echo SUCCESS
else
	echo FAILURE
fi

