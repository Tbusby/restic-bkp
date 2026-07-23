#!/bin/bash

CFG_DIR=~/.config/restic

echo "----------------------------"
echo $(date)

# Wait for NFS mount to be available
MOUNT_POINT="/mnt/shared"
MAX_WAIT=60
WAITED=0
while [ ! -d "$MOUNT_POINT" ] || ! mountpoint -q "$MOUNT_POINT"; do
    if [ $WAITED -ge $MAX_WAIT ]; then
        echo "ERROR: $MOUNT_POINT not mounted after ${MAX_WAIT}s, aborting."
        exit 1
    fi
    echo "Waiting for $MOUNT_POINT to be mounted... ($WAITED/${MAX_WAIT}s)"
    sleep 5
    WAITED=$((WAITED + 5))
done
echo "$MOUNT_POINT is ready."

# Run backups
restic backup \
    --repository-file $CFG_DIR/repository \
    --password-file $CFG_DIR/password \
    --files-from $CFG_DIR/includes.txt \
    --exclude-file $CFG_DIR/excludes.txt \
    --tag auto \
    --skip-if-unchanged

# Remove snapshots policy
restic forget \
    --keep-daily 7 \
    --keep-weekly 4 \
    --keep-monthly 12 \
    --keep-yearly 7 \
    --password-file $CFG_DIR/password \
    --repository-file $CFG_DIR/repository 

restic prune --password-file $CFG_DIR/password --repository-file $CFG_DIR/repository 

restic check --password-file $CFG_DIR/password --repository-file $CFG_DIR/repository 

