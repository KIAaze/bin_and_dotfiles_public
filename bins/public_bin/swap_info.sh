#!/bin/bash
for file in /proc/*/status ; do
 awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; 
done
