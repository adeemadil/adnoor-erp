# AdNoor ERP

Production ERPNext deployment for AdNoor business operations.

## Project Overview

This project implements a complete ERPNext solution for AdNoor business, mirroring the production environment at https://adnoorerp.com.

## Environments

### Development (Laptop)
- **URL**: https://adnoor-dev.local
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

# Access at https://adnoor-dev.local
# Admin credentials: Administrator / admin123
# MariaDB root password: 880aa9112
# Passwords saved in: /Users/adeemadilkhatri/frappe-passwords.txt
# Note: Add "127.0.0.1 adnoor-dev.local" to /etc/hosts for proper access
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
- **✅ ERPNext Instance Accessible**: https://adnoor-dev.local
- **✅ Login Working**: Administrator / admin123
- **✅ Setup Wizard Completed**
- **✅ Production Data Restored** (Latest from Contabo VM)
- **✅ HRMS App Installed** (Matches production)
- **✅ Database Migration Completed**
- **✅ Local Instance Fully Functional**
- **🔄 Next**: Test user roles, create custom app, begin Phase 2 development

## Key Features

- **ERPNext v15.79.0**: Latest stable version
- **Custom App**: All customizations in `adnoor_custom` app
- **SSL Support**: Automatic Let's Encrypt integration
- **Backup Strategy**: Automated backup scheduling
- **Easy Updates**: Simple upgrade process

## AdNoor ERP Implementation Phases

### Phase 1: Core ERPNext Setup (2-3 Weeks) ✅ COMPLETED
- ✅ Sales Orders, Purchase Orders, Quotations, Invoices & Payments
- ✅ Product Master, Customer/Supplier Profiles, Warehouse & Inventory
- ✅ Journal Entries & GL, Employee Roles & Permissions, Reports Dashboard

### Phase 2: Custom Workflows & Dashboards (4-5 Weeks) 🔄 NEXT
- [ ] Weekly Task Manager, Procurement Dashboard, Lead & Data Team Workflow
- [ ] Reorder + Delivery Scheduling Automation, Container Costing Tool
- [ ] Commission Calculation System, Price Management (Wholesale/Retail)
- [ ] CEO Dashboard, Audit Trail, Notifications Module
- [ ] Role-Based Dashboards, Restaurant & Distributor Data Reporting

### Phase 3: Delivery & Logistics Integration (3-4 Weeks)
- [ ] Delivery/Dispatch Module, Goods Receipt Note (GRN)
- [ ] Mobile App for Drivers, Tracking & Fulfilment Updates

### Phase 4: Supplier Portal + Region Expansion (3-4 Weeks)
- [ ] Supplier Dashboard, City/Province Management View
- [ ] Container Workflow Integration, Admin Monitoring

### Phase 5: Twilio Telephony & Call Center Integration (3-4 Weeks)
- [x] CRM Core Workflows (Lead intake, Filtering, Assignment, Follow-ups)
- [ ] Click-to-Call from CRM, In-Browser Softphone, Call Logging & Recording

### Phase 6: Mobile App (4-6 Weeks)
- [ ] Drivers App, Admins (lite view), Optional: B2B/B2C customers

### Phase 7: Smart Expansion (3-4 Weeks)
- [ ] POS System, Barcode/QR Workflow, Vendor Onboarding System

### Phase 8: Production Deployment & Security
- [ ] Complete source code ownership, Full admin panel access
- [ ] Custom field addition capability, Database access
- [ ] Backup and recovery procedures, Documentation

## Troubleshooting

### Access Issues
- **SSL Warning**: Accept the self-signed certificate warning (normal for development)
- **localhost:8080 not working**: Use https://adnoor-dev.local instead
- **Host not found**: Add `127.0.0.1 adnoor-dev.local` to `/etc/hosts`

### Login Issues
- **Username**: Administrator (case-sensitive)
- **Password**: admin123 (reset from original password)
- **Reset password**: `docker exec frappe-backend-1 bench --site adnoor-dev.local set-admin-password newpassword`

## Support

For issues and questions, refer to:
- [ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe Framework Documentation](https://frappeframework.com/docs)
- Project documentation in `docs/` directory

---

*Last Updated: $(date)*
*Version: 1.0*
