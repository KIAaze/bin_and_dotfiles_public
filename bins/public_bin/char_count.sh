#!/bin/bash
#counts the number of characters per line

# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo "counts the number of characters per line"
        echo "usage :"
        echo "`basename $0` [FILE]"
        exit 0
fi

n=0;
while read line;
do
echo -n "$((n=$((n + 1)))) -> ";
echo "$line" | wc -c;
done <$1 1>/tmp/out.txt

echo "==========="
cat -n $1
echo "==========="
cat /tmp/out.txt
echo "==========="
