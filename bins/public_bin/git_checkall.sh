#!/bin/bash
set -eu

BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if all parameters are present
# If no, exit
if [ $# -eq 0 ]
then
  git pull && git push && git status
else
  for i in "$@"
  do
    echo "=== remote=${i} ==="
    git pull "${i}" "${BRANCH}"
    git push "${i}" "${BRANCH}"
    git status
  done
fi
