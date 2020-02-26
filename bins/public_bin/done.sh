#!/bin/bash
# simple script to easily log done things, no matter how trivial (and keep a command ready for the current single task at hand)
LOGDIR=${HOME}/log/done
mkdir --parents "${LOGDIR}"

LOGFILE="${LOGDIR}/done.$(date +%Y-%m-%d).txt"

if [ $# -lt 1 ]
then
  if test -e "${LOGFILE}"
  then
    cat "${LOGFILE}"
  else
    echo "Nothing done yet. Pick a task and get started!"
  fi
else
  for i in "${@}"
  do
    echo $(date +%H:%M:%S) ${i} >> ${LOGFILE}
  done
fi
