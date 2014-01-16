#!/bin/bash

set -u

if [ $# -ne 2 ]
then
  echo "usage :"
  echo "`basename $0` NFILES_MIN NFILES_MAX"
  echo "Checks the number of files in the current folder at regular intervals and shows a corresponding progress bar going from NFILES_MIN to NFILES_MAX."
  exit 0
fi

NFILES_MIN=$1
NFILES=$(ls -1 | wc -l)
NFILES_MAX=$2

(
  while test $NFILES -ne $NFILES_MAX;
  do
    sleep 1s
    NFILES=$(ls -1 | wc -l)
    echo $(echo "scale=3; 100*($NFILES-$NFILES_MIN)/($NFILES_MAX-$NFILES_MIN)" | bc);
  done
) | zenity --progress --auto-close

zenity --info --text="DONE"
