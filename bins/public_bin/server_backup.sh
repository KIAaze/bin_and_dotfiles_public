#!/bin/bash

set -eux

# get date
datefull=$(date +%Y%m%d_%H%M%S)

LOCAL_BKPDIR=/backup/SQL

# REMOTE_BKPDIR must be defined in dotfiles

# backup databases
mysqldump -u$SQL_USER -p$SQL_PASSWORD $SQL_DB_1 > $LOCAL_BKPDIR/$SQL_DB_1.$datefull.sql
mysqldump -u$SQL_USER -p$SQL_PASSWORD $SQL_DB_2 > $LOCAL_BKPDIR/$SQL_DB_2.$datefull.sql
mysqldump -u$SQL_USER -p$SQL_PASSWORD $SQL_DB_3 > $LOCAL_BKPDIR/$SQL_DB_3.$datefull.sql
mysqldump -u$SQL_USER -p$SQL_PASSWORD $SQL_DB_4 > $LOCAL_BKPDIR/$SQL_DB_4.$datefull.sql

# back up data using rdiff-backup
# rdiff-backup --include-filelist /root/bin/include-list / /backup

# general backup
echo rdiff-backup /etc/ $REMOTE_BKPDIR/etc/
echo rdiff-backup /opt/ $REMOTE_BKPDIR/opt/
echo rdiff-backup --exclude /var/lib/ /var/ $REMOTE_BKPDIR/var/

# SQL backup
echo rdiff-backup $LOCAL_BKPDIR/ $REMOTE_BKPDIR/SQL/

echo "BACKUP SUCCESSFUL"
