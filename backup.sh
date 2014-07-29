#! /bin/sh

#simple backup script 
#Thanks to this for bash arrays http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html

EXCLUDE_DIRS="/etc/security" #if you want to exclude part of one of the include_dirs, ex: include /home/ben, exclude /home/ben/isos
INCLUDE_DIRS="/etc /var /home"
BACKUP_DIR="/backup"
BACKUP_DRIVE_DIR="/backup/drive" #where you have your backup drive mounted, preferably with an /etc/fstab entry
DATE=`date +%F`
TARFILE="$DATE-$HOSTNAME"
COMMANDS=(
  'echo "foo"'
  'echo "bar"'
  'echo "foobar"'
  'cat /etc/passwd'
  'id'
  'uname -a'
  )

#root check
if [ "$UID" -ne "0" ]; then
  echo "You should probably run this as root if you're accessing system directories"
fi

echo "include dirs"
#check if include dirs exist
for dir in $INCLUDE_DIRS; do
  echo $dir
  if [ ! -d $dir ]; then
    echo "$dir does not exist"
    exit 1
  fi
done

echo "exclude dirs"
#check exclude directories exist
for dir in $EXCLUDE_DIRS; do
  echo $dir
  if [ ! -d $dir ]; then
    echo "$dir does not exist"
    exit 1;
  fi
done

#make sure backup_dr and backup_drive_dir exist

if [ ! -d $BACKUP_DIR ]; then
  mkdir -p $BACKUP_DIR
fi

if [ ! -d $BACKUP_DRIVE_DIR]; then
  mkdir -p $BACKUP_DIR
fi

#execute the commands

echo "${COMMANDS[@]}"

for cmd in "${COMMANDS[@]}"; do
  echo "Executing: $cmd"
  $cmd #run the command
done

#archive
tar -pcvzf $BACKUP_DIR/$TARFILE $INCLUDE_DIRS --exclude $EXCLUDE_DIRS

#copy the archive to the backup drive at $BACKUP_DRIVE_DIR

cp $BACKUP_DIR/$TARFILE $BACKUP_DRIVE_DIR/$TARFILE
