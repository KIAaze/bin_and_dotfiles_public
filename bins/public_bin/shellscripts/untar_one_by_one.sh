#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo
	echo "usage :"
	echo "$0 tarfile"
	echo
	exit 0 
fi

#delete previous log files eventually
rm out.log >/dev/null 2>&1
rm err.log >/dev/null 2>&1

#start extracting files (empty folders are excluded)
echo "======================"
echo "contents (only files):"
echo "======================"

for f in `tar -tzf $1 | grep -v '\/$'`;
do
	echo "$f"
        tar -xkzvf $1 $f 1>>out.log 2>>err.log        
done

#display log files
echo "========"
echo "out.log:"
echo "========"
cat out.log

echo "========"
echo "err.log:"
echo "========"
cat err.log
