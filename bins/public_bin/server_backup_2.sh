#!/bin/bash
# script to backup important server files

# get date
datefull=$(date +%Y%m%d_%H%M%S)

# backup files
tar -Pczvf server_config.$datefull.tar.gz /etc /opt /var/drweb /var/log /var/qmail /var/www/ --exclude=/var/qmail/mailnames

# backup databases
# mysqldump -p $SQL_DB_1 > $SQL_DB_1.$datefull.sql
# mysqldump -p $SQL_DB_2 > $SQL_DB_2.$datefull.sql
# mysqldump -p $SQL_DB_3 > $SQL_DB_3.$datefull.sql
# mysqldump -p $SQL_DB_4 > $SQL_DB_4.$datefull.sql
