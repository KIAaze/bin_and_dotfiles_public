#!/bin/bash
set -eu

##### Convenience script to unmount any mounted rclone remotes in ~/rclone/*
### -u  unmount
### -z  lazy unmount : Detach the filesystem from the file hierarchy now, and clean up all references to this filesystem as soon as it is not busy anymore.

for i in ~/rclone/*
do
  if mountpoint --quiet "${i}"
  then
    echo "Unmounting ${i}"
    fusermount3 -uz "${i}"
  else
    echo "${i} is not mounted."
  fi
done

if pgrep --list-full --exact rclone
then
  while pkill rclone
  do
    echo "Killing rclone processes..."
  done
fi
echo "No more rclone processes running."
