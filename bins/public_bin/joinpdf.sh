#!/bin/bash

# Check if all parameters are present
# If no, exit
if [ $# -lt 2 ]
then
        echo "usage :"
        echo "`basename $0` out in1 in2 ..."
        exit 0
fi

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$@"
