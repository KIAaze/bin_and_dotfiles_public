#!/usr/bin/zsh
assoc_array="${1}"
for mykey myval in "${(@kv)assoc_array}"; do
    echo "$mykey -> $myval"
done
