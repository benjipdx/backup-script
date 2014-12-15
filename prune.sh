#! /bin/bash
 
#simple backup pruning script for removing old backups older than a month

BACKUP_DIR="/backup"
BACKUP_DRIVE_DIR="/backup/drive" #where you have your backup drive mounted, preferably with an /etc/fstab entry
PREV_MONTH=`date --date="$(date +%Y-%m-15) -1 month" +'%F' | cut -c 1-8` #format with prev month format like: 2014-11-

#root check
if [ "$UID" -ne "0" ]; then
  echo "You should probably run this as root if you're accessing system directories"
fi

rm -rf $BACKUP_DIR/$PREV_MONTH*
rm -rf $BACKUP_DRIVE_DIR/$PREV_MONTH*
