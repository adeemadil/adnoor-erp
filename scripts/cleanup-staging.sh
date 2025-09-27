#!/bin/bash

# AdNoor ERP Staging Cleanup Script
# This script removes the previous staging deployment completely

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Stop and remove all Docker containers and volumes
cleanup_docker() {
    print_status "Stopping and removing Docker containers..."
    
    # Stop all running containers
    docker stop $(docker ps -aq) 2>/dev/null || true
    
    # Remove all containers
    docker rm $(docker ps -aq) 2>/dev/null || true
    
    # Remove all volumes
    docker volume rm $(docker volume ls -q) 2>/dev/null || true
    
    # Remove all networks
    docker network rm $(docker network ls -q) 2>/dev/null || true
    
    # Remove all images (optional - uncomment if you want to remove all images)
    # docker rmi $(docker images -q) 2>/dev/null || true
    
    print_success "Docker cleanup completed"
}

# Remove previous staging files and directories
cleanup_files() {
    print_status "Removing previous staging files and directories..."
    
    # Remove directories
    if [ -d "adnoor-erp" ]; then
        rm -rf adnoor-erp
        print_success "Removed adnoor-erp directory"
    fi
    
    if [ -d "backups" ]; then
        rm -rf backups
        print_success "Removed backups directory"
    fi
    
    if [ -d "adnoor-staging" ]; then
        rm -rf adnoor-staging
        print_success "Removed adnoor-staging directory"
    fi
    
    # Remove files
    rm -f adnoor-staging-compose.yml
    rm -f adnoor-staging-passwords.txt
    rm -f adnoor-staging.env
    rm -f restore_staging.sh
    
    print_success "Previous staging files removed"
}

# Clean up system packages (optional)
cleanup_system() {
    print_status "Cleaning up system packages..."
    
    # Remove Docker if installed
    if command -v docker &> /dev/null; then
        sudo apt remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>/dev/null || true
        sudo apt autoremove -y
        print_success "Docker packages removed"
    fi
    
    # Remove Nginx configurations
    if [ -f "/etc/nginx/sites-enabled/staging.adnoorerp.com" ]; then
        sudo rm -f /etc/nginx/sites-enabled/staging.adnoorerp.com
        sudo rm -f /etc/nginx/sites-available/staging.adnoorerp.com
        sudo nginx -t && sudo systemctl reload nginx
        print_success "Nginx configurations removed"
    fi
    
    # Remove SSL certificates
    if [ -d "/etc/letsencrypt/live/staging.adnoorerp.com" ]; then
        sudo rm -rf /etc/letsencrypt/live/staging.adnoorerp.com
        sudo rm -rf /etc/letsencrypt/archive/staging.adnoorerp.com
        print_success "SSL certificates removed"
    fi
}

# Clean up user groups
cleanup_user_groups() {
    print_status "Cleaning up user groups..."
    
    # Remove user from docker group if exists
    if groups $USER | grep -q docker; then
        sudo gpasswd -d $USER docker 2>/dev/null || true
        print_success "Removed user from docker group"
    fi
}

# Clean up cron jobs
cleanup_cron() {
    print_status "Cleaning up cron jobs..."
    
    # Remove any AdNoor-related cron jobs
    crontab -l 2>/dev/null | grep -v "adnoor\|staging" | crontab - 2>/dev/null || true
    
    print_success "Cron jobs cleaned up"
}

# Verify cleanup
verify_cleanup() {
    print_status "Verifying cleanup..."
    
    # Check if Docker containers are gone
    if [ "$(docker ps -aq | wc -l)" -eq 0 ]; then
        print_success "All Docker containers removed"
    else
        print_warning "Some Docker containers may still exist"
    fi
    
    # Check if directories are gone
    if [ ! -d "adnoor-erp" ] && [ ! -d "backups" ] && [ ! -d "adnoor-staging" ]; then
        print_success "All staging directories removed"
    else
        print_warning "Some directories may still exist"
    fi
    
    # Check if files are gone
    if [ ! -f "adnoor-staging-compose.yml" ] && [ ! -f "adnoor-staging.env" ]; then
        print_success "All staging files removed"
    else
        print_warning "Some files may still exist"
    fi
}

# Main execution function
main() {
    print_status "Starting AdNoor ERP Staging Cleanup..."
    print_warning "This will completely remove the previous staging deployment!"
    
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleanup cancelled"
        exit 0
    fi
    
    cleanup_docker
    cleanup_files
    cleanup_system
    cleanup_user_groups
    cleanup_cron
    verify_cleanup
    
    print_success "🎉 Staging cleanup completed successfully!"
    print_status "The system is now ready for a fresh staging deployment."
    echo ""
    print_status "Next steps:"
    echo "1. Run the fresh staging deployment script"
    echo "2. Restore production data"
    echo "3. Apply AdNoor branding"
    echo "4. Test functionality"
}

# Run main function
main "$@"
