#! /bin/bash

files=`ls -d */`

for f in $files;
do
	dirname $f
done

