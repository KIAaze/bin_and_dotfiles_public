#!/bin/bash
set -eu

# Check if all parameters are present
# If no, exit
if [ $# -ne 2 ]
then
        echo "usage :"
        echo "`basename $0` DIR1 DIR2"
        exit 0
fi

# if diff --recursive "${1}" "${2}"
# then
#   echo rm --recursive "${2}"
# else
#   echo "ERROR: Directories are different"
# fi

if diff --recursive "${1}" "${2}"
then
  echo "diff test: PASSED"
else
  echo "diff test: FAILED"
fi

if ds-diff.sh "${1}" "${2}"
then
  echo "ds-diff.sh test: PASSED"
else
  echo "ds-diff.sh test: FAILED"
fi

if meld "${1}" "${2}"
then
  echo "meld test: PASSED"
else
  echo "meld test: FAILED"
fi
