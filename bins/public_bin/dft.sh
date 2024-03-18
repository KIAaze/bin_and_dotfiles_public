#!/bin/bash
# https://blog.jdpfu.com/2020/03/04/removing-loop-devices-from-fdisk-output
df --human-readable --print-type --exclude-type=squashfs --exclude-type=tmpfs --exclude-type=devtmpfs
