#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
TAR=~/uplink_$DATE.tar.gz
echo "Creating $TAR"
tar -Pczvf $TAR ~/.uplink
