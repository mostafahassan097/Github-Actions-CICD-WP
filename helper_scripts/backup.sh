#!/bin/bash

# Check if required environment variables are set
if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_NAME" ] || [ -z "$DB_HOST" ]; then
    echo "Error: Please set the DB_USER, DB_PASSWORD, DB_NAME, and DB_HOST environment variables."
    exit 1
fi

# Backup directory and filename
BACKUP_DIR="/path/to/backup/directory"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

# Retention settings
RETENTION_DAYS=7  # Number of days to keep backups

# Function to create the backup directory if it doesn't exist
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backup directory created: $BACKUP_DIR"
    fi
}

# Function to perform the database backup
perform_backup() {
    mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"
    if [ $? -eq 0 ]; then
        echo "Backup completed: $BACKUP_FILE"
    else
        echo "Backup failed."
        exit 1
    fi
}

# Function to delete old backups based on retention settings
delete_old_backups() {
    find "$BACKUP_DIR" -type f -mtime +"$RETENTION_DAYS" -exec rm {} \;
    echo "Old backups deleted."
}

# Main script
case "$1" in
    backup)
        create_backup_dir
        perform_backup
        delete_old_backups
        ;;
    *)
        echo "Usage: $0 [backup]"
        echo "  backup - Perform a database backup and delete old backups"
        exit 1
        ;;
esac

exit 0
