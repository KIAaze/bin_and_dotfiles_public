#!/bin/bash
# https://blog.jdpfu.com/2020/03/04/removing-loop-devices-from-fdisk-output
# https://askubuntu.com/questions/1195388/how-to-remove-dev-loops

# delete every line matching "Disk /dev/loop" and the 5 lines following it.
sudo fdisk --list | sed --expression='/Disk \/dev\/loop/,+5d'
