#!/usr/bin/env bash
set -ux
if ps aux | grep "/bin/bash $PATH_TO_NIGHTLY" | grep -v grep
then
  N=$(ps aux | grep "/bin/bash $PATH_TO_NIGHTLY" | grep -v grep | awk '{print $2}')
  echo "N=$N"
  kill -9 $N
fi
echo "current status"
ps aux | grep night
