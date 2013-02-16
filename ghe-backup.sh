#!/bin/sh

BACKUP_DIR=/home/mizzy/backup/ghe

ssh admin@ghe.tokyo.pb -- 'ghe-export-mysql' | gzip > $BACKUP_DIR/mysql-backup.sql.gz.tmp
ssh admin@ghe.tokyo.pb -- 'ghe-export-redis' > $BACKUP_DIR/redis-backup.rdb.tmp
ssh admin@ghe.tokyo.pb -- 'ghe-export-repositories' > $BACKUP_DIR/repositories-backup.tar.tmp

mv $BACKUP_DIR/mysql-backup.sql.gz.tmp $BACKUP_DIR/mysql-backup.sql.gz
mv $BACKUP_DIR/redis-backup.rdb.tmp $BACKUP_DIR/redis-backup.rdb
mv $BACKUP_DIR/repositories-backup.tar.tmp $BACKUP_DIR/repositories-backup.tar
