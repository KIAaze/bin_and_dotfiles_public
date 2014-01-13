#! /bin/bash

var1=$(cat /proc/cpuinfo | grep -c sse)
var2=$(cat /proc/cpuinfo | grep -c sse2)

if [ $var1 -eq 0 -o $var1 -eq 0 ]
then
  echo "ERROR: Processor does NOT support sse or sse2.";
  exit -1;
else
  echo "Processor does support sse and sse2.";
  exit 0;
fi
