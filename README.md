# AdNoor ERP

Production ERPNext deployment for AdNoor business operations.

## Project Overview

This project implements a complete ERPNext solution for AdNoor business, mirroring the production environment at https://adnoorerp.com.

## Environments

### Development (Laptop)
- **URL**: http://localhost:8080 or http://adnoor-dev.local:8080
- **Setup**: `python3 easy-install.py deploy --email=admin@adnoorerp.com --sitename=adnoor-dev.local --app=erpnext`
- **Purpose**: Local development and testing
- **Status**: ✅ **INSTALLED AND RUNNING**

### Production (Contabo VM)
- **URL**: https://adnoorerp.com
- **Setup**: `python3 easy-install.py deploy --project=adnoor-prod --sitename=adnoorerp.com`
- **Purpose**: Live production environment

## Quick Start

### Local Development
```bash
# Start development environment
./scripts/start-dev.sh

# Or run directly:
python3 easy-install.py deploy --email=admin@adnoorerp.com --sitename=adnoor-dev.local --app=erpnext

# Access at http://localhost:8080 or http://adnoor-dev.local:8080
# Admin credentials: Administrator / deea4eb752c5
# MariaDB root password: 880aa9112
# Passwords saved in: /Users/adeemadilkhatri/frappe-passwords.txt
```

### Production Deployment
```bash
# Deploy to Contabo VM
./scripts/deploy-production.sh

# Or run directly:
python3 easy-install.py deploy --email=admin@adnoorerp.com --sitename=adnoorerp.com --app=erpnext
```

## Project Structure
```
adnoor-erp/
├── docs/                    # Documentation and implementation plans
│   └── IMPLEMENTATION_PLAN.md
├── config/                  # Configuration files
│   ├── apps.json           # Custom apps configuration
│   └── .env                # Environment variables
├── scripts/                 # Deployment and maintenance scripts
│   ├── start-dev.sh        # Start development environment
│   └── deploy-production.sh # Deploy to production
├── apps/                    # Custom Frappe applications
│   └── adnoor_custom/      # Main custom app for all customizations
├── easy-install.py         # Frappe Bench easy install script
├── frappe_docker/          # Frappe Docker repository (cloned)
└── README.md               # This file
```

## Development Workflow

1. **Local Development**: Make changes in the development environment
2. **Testing**: Test all changes locally before deployment
3. **Version Control**: Commit changes to git repository
4. **Production Deployment**: Deploy tested changes to Contabo VM

## Current Status ✅

- **✅ ERPNext v15.79.0 Successfully Installed**
- **✅ Development Environment Running**
- **✅ Site Created**: adnoor-dev.local
- **✅ Easy Install Script Setup Complete**
- **✅ Project Structure Organized**
- **✅ Documentation and Scripts Ready**
- **🔄 Next**: Access and verify ERPNext instance, create custom app

## Key Features

- **ERPNext v15.79.0**: Latest stable version
- **Custom App**: All customizations in `adnoor_custom` app
- **SSL Support**: Automatic Let's Encrypt integration
- **Backup Strategy**: Automated backup scheduling
- **Easy Updates**: Simple upgrade process

## Phase 1 Goals (Current)
- Core ERPNext flows: Sales, Purchase, Quotations, Invoices/Payments
- Masters: Customer, Supplier, Item, etc.
- Inventory management
- General Ledger
- Roles & Permissions
- Basic reports and print formats
- Dashboards

## Phase 2+ Goals
- Advanced workflows and dashboards
- Logistics integration
- Supplier portal
- Twilio integration
- Mobile app
- System expansion

## Support

For issues and questions, refer to:
- [ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe Framework Documentation](https://frappeframework.com/docs)
- Project documentation in `docs/` directory

---

*Last Updated: $(date)*
*Version: 1.0*
