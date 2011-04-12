#!/bin/bash
DIR1=$1
DIR2=$2
for FILE in $(ls -1 $DIR1/*.h $DIR1/*.cpp | grep -v ui_ | grep -v moc_)
do
#   diff $FILE $DIR2/$FILE
  if ! diff $FILE $DIR2/$FILE 1>/dev/null 2>&1
  then
    echo "== $FILE =="
    #diff $FILE $DIR2/$FILE
    #read ans
  fi
done
