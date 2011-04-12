#!/bin/bash
set -eu
OUT=$(mktemp)

for IN in "$@";
do
  echo "Processing $IN"
  iconv -f UTF-8 -t ISO-8859-1 $IN > $OUT
  mv $OUT $IN
done
