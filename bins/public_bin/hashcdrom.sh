#!/bin/bash
set -e

#Compares the checksums of an iso9660 image and a burned disk.
#This script is released into the public domain by it's author.
if [ -n "$BASH" ]; then
shopt -s expand_aliases
fi

if [ -n "$CHECKSUM" ]; then
alias CHECKSUM="$CHECKSUM"
elif which md5deep &> /dev/null; then
alias CHECKSUM='md5deep -e'
else
alias CHECKSUM='md5sum'
fi
CHECKSUM='md5sum'
#CHECKSUM='md5deep'
#CHECKSUM='sha1sum'
echo $CHECKSUM

if [ -n "$2" ]; then
DISKDEVICE="$2"
else
DISKDEVICE='/dev/cdrom'
fi

CSUM1=$($CHECKSUM "$1" | grep --only-matching -m 1 '^[0-9a-f]*')
echo 'checksum for input image:' $CSUM1
SIZE=$(stat -c '%s' "$1");
BLOCKS=$(expr $SIZE / 2048);
CSUM2=$(dd if="$DISKDEVICE" bs=2048 count=$BLOCKS 2> /dev/null | $CHECKSUM | grep --only-matching -m 1 '^[0-9a-f]*')
echo 'checksum for output disk:' $CSUM2

if [ "$CSUM1" = "$CSUM2" ]; then
echo 'verification successful!'
else
echo 'verification failed!'
fi
