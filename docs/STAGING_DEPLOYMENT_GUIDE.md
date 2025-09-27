# AdNoor ERP Staging Deployment Guide

## 🎯 Overview

This guide provides step-by-step instructions for deploying AdNoor ERP to a staging environment that mirrors your production setup.

## 📋 Prerequisites

### Server Requirements
- **OS**: Ubuntu 24.04 LTS (fresh installation recommended)
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: Minimum 50GB SSD
- **CPU**: 2+ cores
- **Network**: Public IP address with DNS access

### Domain Setup
- Subdomain: `staging.adnoorerp.com`
- DNS record pointing to your staging server's IP address

## 🚀 Deployment Process

### Step 1: Server Preparation

1. **Connect to your staging server**:
   ```bash
   ssh username@your-staging-server-ip
   ```

2. **Create a non-root user** (if not already done):
   ```bash
   sudo adduser frappe
   sudo usermod -aG sudo frappe
   su - frappe
   ```

### Step 2: Automated Deployment

1. **Transfer deployment scripts** to your staging server:
   ```bash
   # From your local machine
   scp scripts/deploy-staging.sh frappe@your-staging-server:/home/frappe/
   scp scripts/restore-to-staging.sh frappe@your-staging-server:/home/frappe/
   ```

2. **Run the deployment script**:
   ```bash
   # On staging server
   cd /home/frappe
   chmod +x deploy-staging.sh
   ./deploy-staging.sh
   ```

   This script will:
   - Update system packages
   - Install Docker and Docker Compose
   - Deploy Frappe/ERPNext with HRMS
   - Configure Nginx
   - Setup SSL certificates
   - Create backup scripts

### Step 3: Data Restoration

1. **Copy production backups** to staging server:
   ```bash
   # From your local machine
   scp backups/latest_production_database.sql.gz frappe@your-staging-server:/home/frappe/adnoor-staging/backups/
   scp backups/latest_production_files.tar.gz frappe@your-staging-server:/home/frappe/adnoor-staging/backups/
   ```

2. **Run the restoration script**:
   ```bash
   # On staging server
   cd /home/frappe
   chmod +x restore-to-staging.sh
   ./restore-to-staging.sh
   ```

## 🔧 Manual Configuration (if needed)

### Nginx Configuration
If the automated setup doesn't work, manually configure Nginx:

```bash
sudo nano /etc/nginx/sites-available/staging.adnoorerp.com
```

Add:
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

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/staging.adnoorerp.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### SSL Certificate
Get SSL certificate:
```bash
sudo certbot --nginx -d staging.adnoorerp.com --non-interactive --agree-tos --email admin@adnoorerp.com
```

## 🧪 Testing Checklist

### Basic Functionality
- [ ] Site loads at `https://staging.adnoorerp.com`
- [ ] Login page displays AdNoor branding
- [ ] Administrator login works (Admin@1234)
- [ ] All modules load without errors
- [ ] User roles and permissions work

### Data Integrity
- [ ] All production users are present
- [ ] Customer data is intact
- [ ] Item/Product data is present
- [ ] Transaction history is preserved
- [ ] Reports generate correctly

### Branding Verification
- [ ] Browser title shows "AdNoor ERP"
- [ ] Login page shows AdNoor logo
- [ ] Footer shows correct company information
- [ ] Favicon displays correctly
- [ ] No GhausERP references remain

### Performance Testing
- [ ] Page load times are acceptable
- [ ] Database queries perform well
- [ ] File uploads/downloads work
- [ ] Mobile responsiveness

## 🔍 Troubleshooting

### Common Issues

**1. Site Not Accessible**
```bash
# Check Docker containers
docker ps

# Check Nginx status
sudo systemctl status nginx

# Check logs
docker logs adnoor-staging-frappe-1
```

**2. Database Connection Issues**
```bash
# Check MariaDB container
docker exec adnoor-staging-mariadb-1 mysql -u root -p -e "SHOW DATABASES;"

# Verify site config
docker exec adnoor-staging-frappe-1 cat /workspace/development/frappe-bench/sites/staging.adnoorerp.com/site_config.json
```

**3. SSL Certificate Issues**
```bash
# Check certificate status
sudo certbot certificates

# Renew certificate
sudo certbot renew --dry-run
```

**4. Permission Issues**
```bash
# Fix file permissions
sudo chown -R frappe:frappe /home/frappe/adnoor-staging/
sudo chmod -R 755 /home/frappe/adnoor-staging/
```

## 📊 Monitoring Setup

### Log Monitoring
```bash
# View Frappe logs
docker logs -f adnoor-staging-frappe-1

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### System Monitoring
```bash
# Check system resources
htop
df -h
free -h

# Check Docker resource usage
docker stats
```

## 🔄 Backup Strategy

### Automated Backups
The deployment script sets up daily backups at 3 AM:
- Database backup (gzipped SQL dump)
- Files backup (compressed tar)
- Retention: 7 days

### Manual Backup
```bash
cd /home/frappe/adnoor-staging/scripts
./backup.sh
```

## 🚀 Going Live

Once staging is fully tested and approved:

1. **Update production deployment script** with staging learnings
2. **Prepare production server** with same specifications
3. **Schedule maintenance window** for production deployment
4. **Execute production deployment** using refined scripts
5. **Monitor post-deployment** for 24-48 hours

## 📞 Support

For issues during deployment:
1. Check this troubleshooting guide
2. Review logs in `/home/frappe/adnoor-staging/`
3. Consult the main troubleshooting log: `docs/TROUBLESHOOTING_LOG.md`

---

*Last Updated: $(date)*
*Version: 1.0*
*Status: Ready for Deployment*
