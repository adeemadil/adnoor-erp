# AdNoor ERP Staging Deployment Procedure

## 🎯 Overview

This document provides the step-by-step procedure for deploying AdNoor ERP to staging environment, mirroring the successful local setup approach.

## 📋 Prerequisites

### Server Requirements
- **OS**: Ubuntu 24.04 LTS (AMD64/x86_64)
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: Minimum 50GB SSD
- **CPU**: 2+ cores
- **Network**: Public IP with SSH access

### Access Requirements
- SSH access to staging server
- Production backups available
- Domain configured (staging.adnoorerp.com)

## 🚀 Deployment Steps

### Step 1: Server Preparation

1. **Connect to staging server**:
   ```bash
   ssh -o StrictHostKeyChecking=no as_techsolutions_sales@34.60.234.74
   ```

2. **Update system packages**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **Install required dependencies**:
   ```bash
   # Install pip for user (if sudo not available)
   curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
   python3 get-pip.py --user
   
   # Add to PATH
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

### Step 2: Repository Setup

1. **Upload repository to staging server**:
   ```bash
   # From local machine
   scp -r . as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-erp/
   ```

2. **Verify repository structure**:
   ```bash
   # On staging server
   ls -la /home/as_techsolutions_sales/adnoor-erp/
   # Should show: config/, docs/, scripts/, backups/, frappe_docker/, etc.
   ```

### Step 3: Frappe Bench Installation

1. **Install Frappe Bench**:
   ```bash
   cd /home/as_techsolutions_sales/adnoor-erp/frappe_docker/development
   python3 -m pip install --user frappe-bench
   ```

2. **Add to PATH**:
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Verify bench installation**:
   ```bash
   bench --version
   ```

### Step 4: Create Frappe Bench

1. **Initialize bench**:
   ```bash
   cd /home/as_techsolutions_sales/adnoor-erp/frappe_docker/development
   bench init frappe-bench --python python3
   ```

2. **Navigate to bench directory**:
   ```bash
   cd frappe-bench
   ```

3. **Configure bench**:
   ```bash
   bench set-config db_host localhost
   bench set-config redis_cache redis://localhost:13000
   bench set-config redis_queue redis://localhost:11000
   bench set-config redis_socketio redis://localhost:12000
   ```

### Step 5: Install Dependencies

1. **Install MariaDB**:
   ```bash
   sudo apt install -y mariadb-server mariadb-client
   sudo systemctl start mariadb
   sudo systemctl enable mariadb
   sudo mysql_secure_installation
   ```

2. **Install Redis**:
   ```bash
   sudo apt install -y redis-server
   sudo systemctl start redis-server
   sudo systemctl enable redis-server
   ```

3. **Configure MariaDB**:
   ```bash
   sudo mysql -u root -p
   # In MySQL prompt:
   CREATE USER 'frappe'@'localhost' IDENTIFIED BY 'frappe';
   GRANT ALL PRIVILEGES ON *.* TO 'frappe'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```

### Step 6: Create Staging Site

1. **Create site**:
   ```bash
   cd /home/as_techsolutions_sales/adnoor-erp/frappe_docker/development/frappe-bench
   bench new-site staging.adnoorerp.com --admin-password Admin@1234 --db-root-password frappe
   ```

2. **Install ERPNext**:
   ```bash
   bench get-app erpnext --branch version-15
   bench --site staging.adnoorerp.com install-app erpnext
   ```

3. **Install HRMS**:
   ```bash
   bench get-app hrms --branch version-15
   bench --site staging.adnoorerp.com install-app hrms
   ```

### Step 7: Restore Production Data

1. **Copy production backups**:
   ```bash
   # From local machine
   scp backups/latest_production_database.sql.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-erp/backups/
   scp backups/latest_production_files.tar.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-erp/backups/
   ```

2. **Drop existing site and recreate**:
   ```bash
   # On staging server
   cd /home/as_techsolutions_sales/adnoor-erp/frappe_docker/development/frappe-bench
   bench drop-site staging.adnoorerp.com --force --db-root-password frappe
   bench new-site staging.adnoorerp.com --admin-password Admin@1234 --db-root-password frappe
   bench --site staging.adnoorerp.com install-app erpnext
   bench --site staging.adnoorerp.com install-app hrms
   ```

3. **Restore database**:
   ```bash
   bench --site staging.adnoorerp.com restore /home/as_techsolutions_sales/adnoor-erp/backups/latest_production_database.sql.gz --with-public-files /home/as_techsolutions_sales/adnoor-erp/backups/latest_production_files.tar.gz --db-root-password frappe
   ```

### Step 8: Configure Site

1. **Update site configuration**:
   ```bash
   bench --site staging.adnoorerp.com set-config app_name "AdNoor ERP"
   bench --site staging.adnoorerp.com set-config title_prefix "AdNoor ERP"
   bench --site staging.adnoorerp.com set-config favicon "/files/adnoor_website_logo_250wd58ce2.png"
   ```

2. **Reset admin password**:
   ```bash
   bench --site staging.adnoorerp.com set-admin-password Admin@1234
   ```

3. **Clear cache**:
   ```bash
   bench --site staging.adnoorerp.com clear-cache
   ```

### Step 9: Start Services

1. **Start bench services**:
   ```bash
   bench start
   ```

2. **Configure Nginx**:
   ```bash
   sudo nano /etc/nginx/sites-available/staging.adnoorerp.com
   ```

   Add the following configuration:
   ```nginx
   server {
       listen 80;
       server_name staging.adnoorerp.com;
       
       location / {
           proxy_pass http://localhost:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Enable site**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/staging.adnoorerp.com /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### Step 10: SSL Configuration

1. **Install SSL certificate**:
   ```bash
   sudo certbot --nginx -d staging.adnoorerp.com --non-interactive --agree-tos --email admin@adnoorerp.com
   ```

2. **Test SSL**:
   ```bash
   curl -I https://staging.adnoorerp.com
   ```

## 🧪 Testing Checklist

### Basic Functionality
- [ ] Site loads at `https://staging.adnoorerp.com`
- [ ] Login page displays AdNoor branding
- [ ] Administrator login works (`Administrator` / `Admin@1234`)
- [ ] All modules load without errors

### Data Integrity
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

**1. Bench Command Not Found**
```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.bashrc
```

**2. Database Connection Issues**
```bash
sudo systemctl status mariadb
sudo systemctl start mariadb
```

**3. Redis Connection Issues**
```bash
sudo systemctl status redis-server
sudo systemctl start redis-server
```

**4. Site Not Accessible**
```bash
bench --site staging.adnoorerp.com doctor
bench --site staging.adnoorerp.com clear-cache
```

**5. Permission Issues**
```bash
sudo chown -R as_techsolutions_sales:as_techsolutions_sales /home/as_techsolutions_sales/
```

## 📊 Expected Results

After successful deployment:

- **URL**: `https://staging.adnoorerp.com`
- **Admin Login**: `Administrator` / `Admin@1234`
- **Database**: MariaDB with production data
- **SSL**: Let's Encrypt certificate
- **Performance**: Fast page loads, responsive UI

## 🚀 Production Deployment

Once staging is validated, use this same procedure for production deployment with these modifications:

1. **Change domain** from `staging.adnoorerp.com` to `adnoorerp.com`
2. **Use production server** instead of staging server
3. **Update DNS** to point to production server IP
4. **Configure production backups** and monitoring

## 📝 Notes

- This procedure mirrors the successful local setup approach
- Uses Frappe Bench directly (no Docker complications)
- Follows the same pattern that worked for `adnoor-dev.local`
- Architecture compatibility: AMD64 for both staging and production VMs

---

*Last Updated: $(date)*
*Version: 1.0*
*Status: Ready for Staging Deployment*
