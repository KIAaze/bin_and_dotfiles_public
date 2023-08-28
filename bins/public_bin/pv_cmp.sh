#!/bin/bash
set -eu

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
  echo "cmp with progress infos"
  echo "usage :"
  echo "`basename $0` file1 file2"
  exit 0
fi

pv "${1}" | cmp "${2}"
