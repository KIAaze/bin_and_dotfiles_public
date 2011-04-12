#!/bin/bash

if [ $# -ne 2 ]
then
        echo "Creates empty files numbered from temp_min to temp_max."
        echo "usage : $0 min max"
        exit 0
fi

for (( i = $1 ; i <= $2 ; i++ ))
#        for i in `seq 1 $1`;
        do
                echo $i
                touch temp_$i
        done
