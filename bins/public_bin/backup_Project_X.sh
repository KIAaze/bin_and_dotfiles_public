#!/bin/bash

DATE=$(date +%Y%m%d_%H%M%S)
FILE=~/backup_Project_X/Project_X_$DATE

echo "hg clone ~/Project_X $FILE"
hg clone ~/Project_X $FILE

cd ~/backup_Project_X/
tar -czvf Project_X_$DATE.tar.gz Project_X_$DATE
echo "All archived in ~/backup_Project_X/Project_X_$DATE.tar.gz"
