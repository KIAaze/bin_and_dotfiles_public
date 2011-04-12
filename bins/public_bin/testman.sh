#!/bin/bash
# Check if all parameters are present
# If no, exit
if [ $# -ne 1 ]
then
	echo "displays man pages for testing"
        echo "usage :"
        echo "`basename $0` file"
        exit 0
fi

groff -Tascii -man $1 | more

