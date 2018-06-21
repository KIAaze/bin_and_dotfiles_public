#!/bin/bash
set -eu

INTERACTIVE=1

for i in "$@";
do
  echo "=== Processing ${i} ===";
  
  # check existence
  if ! test -f "${i}"
  then
    echo "${i} does not exist or is not a regular file."
    exit 1
  fi
  
  # extract
  EXTRACTED=0
  if which atool &>/dev/null
  then
    atool -x "${i}" && EXTRACTED=1
  else
    DST=$(splitext.py "${i}")
    unzip -d "${DST}" "${i}" && EXTRACTED=1
    echo "Extracted to ${DST}"
  fi
  
  # exit on failure
  if [ ${EXTRACTED} -ne 1 ]
  then
    echo "Error processing ${i}"
    exit 1
  fi
  
  # remove zip file
  if [ ${INTERACTIVE} -eq 0 ]
  then
    rm --verbose "${i}";
  else
    echo "Remove ${i}? (y/n/a/q)"
    read ans
    case $ans in
      y) rm --verbose "${i}";;
      n) echo "Leaving ${i}";;
      a) INTERACTIVE=0 && rm --verbose "${i}";;
      q) exit 0;;
      *) rm -i --verbose "${i}";;
    esac
  fi
done
