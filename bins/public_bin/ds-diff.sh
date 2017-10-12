#!/bin/bash
set -eu

# TODO: ssh support for faster operations
# TODO: find options to skip symlinks and specific directories for example

DIR1=${1}
DIR2=${2}

S1=$(ds.sh ${DIR1})
N1=$(find ${DIR1} | wc -l)
N1_FILES=$(find ${DIR1} -type f | wc -l)
N1_DIRS=$(find ${DIR1} -type d | wc -l)
echo "==> ${DIR1}"
echo "Total size: ${S1}"
echo "Number of files and directories: ${N1}"
echo "Number of files: ${N1_FILES}"
echo "Number of directories: ${N1_DIRS}"

S2=$(ds.sh ${DIR2})
N2=$(find ${DIR2} | wc -l)
N2_FILES=$(find ${DIR2} -type f | wc -l)
N2_DIRS=$(find ${DIR2} -type d | wc -l)
echo "==> ${DIR2}"
echo "Total size: ${S2}"
echo "Number of files and directories: ${N2}"
echo "Number of files: ${N2_FILES}"
echo "Number of directories: ${N2_DIRS}"

echo "---"
if test "${S1}" = "${S2}"
then
  echo "Total size: OK"
else
  echo "Total size: not OK"
  exit 1
fi

if test ${N1} -eq ${N2}
then
  echo "Number of files and directories: OK"
else
  echo "Number of files and directories: not OK"
  delta=$(expr ${N2} - ${N1})
  echo "N2-N1 = ${delta}"
  exit 1
fi

if test ${N1_FILES} -eq ${N2_FILES}
then
  echo "Number of files: OK"
else
  echo "Number of files: not OK"
  delta=$(expr ${N2_FILES} - ${N1_FILES})
  echo "N2_FILES-N1_FILES = ${delta}"
  exit 1
fi

if test ${N1_DIRS} -eq ${N2_DIRS}
then
  echo "Number of directories: OK"
else
  echo "Number of directories: not OK"
  delta=$(expr ${N2_DIRS} - ${N1_DIRS})
  echo "N2_DIRS-N1_DIRS = ${delta}"
  exit 1
fi
