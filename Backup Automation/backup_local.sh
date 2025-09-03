#!/bin/bash
# Script: backup.sh

# 1. Source folder (the data we want to back up)
SOURCE_DIR="/var/www/html"

# 2. Destination folder (where backups are stored)
BACKUP_DIR="/backups"

# 3. Date for unique backup file name
DATE=$(date +%Y-%m-%d)

# 4. Create backup folder if it doesn’t exist
mkdir -p "$BACKUP_DIR"

# 5. Compress the source into a tar.gz file
tar -czf "$BACKUP_DIR/site-backup-$DATE.tar.gz" "$SOURCE_DIR"

# 6. Print success message
echo "✅ Backup completed: $BACKUP_DIR/site-backup-$DATE.tar.gz"
