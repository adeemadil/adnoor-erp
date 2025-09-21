#!/bin/bash

# AdNoor ERP Development Environment Startup Script
# This script starts the development environment using the easy install script

set -e  # Exit on any error

echo "🚀 Starting AdNoor ERP Development Environment..."
echo "=================================================="

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

# Make sure easy-install.py is executable
chmod +x easy-install.py

echo "📦 Starting development environment with easy install script..."
echo "Project: adnoor-dev"
echo "This may take several minutes for the first run..."

# Start development environment using the correct format
python3 easy-install.py deploy --email=admin@adnoorerp.com --sitename=adnoor-dev.local --app=erpnext

echo ""
echo "✅ Development environment started successfully!"
echo "=================================================="
echo "🌐 Access your ERPNext instance at: http://localhost:8080"
echo "👤 Default credentials: Administrator / admin"
echo ""
echo "📁 Project files are located in: ./adnoor-dev/"
echo "🔧 To stop the environment, run: docker compose -f adnoor-dev/docker-compose.yml down"
echo ""
echo "📚 Next steps:"
echo "1. Access the web interface and complete initial setup"
echo "2. Create your custom app: bench new-app --no-git adnoor_custom"
echo "3. Install your custom app: bench --site sitename install-app adnoor_custom"
echo "4. Start developing your customizations"
echo ""
echo "Happy coding! 🎉"
