#!/bin/bash
echo "ls --almost-all /media/"
ls --almost-all "/media/"

echo "ls --almost-all /run/media/"
ls --almost-all "/run/media/"

echo "ls --almost-all /media/${USER}/"
ls --almost-all "/media/${USER}/"

echo "ls --almost-all /run/media/${USER}/"
ls --almost-all "/run/media/${USER}/"

set -eu

if mount | grep media >/dev/null
then
    echo "===> The following removable media are mounted:"
    mount | grep media
else
    echo "===> No removable media mounted."
fi
