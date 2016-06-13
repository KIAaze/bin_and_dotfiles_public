#!/bin/sh
echo Executing $1.C. Saving output in $1.out and errors in $1.err.
root -l -q $1.C 1>$1.out 2>$1.err
cat $1.out | grep "Macro finished successfully."
#(echo .x $1 | root -l -q)
#(echo .x $1 | root -l -q) 1>$1.out 2>$1.err
