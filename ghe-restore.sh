#!/bin/sh

BACKUP_DIR=/home/mizzy/backup/ghe

gzip -dc $BACKUP_DIR/mysql-backup.sql.gz | ssh admin@ghe.tokyo.pb -- 'ghe-import-mysql'
ssh admin@ghe.tokyo.pb -- 'ghe-import-redis' < $BACKUP_DIR/redis-backup.rdb
ssh admin@ghe.tokyo.pb -- 'ghe-import-repositories' < $BACKUP_DIR/repositories-backup.tar
