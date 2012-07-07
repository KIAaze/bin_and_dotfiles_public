#!/bin/bash

sum()
{
    ret=`expr $1 + $2`
    #echo $ret
    return $ret
}

sum 3 5
echo $?

echo $toto
toto=0
if [ $toto ]
then
echo "toto on"
else
echo "toto off"
fi

if [ [ 2 -eq 2 -o 0 -eq 1 ] -a [ 2 -eq 3 ] ]
then
echo "yes"
else
echo "no"
fi
