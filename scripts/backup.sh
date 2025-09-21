#!/bin/bash

# AdNoor ERP Backup Script
# This script creates backups of the ERPNext site

set -e  # Exit on any error

# Configuration
SITE_NAME=${1:-"adnoorerp.com"}
BACKUP_DIR="/home/frappe/backups"
RETENTION_DAYS=${2:-30}

echo "💾 Creating backup for AdNoor ERP..."
echo "===================================="
echo "Site: $SITE_NAME"
echo "Backup directory: $BACKUP_DIR"
echo "Retention: $RETENTION_DAYS days"

# Check if we're in the right directory
if [ ! -f "easy-install.py" ]; then
    echo "❌ Error: easy-install.py not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "📦 Creating backup with files..."
bench --site "$SITE_NAME" backup --with-files

echo "🧹 Cleaning up old backups (older than $RETENTION_DAYS days)..."
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete

echo "✅ Backup completed successfully!"
echo "Backup location: $BACKUP_DIR"
echo "Latest backup: $(ls -t $BACKUP_DIR/*.tar.gz | head -1)"
