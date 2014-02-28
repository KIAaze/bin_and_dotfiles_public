#!/bin/bash

# Displays a progress bar in the terminal going from 0 to 100% over $1 seconds in $2 steps.

set -eu

SECONDS=$1
NMAX=$2
SLEEPTIME=$(echo "scale=3; $SECONDS/$NMAX" | bc)

for ((i=0;i<=$NMAX;i++))
do
  float_percent=$(echo "scale=3; 100*$i/$NMAX" | bc)
  int_percent=$((100*$i/$NMAX))
  BARLENGTH=$(($(tput cols)-11))
  CURSOR=$(($BARLENGTH*$i/$NMAX))
  printf "%6.2f%% [" ${float_percent}
  for ((j=0;j<${CURSOR};j++))
  do
    printf "="
  done
  printf ">"
  for ((j=${CURSOR};j<$BARLENGTH;j++))
  do
    printf " "
  done
  printf "]\r"
  sleep ${SLEEPTIME}s
done
printf "\n"
