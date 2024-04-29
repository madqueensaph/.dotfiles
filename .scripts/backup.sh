#!/bin/bash

# backup.sh
# ------------------
# does incremental backup of root and home partitions

# set some rules to make the script exit on errors
set -o errexit
set -o nounset
set -o pipefail
set -x

# important variables
BACKUP_DEVICE_UUID=$(cat /home/"$SUDO_USER"/.backup_device_uuid)
SNAPSHOT_DIR="/.snapshots"
BACKUP_DIR="/media/$BACKUP_DEVICE_UUID/$HOSTNAME"
RSYNC_OPTS="--progress --prune-empty-dirs --ignore-missing-args"
DATETIME="$(date +'%Y-%m-%d_%H-%M-%S')"

# commands being run require root perms
if [ "$UID" != "0" ]
then
   echo -e "Script must be run as super-user. Exiting..."
   exit 1
fi

# if the device doesn't exist, exit
if [ ! -L "/dev/disk/by-uuid/$BACKUP_DEVICE_UUID" ]
then
    echo -e "Not able to find backup device. Exiting..."
    exit 1
fi

# UNCOMMENT IF USING REMOVABLE DRIVE
## make the dir for the backup device and mount it
#mkdir -v -p "/media/$BACKUP_DEVICE_UUID"
#mount -v "/dev/disk/by-uuid/$BACKUP_DEVICE_UUID" \
#    -o compress=zlib:9 \
#    "/media/$BACKUP_DEVICE_UUID"

###################
###################
### ROOT BACKUP ###
###################
###################

# create root backup dir if not already created
if [ ! -d "$BACKUP_DIR/root_backups" ]
then
    mkdir -v -p "$BACKUP_DIR/root_backups"
fi

# create BTRFS snapshot, will be moving to backup volume
btrfs subvolume snapshot -r / "$SNAPSHOT_DIR/$DATETIME"
sync

# if previous snapshot exists, do incremental backup
if [ -L "$SNAPSHOT_DIR/latest" ]
then
    btrfs send -p "$SNAPSHOT_DIR/latest" "$SNAPSHOT_DIR/$DATETIME" |
        btrfs receive "$BACKUP_DIR/root_backups"
else
    btrfs send "$SNAPSHOT_DIR/$DATETIME" |
        btrfs receive "$BACKUP_DIR/root_backups"
fi

# update symlink for latest snapshot on backup drive
if [ -L "$SNAPSHOT_DIR/latest" ]
then
    PREV_SNAPSHOT=$(readlink -f "$SNAPSHOT_DIR/latest")
    btrfs subvolume delete "$PREV_SNAPSHOT"
    rm -v "$SNAPSHOT_DIR/latest"
fi
cd "$SNAPSHOT_DIR"
ln -v -s "$DATETIME" "latest"

###################
###################
### HOME BACKUP ###
###################
###################

# create home backup dir if not already created
if [ ! -d "$BACKUP_DIR/home_backups" ]
then
    mkdir -v -p "$BACKUP_DIR/home_backups"
fi

# we need to ignore exit code for files vanishing while the system is in use
EXIT_CODE=0

# if the symlink for the last backup exists, do incremental backups
if [ -L "$BACKUP_DIR/home_backups/latest" ]
then
    rsync -aAXhv --delete $RSYNC_OPTS \
        --exclude-from="/home/$SUDO_USER/.rsync_exclude_list" \
        --link-dest="$BACKUP_DIR/home_backups/latest" \
        "/home" \
        "$BACKUP_DIR/home_backups/$DATETIME" || EXIT_CODE=$?
else
    rsync -aAXhv --delete $RSYNC_OPTS \
        --exclude-from="/home/$SUDO_USER/.rsync_exclude_list" \
        "/home" \
        "$BACKUP_DIR/home_backups/$DATETIME" || EXIT_CODE=$?
fi

# if rsync fails and it wasn't due to vanishing files, exit
if [ $EXIT_CODE != 0 ] && [ $EXIT_CODE != 24 ]
then
    echo -e "Error with 'rsync' backup: returned code $EXIT_CODE. Exiting..."
    exit $EXIT_CODE
fi

# update symlink for the latest snapshot
if [ -L "$BACKUP_DIR/home_backups/latest" ]
then
    rm -v "$BACKUP_DIR/home_backups/latest"
fi
cd "$BACKUP_DIR/home_backups"
ln -v -s "$DATETIME" "latest"

# UNCOMMENT IF USING REMOVABLE DRIVE
## unmount the drive
#cd "/"
#umount -v "/dev/disk/by-uuid/$BACKUP_DEVICE_UUID"
#rmdir -v "/media/$BACKUP_DEVICE_UUID"
