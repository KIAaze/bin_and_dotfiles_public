#!/bin/bash
set -e -x -u

determine_boot_partition()
{
    echo "Determining boot partition..."
    TMP=$(mktemp)
    sudo fdisk -l >$TMP
    BOOT_PARTITION=$( grep '*' ./fdisk.log | grep /dev | awk '{print $1}' )
    echo "BOOT_PARTITION=$BOOT_PARTITION"
}

backup_MBR()
{
	echo "Backing up MBR..."
	determine_boot_partition
	echo "Filename=?"
	read FILENAME
	FILENAME=$( readlink -f $FILENAME )
	echo "FILENAME=$FILENAME"
	TMP=$(mktemp -d)
	cd $TMP
	echo "dd if=$BOOT_PARTITION of=MBR bs=512 count=1"
	dd if=$BOOT_PARTITION of=MBR bs=512 count=1
	echo $BOOT_PARTITION >boot_partition
	tar -cvf $FILENAME MBR boot_partition
}

restore_MBR()
{
	echo "Restoring MBR..."
	echo "Filename=?"
	read FILENAME
	FILENAME=$( readlink -f $FILENAME )
	echo "FILENAME=$FILENAME"
	TMP=$(mktemp -d)
	cd $TMP
	tar -xvf $FILENAME
	echo "sudo dd if=MBR of=$BOOT_PARTITION bs=512 count=1"
# 	sudo dd if=MBR of=$BOOT_PARTITION bs=512 count=1
}

echo "1)Backup"
echo "2)Restore"
read ans
if [ $ans = 1 ]
then
	backup_MBR
fi
if [ $ans = 2 ]
then
	restore_MBR
fi

#dd if=/dev/hdx of=MBR-backup bs=512 count=1 
#dd if=MBR-backup of=/dev/hdx bs=512 count=1 
