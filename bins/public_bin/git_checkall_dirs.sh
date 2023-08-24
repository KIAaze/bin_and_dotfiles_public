#!/bin/bash
# Simple script to pull+push in provided directories.
set -eu

for i in "$@"
do
  echo "=== ${i} ==="
  cd "${i}"
  git pull
  git push
  git status
  cd -
done
