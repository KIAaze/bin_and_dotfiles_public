#!/bin/bash
# Get last parameter (destination), then loop through all previous parameters (source files)
echo "Nargs = $#"

echo "Last arg = ${!#}"

NUM=$#
for (( index = 0 ; index < $(($NUM-1)) ; index++ ))
do
        echo $1
	shift
done
