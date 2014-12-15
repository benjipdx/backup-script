#! /bin/bash

#simple backup script 
#Thanks to this for bash arrays http://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html

EXCLUDE_DIRS="/etc/somethingidontwantoinclude /home/user/.ssh /home/user/secrets" #if you want to exclude part of one of the include_dirs, ex: include /home/ben, exclude /home/ben/isos (usually for space constraints or privacy"
INCLUDE_DIRS="/etc/some/directory /home/user"
BACKUP_DIR="/backup"
BACKUP_DRIVE_DIR="/backup/drive" #where you have your backup drive mounted, preferably with an /etc/fstab entry
DATE=`date +%F`
TARFILE="$DATE-$HOSTNAME.tar.gz"
COMMANDS=( 'echo "foo"' 'echo "bar"' 'echo "foobar"' 'cat /etc/passwd' 'id' 'uname -a' ) #Commands to run before the archive gets made, I use it to backup a postgres db to a file and then move it to a backup location in the include dirs

#root check
if [ "$UID" -ne "0" ]; then
  echo "You should probably run this as root if you're accessing system directories"
fi

if [ -e "$INCLUDE_DIRS" ]; then
  echo "No Directories to include, exiting"
  exit 1
else
  echo "Included Directories"
  #check if include dirs exist
  for dir in $INCLUDE_DIRS; do
    echo $dir
    if [ ! -d $dir ]; then
      echo "$dir does not exist"
      exit 1
    fi
  done
fi

if [ -e "$EXCLUDE_DIRS" ]; then
  echo "No Directories to exclude, continuing..."
  
else
  echo "Excluded Directories:"
  #check exclude directories exist
  for dir in $EXCLUDE_DIRS; do
    echo $dir
    if [ ! -d $dir ]; then
      echo "$dir does not exist"
      exit 1;
    fi
  done
fi

#make sure backup_dr and backup_drive_dir exist
if [ -e "$BACKUP_DIR" ]; then
  mkdir -p $BACKUP_DIR
  echo "Made backup directory..."
fi

if [ ! -d $BACKUP_DRIVE_DIR ]; then
  mkdir -p $BACKUP_DRIVE_DIR
  echo "Made backup drive directory"
fi

#execute the commands

echo "${COMMANDS[@]}"

for cmd in "${COMMANDS[@]}"; do
  echo "Executing: $cmd"
  $cmd #run the command
done

#archive

#if there aren't any excluded directories
if [ -e "$EXCLUDE_DIRS"" ]; then
  tar -pczf $BACKUP_DIR/$TARFILE $INCLUDE_DIRS
else
  tar -pczf $BACKUP_DIR/$TARFILE $INCLUDE_DIRS --exclude $EXCLUDE_DIRS
fi

#copy the archive to the backup drive at $BACKUP_DRIVE_DIR

cp $BACKUP_DIR/$TARFILE $BACKUP_DRIVE_DIR/$TARFILE

echo "Successfully created a backup archive in $BACKUP_DRIVE_DIR/$TARFILE"
