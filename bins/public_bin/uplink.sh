#! /bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
TARFILE="uplink_$DATE.tar.gz"
cd ~
tar -czvf $TARFILE ./.uplink
echo "Game saved in $TARFILE"

echo "Launching game"
~/uplink/uplink
