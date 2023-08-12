#!/bin/bash
set -eu

##### Convenience script to unmount any mounted rclone remotes in ~/rclone/*

for i in ~/rclone/*
do
  if mountpoint --quiet "${i}"
  then
    echo "Unmounting ${i}"
    fusermount -u "${i}"
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
