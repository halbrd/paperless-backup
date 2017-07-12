#!/bin/bash
# Backup Paperless data to a directory, maintaining a rolling history


# Config variables
BACKUP_MATCH_PATTERN="paperless-backup-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}.[0-9]\{2\}.[0-9]\{2\}.tgz"   # Form of backups
EXPORT_DIR="/home/will/Dropbox/Paperless Backups"   # Directory where the backups go
PRESERVE_COUNT=3   # Number of backups to keep

# Activate virtualenv
. /opt/paperless/bin/activate

echo Export files
filename="paperless-backup-$(date +'%Y-%m-%d %H.%M.%S')"
mkdir "/tmp/$filename"
/opt/paperless/src/manage.py document_exporter "/tmp/$filename"

echo Create archive
# Change directory to avoid annoying tar behavior
cd "/tmp/$filename"
tar czf "$EXPORT_DIR"/"$filename".tgz *

# Delete temporary files
rm -r "/tmp/$filename"

echo Delete old backups
cd "$EXPORT_DIR"
# Change IFS temporarily
tempIFS=$IFS
IFS=$'\n'
# Get list of backups
backups=($(ls | grep "$BACKUP_MATCH_PATTERN" | sort -n))
IFS=$tempIFS
# Calculate how many extra backups there are
extra_count=$((${#backups[@]} - $PRESERVE_COUNT))
# Delete extra backups
if [ $extra_count -gt 0 ]
then
        # Get all backups except the (PRESERVE_COUNT) most recent backups
        to_delete=()
        for ((i = 0; i < $extra_count; i++))
        do
                to_delete+=("${backups[$i]}")
        done

        # Delete extra backups
        for backup in "${to_delete[@]}";
        do
                rm "$EXPORT_DIR/$backup"
        done
fi
