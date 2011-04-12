#!/usr/bin/env bash
TMP=$(mktemp)
for FILE in $@
do
	tr -d '\r' <$FILE >$TMP
	mv -v $TMP $FILE
done
