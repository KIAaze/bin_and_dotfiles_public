#!/bin/bash

set -u

if [ $# -ne 3 ]
then
  echo "usage :"
  echo "`basename $0` NFILES_MIN NFILES_MAX DIR"
  echo "Checks the number of files in the directory DIR at regular intervals and shows a corresponding progress bar going from NFILES_MIN to NFILES_MAX."
  exit 0
fi

DIR=$3
NFILES_MIN=$1
NFILES=$(ls -1 "$DIR" | wc -l)
NFILES_MAX=$2

(
  while test $NFILES -ne $NFILES_MAX;
  do
    sleep 1s
    NFILES=$(ls -1 "$DIR" | wc -l)
    echo $(echo "scale=3; 100*($NFILES-$NFILES_MIN)/($NFILES_MAX-$NFILES_MIN)" | bc);
  done
) | zenity --progress --auto-close

zenity --info --text="DONE"
