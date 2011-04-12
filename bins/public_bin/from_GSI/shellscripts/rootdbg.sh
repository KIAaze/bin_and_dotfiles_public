#!/bin/sh

base=$(basename $1 .C)

echo Executing $1. Saving output in $base.out and errors in $base.err.
root -l -q $1 1>$base.out 2>$base.err

grep -i "error" $base.out
grep -i "error" $base.err
grep "Macro finished succesfully." $base.out
#(echo .x $1 | root -l -q)
#(echo .x $1 | root -l -q) 1>$1.out 2>$1.err
