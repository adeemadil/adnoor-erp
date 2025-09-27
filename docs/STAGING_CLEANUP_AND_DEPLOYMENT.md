# AdNoor ERP Staging Cleanup and Fresh Deployment

## 🧹 Step 1: Cleanup Previous Staging Environment

### Connect to Your Staging Server
```bash
ssh as_techsolutions_sales@34.60.234.74
```

### Upload and Run Cleanup Script
```bash
# From your local machine, upload the cleanup script
scp scripts/cleanup-staging.sh as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/

# On the staging server
cd /home/as_techsolutions_sales
chmod +x cleanup-staging.sh
./cleanup-staging.sh
```

**What the cleanup script does:**
- ✅ Stops and removes all Docker containers
- ✅ Removes Docker volumes and networks
- ✅ Deletes all staging directories (`adnoor-erp`, `backups`, `adnoor-staging`)
- ✅ Removes staging configuration files
- ✅ Cleans up Nginx configurations
- ✅ Removes SSL certificates
- ✅ Cleans up cron jobs
- ✅ Removes user from docker group

## 🚀 Step 2: Fresh Staging Deployment

### Upload Deployment Scripts
```bash
# From your local machine
scp scripts/deploy-staging.sh as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/
scp scripts/restore-to-staging.sh as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/
```

### Run Fresh Deployment
```bash
# On the staging server
cd /home/as_techsolutions_sales
chmod +x deploy-staging.sh
./deploy-staging.sh
```

**What the deployment script does:**
- ✅ Updates Ubuntu system packages
- ✅ Installs Docker and Docker Compose
- ✅ Deploys Frappe/ERPNext + HRMS using easy-install.py
- ✅ Configures Nginx for staging domain
- ✅ Sets up SSL certificates via Let's Encrypt
- ✅ Creates automated backup system
- ✅ Configures staging environment

## 📊 Step 3: Restore Production Data

### Upload Production Backups
```bash
# From your local machine
scp backups/latest_production_database.sql.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-staging/backups/
scp backups/latest_production_files.tar.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-staging/backups/
```

### Run Data Restoration
```bash
# On the staging server
cd /home/as_techsolutions_sales
chmod +x restore-to-staging.sh
./restore-to-staging.sh
```

**What the restoration script does:**
- ✅ Drops existing staging site
- ✅ Creates new staging site with ERPNext + HRMS
- ✅ Restores production database
- ✅ Restores production files
- ✅ Updates site configuration for staging
- ✅ Resets administrator password
- ✅ Applies AdNoor branding
- ✅ Runs post-restoration tests

## 🌐 Step 4: Configure Domain Access

### DNS Configuration
Update your DNS settings to point `staging.adnoorerp.com` to `34.60.234.74`

### Verify SSL Certificate
```bash
# On the staging server
sudo certbot certificates
```

## 🧪 Step 5: Testing Checklist

### Basic Functionality Tests
- [ ] Site loads at `https://staging.adnoorerp.com`
- [ ] Login page displays AdNoor branding
- [ ] Administrator login works (`Administrator` / `Admin@1234`)
- [ ] All modules load without errors

### Data Integrity Tests
- [ ] All production users are present
- [ ] Customer data is intact
- [ ] Item/Product data is present
- [ ] Transaction history is preserved

### Branding Verification
- [ ] Browser title shows "AdNoor ERP"
- [ ] Login page shows AdNoor logo
- [ ] Footer shows correct company information
- [ ] No GhausERP references remain

## 🔧 Troubleshooting

### Common Issues

**1. Cleanup Script Fails**
```bash
# Manual cleanup if needed
sudo docker system prune -a --volumes
sudo rm -rf adnoor-*
sudo rm -rf backups
```

**2. Deployment Fails**
```bash
# Check system requirements
free -h
df -h
sudo apt update && sudo apt upgrade -y
```

**3. SSL Certificate Issues**
```bash
# Manual SSL setup
sudo certbot --nginx -d staging.adnoorerp.com --non-interactive --agree-tos --email admin@adnoorerp.com
```

**4. Data Restoration Issues**
```bash
# Check container status
docker ps
docker logs adnoor-staging-frappe-1
```

## 📋 Expected Results

After successful deployment, you should have:

### Environment Details
- **URL**: `https://staging.adnoorerp.com`
- **Admin Login**: `Administrator` / `Admin@1234`
- **Database**: MariaDB with production data
- **SSL**: Let's Encrypt certificate
- **Backups**: Automated daily backups

### File Structure
```
/home/as_techsolutions_sales/
├── adnoor-staging/
│   ├── config/
│   │   └── staging.env
│   ├── backups/
│   │   ├── latest_production_database.sql.gz
│   │   └── latest_production_files.tar.gz
│   └── scripts/
│       └── backup.sh
├── deploy-staging.sh
└── restore-to-staging.sh
```

## 🎯 Next Steps

1. **Test all functionality** using the provided checklist
2. **Verify data integrity** by comparing with production
3. **Test user roles and permissions**
4. **Document any issues** found during testing
5. **Prepare for production deployment** once staging is validated

## 📞 Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Review Docker logs: `docker logs adnoor-staging-frappe-1`
3. Check system resources: `htop`, `df -h`
4. Verify network connectivity and DNS resolution

---

*Ready for staging deployment! 🚀*
