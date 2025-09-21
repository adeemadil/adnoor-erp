#!/bin/bash

# AdNoor ERP Restore Script
# This script restores ERPNext from a backup

set -e  # Exit on any error

# Configuration
BACKUP_FILE=${1}
SITE_NAME=${2:-"adnoorerp.com"}

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ Error: Backup file path is required"
    echo "Usage: $0 <backup_file_path> [site_name]"
    echo "Example: $0 /home/frappe/backups/backup-2024-01-15.tar.gz adnoorerp.com"
    exit 1
fi

echo "🔄 Restoring AdNoor ERP from backup..."
echo "====================================="
echo "Backup file: $BACKUP_FILE"
echo "Site: $SITE_NAME"

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Error: Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "easy-install.py" ]; then
    echo "❌ Error: easy-install.py not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "⚠️  Warning: This will restore the site from backup and may overwrite existing data."
echo "Are you sure you want to continue? (y/N)"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

echo "📦 Restoring from backup..."
bench --site "$SITE_NAME" restore "$BACKUP_FILE"

echo "✅ Restore completed successfully!"
echo "Site $SITE_NAME has been restored from backup."
