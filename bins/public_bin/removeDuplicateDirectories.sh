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

source ${HOME}/bin/public_bin/library/colors.sh

# if diff --recursive "${1}" "${2}"
# then
#   echo rm --recursive "${2}"
# else
#   echo "ERROR: Directories are different"
# fi

if diff --recursive "${1}" "${2}"
then
  echo -e "=====> diff test: ${green}PASSED${defaultcolor}"
else
  echo -e "=====> diff test: ${red}FAILED${defaultcolor}"
  exit 1
fi

if ds-diff.sh "${1}" "${2}"
then
  echo -e "=====> ds-diff.sh test: ${green}PASSED${defaultcolor}"
else
  echo -e "=====> ds-diff.sh test: ${red}FAILED${defaultcolor}"
  exit 1
fi

if meld "${1}" "${2}"
then
  echo -e "=====> meld test: ${green}PASSED${defaultcolor}"
else
  echo -e "=====> meld test: ${red}FAILED${defaultcolor}"
  exit 1
fi

echo "remove ${2}?"
read ans
case $ans in
  y|Y|yes) rm --recursive "${2}";;
  *) echo "Nothing done.";;
esac
