#!/bin/bash
set -eu
datefull=$(date +%Y%m%d_%H%M%S)

for FILE in "$@"
do
  FULLPATH=$(readlink -f $FILE)
  BASE=$(basename $FILE)
#   echo FULLPATH=$FULLPATH
#   echo BASE=$BASE
  mv -v $FULLPATH{,.$datefull}
done
