#!/bin/bash
set -eu

# Check if all parameters are present
# If no, exit
if [ $# -eq 0 ]
then
  git pull && git push && git status
else
  for i in "$@"
  do
    echo "=== remote=${i} ==="
    git pull "${i}" master
    git push "${i}" master
    git status
  done
fi
