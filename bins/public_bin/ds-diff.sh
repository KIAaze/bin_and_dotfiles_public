#!/bin/bash
set -eu

DIR1=${1}
DIR2=${2}

S1=$(ds.sh ${DIR1})
N1=$(find ${DIR1} | wc -l)
echo "==> ${DIR1}"
echo "Total size: ${S1}"
echo "Number of files: ${N1}"

S2=$(ds.sh ${DIR2})
N2=$(find ${DIR2} | wc -l)
echo "==> ${DIR2}"
echo "Total size: ${S2}"
echo "Number of files: ${N2}"

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
  echo "Number of files: OK"
else
  echo "Number of files: not OK"
  delta=$(expr ${N2} - ${N1})
  echo "N2-N1 = ${delta}"
  exit 1
fi
