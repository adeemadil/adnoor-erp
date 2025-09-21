#!/bin/bash

# AdNoor ERP Production Deployment Script
# This script deploys the production environment to Contabo VM

set -e  # Exit on any error

echo "🚀 Deploying AdNoor ERP to Production (Contabo VM)..."
echo "====================================================="

# Check if we're on the production server
# You can customize this check based on your Contabo VM hostname
if [ "$(hostname)" != "your-contabo-hostname" ]; then
    echo "⚠️  Warning: This script is designed to run on the Contabo VM"
    echo "Current hostname: $(hostname)"
    echo "If you're sure you want to continue, press Enter. Otherwise, Ctrl+C to cancel."
    read -r
fi

# Check if easy-install.py exists
if [ ! -f "easy-install.py" ]; then
    echo "❌ Error: easy-install.py not found in current directory"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required but not installed"
    exit 1
fi

# Check if apps.json exists
if [ ! -f "config/apps.json" ]; then
    echo "❌ Error: config/apps.json not found"
    echo "Please ensure your custom app configuration is set up"
    exit 1
fi

# Make sure easy-install.py is executable
chmod +x easy-install.py

echo "📦 Deploying production environment..."
echo "Project: adnoor-prod"
echo "Site: adnoorerp.com"
echo "Email: admin@adnoorerp.com"
echo "This may take 10-15 minutes for the first deployment..."

# Deploy production environment using the correct format
python3 easy-install.py deploy \
  --email=admin@adnoorerp.com \
  --sitename=adnoorerp.com \
  --app=erpnext

echo ""
echo "✅ Production deployment completed successfully!"
echo "=================================================="
echo "🌐 Your ERPNext instance is now live at: https://adnoorerp.com"
echo "👤 Admin credentials: Administrator / admin (change immediately!)"
echo ""
echo "📁 Production files are located in: ./adnoor-prod/"
echo "🔧 To manage the environment, use: docker compose -f adnoor-prod/docker-compose.yml"
echo ""
echo "🔒 Security checklist:"
echo "1. Change the default admin password immediately"
echo "2. Set up proper user roles and permissions"
echo "3. Configure SSL certificate (should be automatic with Let's Encrypt)"
echo "4. Set up automated backups"
echo "5. Configure monitoring and alerts"
echo ""
echo "📚 Next steps:"
echo "1. Access https://adnoorerp.com and complete initial setup"
echo "2. Change admin password and configure security settings"
echo "3. Set up your company information and chart of accounts"
echo "4. Configure your custom app and fixtures"
echo "5. Set up automated backups and monitoring"
echo ""
echo "🎉 Production deployment successful! Your ERPNext is now live!"
