#!/bin/bash

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
