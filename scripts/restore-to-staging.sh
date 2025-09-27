#!/bin/bash

# AdNoor ERP Staging Data Restoration Script
# This script restores production data to the staging environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
STAGING_PROJECT="adnoor-staging"
STAGING_SITE="staging.adnoorerp.com"
BACKUP_DIR="/home/frappe/adnoor-staging/backups"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker containers are running
check_containers() {
    print_status "Checking if Docker containers are running..."
    
    if ! docker ps | grep -q "${STAGING_PROJECT}-frappe"; then
        print_error "Frappe container is not running. Please start the staging environment first."
        exit 1
    fi
    
    if ! docker ps | grep -q "${STAGING_PROJECT}-mariadb"; then
        print_error "MariaDB container is not running. Please start the staging environment first."
        exit 1
    fi
    
    print_success "All containers are running"
}

# Copy production backups to staging server
copy_backups() {
    print_status "Copying production backups to staging server..."
    
    # This assumes backups are available locally or can be downloaded
    # You may need to modify this section based on how you transfer files
    
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
    # Check if backups exist
    if [ ! -f "$BACKUP_DIR/latest_production_database.sql.gz" ] || [ ! -f "$BACKUP_DIR/latest_production_files.tar.gz" ]; then
        print_error "Production backups not found in $BACKUP_DIR"
        print_status "Please copy the following files to $BACKUP_DIR:"
        echo "- latest_production_database.sql.gz"
        echo "- latest_production_files.tar.gz"
        exit 1
    fi
    
    print_success "Backup files found"
}

# Drop existing staging site
drop_staging_site() {
    print_status "Dropping existing staging site..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench
        bench drop-site ${STAGING_SITE} --force 2>/dev/null || true
    "
    
    print_success "Staging site dropped"
}

# Create new staging site
create_staging_site() {
    print_status "Creating new staging site..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench
        bench new-site ${STAGING_SITE} \
            --admin-password 'Admin@1234' \
            --mariadb-root-password 'staging_secure_password_2024' \
            --install-app erpnext \
            --install-app hrms
    "
    
    print_success "Staging site created with ERPNext and HRMS"
}

# Restore database
restore_database() {
    print_status "Restoring production database..."
    
    # Copy backup to container
    docker cp "$BACKUP_DIR/latest_production_database.sql.gz" ${STAGING_PROJECT}-mariadb-1:/tmp/
    
    # Restore database
    docker exec ${STAGING_PROJECT}-mariadb-1 bash -c "
        cd /tmp
        gunzip -c latest_production_database.sql.gz | mysql -u root -pstaging_secure_password_2024
    "
    
    print_success "Database restored successfully"
}

# Restore files
restore_files() {
    print_status "Restoring production files..."
    
    # Copy backup to container
    docker cp "$BACKUP_DIR/latest_production_files.tar.gz" ${STAGING_PROJECT}-frappe-1:/tmp/
    
    # Extract files
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench/sites/${STAGING_SITE}
        tar -xzf /tmp/latest_production_files.tar.gz --strip-components=1
    "
    
    print_success "Files restored successfully"
}

# Update site configuration
update_site_config() {
    print_status "Updating site configuration..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench/sites/${STAGING_SITE}
        
        # Update site_config.json for staging
        python3 -c \"
import json
import os

config_path = 'site_config.json'
if os.path.exists(config_path):
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    # Update for staging environment
    config['db_host'] = 'mariadb'
    config['db_password'] = 'staging_secure_password_2024'
    config['redis_cache'] = 'redis://redis-cache:13000'
    config['redis_queue'] = 'redis://redis-queue:11000'
    config['redis_socketio'] = 'redis://redis-socketio:12000'
    config['app_name'] = 'AdNoor ERP'
    config['title_prefix'] = 'AdNoor ERP'
    config['favicon'] = '/files/adnoor_website_logo_250wd58ce2.png'
    
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=1)
    
    print('Site configuration updated')
\"
    "
    
    print_success "Site configuration updated"
}

# Reset administrator password
reset_admin_password() {
    print_status "Resetting administrator password..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench
        bench --site ${STAGING_SITE} set-admin-password Admin@1234
    "
    
    print_success "Administrator password reset to Admin@1234"
}

# Clear cache and restart services
restart_services() {
    print_status "Clearing cache and restarting services..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench
        bench --site ${STAGING_SITE} clear-cache
        bench --site ${STAGING_SITE} clear-website-cache
    "
    
    # Restart Frappe container
    docker restart ${STAGING_PROJECT}-frappe-1
    
    print_success "Services restarted"
}

# Apply branding updates
apply_branding() {
    print_status "Applying AdNoor branding..."
    
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench/sites/${STAGING_SITE}
        
        # Copy logo files to public directory if they exist
        if [ -d 'private/files' ]; then
            cp -r private/files/* public/files/ 2>/dev/null || true
        fi
        
        # Update branding through bench console
        bench --site ${STAGING_SITE} console << 'EOF'
# Update branding
frappe.db.set_value('Website Settings', 'Website Settings', 'app_name', 'AdNoor ERP')
frappe.db.set_value('Website Settings', 'Website Settings', 'title_prefix', 'AdNoor ERP')
frappe.db.set_value('Website Settings', 'Website Settings', 'favicon', '/files/adnoor_website_logo_250wd58ce2.png')
frappe.db.commit()
print('Branding updated')
EOF
    "
    
    print_success "Branding applied successfully"
}

# Run post-restoration tests
run_tests() {
    print_status "Running post-restoration tests..."
    
    # Test database connection
    docker exec ${STAGING_PROJECT}-frappe-1 bash -c "
        cd /workspace/development/frappe-bench
        bench --site ${STAGING_SITE} doctor
    "
    
    # Test site accessibility
    sleep 10  # Wait for services to start
    
    if curl -f -s "https://staging.adnoorerp.com" > /dev/null; then
        print_success "Site is accessible"
    else
        print_warning "Site may not be accessible yet. Please check manually."
    fi
    
    print_success "Tests completed"
}

# Main execution function
main() {
    print_status "Starting production data restoration to staging..."
    
    check_containers
    copy_backups
    drop_staging_site
    create_staging_site
    restore_database
    restore_files
    update_site_config
    reset_admin_password
    restart_services
    apply_branding
    run_tests
    
    print_success "🎉 Staging restoration completed successfully!"
    print_status "Access your staging environment at: https://staging.adnoorerp.com"
    print_status "Login credentials:"
    echo "- Username: Administrator"
    echo "- Password: Admin@1234"
    echo ""
    print_status "Next steps:"
    echo "1. Test all functionality"
    echo "2. Verify data integrity"
    echo "3. Test user roles and permissions"
    echo "4. Update DNS if needed"
}

# Run main function
main "$@"
