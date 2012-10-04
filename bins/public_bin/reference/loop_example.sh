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
