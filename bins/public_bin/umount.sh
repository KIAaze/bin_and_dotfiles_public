#!/bin/bash
ls /media/disk
umount /media/disk
eject /media/disk
ls /media/disk
if [ $? -ne 0 ]
then
	echo "You may remove the USB device. :)"
fi
