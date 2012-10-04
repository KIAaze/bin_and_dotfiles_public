#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
FILE=~/backup_stage_master/stage_master_$DATE

echo "hg clone ~/stage_master $FILE"
hg clone ~/stage_master $FILE

cd ~/backup_stage_master/
tar -czvf stage_master_$DATE.tar.gz stage_master_$DATE
echo "All archived in ~/backup_stage_master/stage_master_$DATE.tar.gz"
