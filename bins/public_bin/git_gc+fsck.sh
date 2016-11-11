#!/bin/bash
set -eu
for i in "$@"
do
	echo "===> ${i}"
	cd "${i}"
	git gc
	git fsck
	cd -
done
