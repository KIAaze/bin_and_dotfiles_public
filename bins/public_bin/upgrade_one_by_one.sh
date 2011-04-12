#!/bin/bash
if [ $# -ne 1 ]
then
	echo "usage : $0 <upgradable.txt>"
	exit 0 
fi

FILE=$1
cp -v $FILE $FILE.$(date +%Y%m%d_%H%M%S)

sed -i 's/ \+/\n/g' $FILE
sed -i '/^$/ d' $FILE

PROG=`head -n1 $FILE`

while test ! -z $PROG
do
echo "=== UPGRADING $PROG ==="
df -h /
sudo apt-get install $PROG && sudo apt-get clean && sed -i '/'$PROG'/ d' $FILE
if [ ! $? -eq 0 ]
then
echo "THERE WAS AN ERROR. EXITING."
exit 1
fi
PROG=`head -n1 $FILE`
done

exit 0
