#!/bin/bash

# compares two directories using rsync.
set -u

# SRC="$1"
# DST="$2"
LOGFILE=$(mktemp)
# rsync --dry-run --archive --verbose --compress --checksum ${SRC} ${DST} &>$LOGFILE
echo "===> rsync --dry-run --archive --verbose --compress ${@} &>$LOGFILE"
rsync --dry-run --archive --verbose --compress ${@} &>$LOGFILE
rsync_exit_status=$?
echo "===> Would be tranferred:"
grep -v "/$" $LOGFILE
echo "===> LOGFILE = $LOGFILE"
test ${rsync_exit_status} -eq 0 && test $(grep -v "/$" $LOGFILE | wc -l) -eq 4
