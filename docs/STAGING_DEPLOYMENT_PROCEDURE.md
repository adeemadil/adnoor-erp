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

## 🔄 Workflow Overview

**The deployment follows this pattern:**
1. **SSH into VM** → Access the staging server
2. **Enter Docker container** → Access the Frappe environment  
3. **Use Bench commands** → Create site, install apps, restore data
4. **Exit container** → Return to VM host for Nginx/SSL setup

**Key Points:**
- All `bench` commands are executed **inside the Docker container**
- All `docker`, `nginx`, `certbot` commands are executed **on the VM host**
- The MariaDB password is `123` (not `admin123` or `frappe`)
- Database host is `mariadb` (Docker service name)

## 🚀 Deployment Steps

### Step 1: Server Preparation

1. **Connect to staging server**:
   ```bash
   ssh -o StrictHostKeyChecking=no as_techsolutions_sales@34.60.234.74
   ```

2. **Check Docker containers are running**:
   ```bash
   docker ps
   # Should show: frappe, mariadb, redis containers
   ```

3. **Access the Frappe Docker container**:
   ```bash
   docker exec -it adnoor-staging-frappe-1 bash
   # You should now be inside the container
   ```

4. **Navigate to the Frappe Bench directory**:
   ```bash
   cd /home/frappe/frappe-bench
   # or /workspace/development/frappe-bench
   ```

### Step 2: Create Staging Site

**⚠️ IMPORTANT**: You are now inside the Docker container. All commands below are executed within the container.

1. **Create site with correct database host**:
   ```bash
   bench new-site staging.adnoorerp.com --admin-password Admin@1234 --mariadb-root-password 123 --mariadb-root-username root --db-host mariadb
   ```

2. **Download ERPNext**:
   ```bash
   bench get-app erpnext --branch version-15
   ```

3. **Download HRMS**:
   ```bash
   bench get-app hrms --branch version-15
   ```

4. **Install ERPNext**:
   ```bash
   bench --site staging.adnoorerp.com install-app erpnext
   ```

5. **Install HRMS**:
   ```bash
   bench --site staging.adnoorerp.com install-app hrms
   ```

### Step 3: Restore Production Data

1. **Copy production backups to VM** (from local machine):
   ```bash
   scp backups/latest_production_database.sql.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-erp/backups/
   scp backups/latest_production_files.tar.gz as_techsolutions_sales@34.60.234.74:/home/as_techsolutions_sales/adnoor-erp/backups/
   ```

2. **Restore database** (inside Docker container):
   ```bash
   bench --site staging.adnoorerp.com restore /home/as_techsolutions_sales/adnoor-erp/backups/latest_production_database.sql.gz --with-public-files /home/as_techsolutions_sales/adnoor-erp/backups/latest_production_files.tar.gz --mariadb-root-password 123
   ```

### Step 4: Configure Site

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

### Step 5: Start Services

1. **Start bench services** (inside Docker container):
   ```bash
   bench start
   ```

2. **Exit Docker container**:
   ```bash
   exit
   # You're now back on the VM host
   ```

3. **Configure Nginx on VM host**:
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

4. **Enable site**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/staging.adnoorerp.com /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### Step 6: SSL Configuration

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

**1. Docker Permission Denied**
```bash
# On VM host
sudo usermod -aG docker $USER
newgrp docker
docker ps
```

**2. Container Not Running**
```bash
# On VM host
docker ps
docker-compose up -d
```

**3. Database Connection Issues (inside container)**
```bash
# Check if mariadb container is accessible
ping mariadb
# Verify password
docker exec adnoor-staging-mariadb-1 mysql -u root -p123 -e "SHOW DATABASES;"
```

**4. Site Creation Fails**
```bash
# Inside Docker container
bench --site staging.adnoorerp.com doctor
bench --site staging.adnoorerp.com clear-cache
```

**5. Wrong Database Password**
```bash
# Check the correct password in docker-compose.yml
cat /home/as_techsolutions_sales/adnoor-erp/frappe_docker/devcontainer-example/docker-compose.yml | grep MYSQL_ROOT_PASSWORD
# Should show: MYSQL_ROOT_PASSWORD=123
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
