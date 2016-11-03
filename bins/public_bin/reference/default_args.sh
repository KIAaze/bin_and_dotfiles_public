#!/bin/bash

set -eu

NMIN=${1:-123}
NMAX=${2:-456}

echo "NMIN=${NMIN}"
echo "NMAX=${NMAX}"

for (( N = ${NMIN} ; N <= ${NMAX} ; N++ ))
do
  NSTR=$(printf "%02d" ${N})
  echo "=== N = ${NSTR} ==="
done

