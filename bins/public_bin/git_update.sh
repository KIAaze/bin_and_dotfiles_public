#!/usr/bin/env bash
set -u
for BRANCH in $@
do
  echo "=== $BRANCH ==="
  git checkout $BRANCH && git pull && git push && git status
done
