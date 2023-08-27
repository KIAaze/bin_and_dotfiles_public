#!/bin/bash

# meant to be used in this way:
# rsync_move.sh {/somewhere/mysrc,/else/mybackup}/mydir/
# slashes will get added at the end of SRC and DST
# DST will be created if missing
# contents of SRC and DST will be compared before removal of files from SRC

set -eux

proceed()
{
  echo "Proceed $1"
  read ans
  case ${ans} in
    y) echo "Proceeding.";;
    *) exit;;
  esac
}

SRC="${1}"
DST="${2}"

SRC="${SRC%/}/" # remove any trailing "/", then add it
DST="${DST%/}/" # remove any trailing "/", then add it

if ! test -d "${DST}"
then
  echo "Destination directory does not exist."
  echo "DST = ${DST}"
  echo "create? (y/n)"
  read ans
  case $ans in
    y|Y|yes) mkdir --parents "${DST}";;
    *) exit -1;;
  esac
fi

test -d "${SRC}"
test -d "${DST}"

echo "SRC = ${SRC}"
echo "DST = ${DST}"

proceed "with rsync?"
rsync --archive --compress "${SRC}" "${DST}"

proceed "with ds-diff.sh?"
ds-diff.sh "${SRC}" "${DST}"

proceed "with rsync --remove-source-files?"
rsync --archive --compress --remove-source-files "${SRC}" "${DST}"

proceed "with removeEmptyDirectories.py?"
removeEmptyDirectories.py "${SRC}"

proceed "with rmdir?"
rmdir "${SRC}"
