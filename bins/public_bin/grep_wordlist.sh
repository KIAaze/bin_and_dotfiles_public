#!/bin/bash
set -u
WORDLIST=$1
DIR=$2
for word in $(grep -v "^#" $WORDLIST);
do
  echo "=== Searching for $word ==="
  #ack -rlia "$word" $DIR;
  #ack -rli "$word" $DIR;
  #ack --ignore-dir=third_party --ignore-dir=community_scripts -rli "$word" $DIR;
  #ack --ignore-dir=third_party --ignore-dir=community_scripts -rlia "$word" $DIR;
  #ack --ignore-dir=third_party --ignore-dir=community_scripts --ignore-dir=home --ignore-dir=private -rlia "$word" $DIR;
  #ack --ignore-dir=third_party --ignore-dir=community_scripts --ignore-dir=private -rlia "$word" $DIR;
  #ack --ignore-dir=private -rlia "$word" $DIR;
  ack -rlia "$word" $DIR;
done
