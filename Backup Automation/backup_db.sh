#!/bin/bash
# Script: backup.sh

# 1. Folders to back up
SOURCE_DIR="/var/www/html"

# 2. Destination folder
BACKUP_DIR="/backups"

# 3. Database credentials
DB_NAME="mydatabase"
DB_USER="root"
DB_PASS="mypassword"

# 4. Date for unique filenames
DATE=$(date +%Y-%m-%d)

# 5. Create backup folder if not exists
mkdir -p "$BACKUP_DIR"

# 6. Backup files
tar -czf "$BACKUP_DIR/site-backup-$DATE.tar.gz" "$SOURCE_DIR"

# 7. Backup MySQL database
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/db-backup-$DATE.sql"

# 8. Compress database backup
gzip "$BACKUP_DIR/db-backup-$DATE.sql"

# 9. Success message
echo "✅ Backup completed: files + database saved in $BACKUP_DIR"
