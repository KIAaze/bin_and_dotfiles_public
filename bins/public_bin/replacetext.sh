#! /bin/bash
find . -name $1
for f in $1;
do
        echo "$f->$base.eps"
done
