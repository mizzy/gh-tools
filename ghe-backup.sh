#!/bin/sh

BACKUP_DIR=/home/mizzy/backup/ghe

ssh admin@ghe.tokyo.pb -- 'ghe-export-mysql' | gzip > $BACKUP_DIR/mysql-backup.sql.gz
ssh admin@ghe.tokyo.pb -- 'ghe-export-redis' > $BACKUP_DIR/redis-backup.rdb
ssh admin@ghe.tokyo.pb -- 'ghe-export-repositories' > $BACKUP_DIR/repositories-backup.tar
