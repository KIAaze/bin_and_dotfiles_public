#!/bin/bash

# files=(./*)

# echo ${#files[*]} 
# echo ${#files[@]}

TMP=$(mktemp)
echo "TMP = $TMP"

find . -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d '' filename; do
  echo $filename >>$TMP
done

# cat $TMP | xargs -0 -n1 du -ks
find . -maxdepth 1 -mindepth 1 -print0  | xargs -0 -n1 du -ks | sort -rn | head -16 | cut -f2 | xargs -i du -hs {}

# random_cow()
# {
#   files=(/usr/share/cowsay/cows/*)
#   printf "%s\n" "${files[RANDOM % ${#files}]}"
# }
# 
# ls -A 
# | grep -v -e '\''^\.\.$'\'' 
# |xargs -i du -ks {} 
# |sort -rn 
# |head -16 
# | awk '\''{print $2}'\'' | xargs -i du -hs {}
