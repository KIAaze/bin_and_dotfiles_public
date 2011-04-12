#!/bin/bash

# Usage example:
# find . \( ! -regex '.*/\..*' \) -type f | xargs -n1 -I{} spacify.sh {}

# if you want debug output
# set -x

set -eu

TMP=$(mktemp)

for FILE in "$@"
do
  echo "Processing $FILE"
  expand -i -t2 "$FILE" > $TMP
  mv $TMP "$FILE"
done
