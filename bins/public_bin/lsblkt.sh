#!/bin/bash
# https://blog.jdpfu.com/2020/03/04/removing-loop-devices-from-fdisk-output
lsblk --exclude 7 --output name,size,type,fstype,mountpoint
