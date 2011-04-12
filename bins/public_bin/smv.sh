#!/bin/bash
set -e -u -x
rsync -rv --remove-source-files "$1" $USER_flast@HOST_A:"$2"
cd "$1"
cleanlinks
cd ..
rmdir "$1"

