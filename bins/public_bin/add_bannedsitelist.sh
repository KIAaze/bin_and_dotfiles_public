#!/bin/bash
if ! [ -s $1 ]
then
    echo "ERROR: File does not exist or is empty"
    exit 1
fi

TMP1=/tmp/$1
TMP2=/tmp/$1.cmd

CMD='sudo /root/totalcontrol/add_bannedsite.sh'

cp $1 $TMP1
sed -i 's/\r\+/\n/g' $TMP1 >/dev/null #remove carriage returns
sed -i '/google/d' $TMP1 >/dev/null #remove google URLs
sed -i '/yahoo/d' $TMP1 >/dev/null #remove yahoo URLs
sed -i 's/^http:\/\///' $TMP1 >/dev/null #remove http://
sed -i 's/^https:\/\///' $TMP1 >/dev/null #remove https://
sed -i 's/^www\.//' $TMP1 >/dev/null #remove www.
sed -i 's/\/.*$//' $TMP1 >/dev/null #remove end of url to keep only domain
sort -u $TMP1 -o $TMP1 #sort and remove duplicates

echo "=====SITES====="
cat $TMP1
echo "==============="

sed -i '1i '"$CMD"'' $TMP1 >/dev/null
tr '\n' ' ' <$TMP1 >$TMP2
echo >>$TMP2

echo "====COMMAND===="
cat $TMP2
echo "==============="

echo "Execute command?"
read ans
case $ans in
  y|Y|yes) bash $TMP2 && exit 0;;
  *) exit 1;;
esac
