#!/bin/bash

# home-backup-script
# ------------------
# because incremental backups are a better idea than just overwriting everything every time

# set some rules to make the script exit on errors
set -o errexit
set -o nounset
set -o pipefail

# important variables
readonly BACKUP_DEVICE_UUID="f235a076-bb77-4a42-8eb7-3ced63b3b339"
readonly BACKUP_DIR="/media/${BACKUP_DEVICE_UUID}/${HOSTNAME}"
readonly RSYNC_OPTS="--progress --prune-empty-dirs --ignore-missing-args"
DATETIME="$(date +'%Y-%m-%d_%H-%M-%S')"

# only run script as super-user because it needs access to commands that would otherwise need "sudo"
if [ "${UID}" != "0" ]
then
   echo -e "Script must be run as super-user. Exiting..."
   exit 1
fi

# if the symlink to the device doesn't exist, exit
if [ ! -L "/dev/disk/by-uuid/${BACKUP_DEVICE_UUID}" ]
then
    echo -e "Not able to find backup device. Exiting..."
    exit 1
fi

# make the dir for the backup device and mount it
mkdir -v -p "/media/${BACKUP_DEVICE_UUID}"
mount -v "/dev/disk/by-uuid/${BACKUP_DEVICE_UUID}" \
    -o compress=zlib:9 \
    "/media/${BACKUP_DEVICE_UUID}"

# make the backup dir for the current backup based on the timestamp
mkdir -v -p "${BACKUP_DIR}"

# we need to ignore exit code for files vanishing since we're using the system
EXIT_CODE=0

# if the symlink for the last backup exists, do incremental backups
if [ -L "${BACKUP_DIR}/latest" ]
then
    rsync -aAXhv --delete ${RSYNC_OPTS} \
        --exclude-from="/home/${SUDO_USER}/.rsync_exclude_list" \
        --link-dest="${BACKUP_DIR}/latest" \
        "/home/${SUDO_USER}" \
        "${BACKUP_DIR}/${DATETIME}" || EXIT_CODE=$?
else
    rsync -aAXhv --delete ${RSYNC_OPTS} \
        --exclude-from="/home/${SUDO_USER}/.rsync_exclude_list" \
        "/home/${SUDO_USER}" \
        "${BACKUP_DIR}/${DATETIME}" || EXIT_CODE=$?
fi

# if rsync fails and it wasn't due to vanishing files, an error has occured
if [ ${EXIT_CODE} != 0 ] && [ ${EXIT_CODE} != 24 ]
then
    echo -e "Error with 'rsync' backup: returned code ${EXIT_CODE}. Exiting..."
    exit ${EXIT_CODE}
fi

# if the symlink for the last backup exists, remove it as it's getting replaced
if [ -L "${BACKUP_DIR}/latest" ]
then
    rm -v "${BACKUP_DIR}/latest"
fi

# create symlink to latest backup
cd "${BACKUP_DIR}"
ln -v -s "${DATETIME}" "latest"

# create a BTRFS snapshot because redundancy that's not actually that redundant
cd "/media/${BACKUP_DEVICE_UUID}"
if [ ! -d ".snapshots" ]
then
    mkdir ".snapshots"
fi
btrfs subvolume snapshot -r "./" "./.snapshots/${DATETIME}"

# unmount the drive
cd "/"
umount -v "/dev/disk/by-uuid/${BACKUP_DEVICE_UUID}"
rmdir -v "/media/${BACKUP_DEVICE_UUID}"
