# AdNoor ERP Troubleshooting Log

This document tracks major issues encountered during the AdNoor ERP setup and their resolutions to prevent repeating the same problems in future deployments.

## 🚨 Critical Issues & Resolutions

### 1. **Production Data Restoration Failure**
**Issue**: Initial backup restoration appeared successful but only restored 2 default users instead of 12 production users.

**Symptoms**:
- Setup wizard still showing after "successful" restore
- Only Administrator and Guest users present
- Missing AdNoor production users and data

**Root Cause**: The `bench restore` command didn't properly overwrite the existing site data.

**Resolution**:
```bash
# 1. Drop the existing site completely
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench drop-site adnoor-dev.local --force --db-root-password 123"

# 2. Create fresh site
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench new-site adnoor-dev.local --db-root-password 123 --admin-password admin123"

# 3. Install required apps
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local install-app erpnext"
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local install-app hrms"

# 4. Restore production data
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local restore /tmp/latest_production_database.sql.gz --with-public-files /tmp/latest_production_files.tar.gz --db-root-password 123"
```

**Verification**: Check user count with `SELECT COUNT(*) FROM tabUser;` - should show 12+ users instead of 2.

---

### 2. **ERPNext/Frappe Version Mismatch**
**Issue**: Trying to install ERPNext v15 with Frappe v16 caused compatibility errors.

**Error**: `You're attempting to install ERPNext version 15 with Frappe version 16. This is not supported`

**Resolution**: Use compatible versions:
- **Frappe**: 15.x.x-develop (develop branch)
- **ERPNext**: 15.x.x-develop (develop branch)
- **HRMS**: 15.50.1 (version-15 branch)

---

### 3. **Database Connection Issues During Site Creation**
**Issue**: `MySQLdb.OperationalError: (2002, "Can't connect to server on '127.0.0.1' (115)")`

**Root Cause**: Frappe container couldn't connect to MariaDB container using localhost.

**Resolution**:
```bash
# Set correct database host and port
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench set-config db_host mariadb-1"
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench set-config db_port 3306"
```

---

### 4. **Database User Permission Issues**
**Issue**: `MySQLdb.OperationalError: (1045, "Access denied for user '_7582f31605ae940d'@'172.18.0.5' (using password: YES)")`

**Root Cause**: Site's database user didn't have proper permissions from the container's IP.

**Resolution**:
```bash
# Grant permissions to site user from any host
docker exec adnoor-dev-mariadb-1 mysql -u root -p123 -e "GRANT ALL PRIVILEGES ON _7582f31605ae940d.* TO '_7582f31605ae940d'@'%' IDENTIFIED BY 'c4zEUfvP3yxNHxQI';"
```

---

### 5. **Container Architecture Differences**
**Issue**: Confusion about missing frontend/backend containers.

**Explanation**: The `easy-install.py` script uses a different architecture than traditional `frappe_docker`:
- **easy-install.py**: Single Frappe container running development server
- **frappe_docker**: Separate frontend (Nginx) and backend (Frappe) containers

**Resolution**: Understand that both approaches are valid, just different architectures.

---

### 6. **Port Configuration Issues**
**Issue**: Site not accessible on expected ports.

**Resolution**: 
- **easy-install.py**: Uses port 8000 by default
- **frappe_docker**: Uses port 8080 with Nginx proxy
- Always check `docker ps` to see actual port mappings

---

### 7. **HRMS App Compatibility**
**Issue**: `ModuleNotFoundError: No module named 'hrms'` after restoring production data.

**Root Cause**: Production had HRMS installed but local environment didn't.

**Resolution**:
```bash
# Install HRMS app
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local install-app hrms"

# Run migrations
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local migrate"
```

---

## 🔧 Common Commands Reference

### Site Management
```bash
# Create new site
bench new-site sitename --db-root-password password --admin-password password

# Drop site
bench drop-site sitename --force --db-root-password password

# Restore from backup
bench --site sitename restore database.sql.gz --with-public-files files.tar.gz --db-root-password password

# Run migrations
bench --site sitename migrate

# List apps
bench --site sitename list-apps
```

### User Management
```bash
# Set admin password
bench --site sitename set-admin-password newpassword

# List users
bench --site sitename mariadb -e "SELECT name, email, enabled FROM tabUser WHERE enabled=1;"
```

### Container Management
```bash
# Check running containers
docker ps

# Check container logs
docker logs container-name --tail 20

# Execute commands in container
docker exec container-name bash -c "command"
```

---

## 🚀 Deployment Checklist

### Before Starting Fresh Installation
1. ✅ Clean up all existing Docker containers and volumes
2. ✅ Verify backup files are available and recent
3. ✅ Check database passwords and credentials
4. ✅ Ensure compatible app versions

### During Installation
1. ✅ Create site with proper database credentials
2. ✅ Install required apps (ERPNext, HRMS)
3. ✅ Restore production data completely
4. ✅ Run migrations
5. ✅ Verify user count and data integrity

### After Installation
1. ✅ Test site accessibility
2. ✅ Verify login credentials
3. ✅ Check all production users are present
4. ✅ Confirm no setup wizard appears
5. ✅ Test key functionality

---

### 8. **Administrator Login Issues**
**Issue**: Cannot login with Administrator credentials after production data restoration.

**Root Cause**: Production data restoration overwrites the Administrator password with production values.

**Resolution**:
```bash
# Reset Administrator password (use correct container name for easy-install.py setup)
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench --site adnoor-dev.local set-admin-password Admin@1234"
```

**Note**: For `easy-install.py` setup, container name is `adnoor-dev-frappe-1`, not `frappe-backend-1`.
**Working Password**: `Admin@1234` (stronger password required by Frappe)

---

### 9. **Domain Access Without Port (Development Environment)**
**Issue**: Cannot access site at `https://adnoor-dev.local/` without port number.

**Root Cause**: The `easy-install.py` development setup only exposes ports 8000-8005, not port 80.

**Resolution**: Use the correct development URL:
- **Working URL**: `http://adnoor-dev.local:8000/` or `https://adnoor-dev.local:8000/`
- **Note**: For production deployment, proper nginx configuration with port 80/443 would be needed.

---

### 10. **Branding Updates After Production Data Restoration**
**Issue**: GhausERP branding still appears after updating Website Settings.

**Root Cause**: Some branding elements are cached or stored in different locations.

**Resolution**:
```bash
# Update site configuration
bench --site sitename set-config app_name 'AdNoor ERP'
bench --site sitename set-config title_prefix 'AdNoor ERP'
bench --site sitename set-config favicon '/files/adnoor_website_logo_250w.png'

# Clear cache after changes
bench --site sitename clear-cache
```

**Note**: Some branding changes require manual updates through Website Settings in the ERPNext UI.

**Favicon Issues**: If old favicon files cause 500 errors, upload new favicon through Website Settings > Brand section and ensure it's set as public.

---

### 11. **Docker Desktop Restart - Local Environment Recovery**
**Issue**: Local environment becomes inaccessible after Docker Desktop closes or restarts.

**Symptoms**:
- `ERR_CONNECTION_REFUSED` or `502 Bad Gateway` errors
- `adnoor-dev.local` not accessible
- Containers may be running but Frappe server not started

**Root Cause**: When Docker Desktop restarts, containers restart but the Frappe development server inside the container doesn't automatically restart.

**Resolution**:
```bash
# 1. Check container status
docker ps -a

# 2. If containers are running but site not accessible, restart Frappe server
docker exec -d adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench serve --port 8000 --host 0.0.0.0"

# 3. Wait 30 seconds and test
curl -I http://adnoor-dev.local
```

**Verification**: Should return `HTTP/1.1 200 OK` with login page content.

**Prevention**: Consider using `docker-compose restart` instead of individual container restarts to ensure all services start properly.

**Time to Recovery**: ~3-4 minutes (2-3 minutes for container startup + 30 seconds for Frappe server startup)

---

## 📝 Notes for Future Deployments

- **Always drop and recreate site** when restoring production data
- **Use compatible app versions** (Frappe 15 + ERPNext 15 + HRMS 15)
- **Set correct database host** for containerized environments
- **Grant proper database permissions** for site users
- **Verify data integrity** after restoration
- **Document all passwords and credentials** in secure location

---

### 12. **Database User Permission Issues After Docker Restart - Local Environment**
**Issue**: `MySQLdb.OperationalError: (1045, "Access denied for user '_dccaadb03538e418'@'172.18.0.2' (using password: YES)")` when accessing local site after Docker restart.

**Root Cause**: The site's database user password in MariaDB doesn't match the password stored in the site configuration file.

**Symptoms**:
- Site shows 500 Internal Server Error
- Database connection errors in logs
- Site accessible via direct port but not through Nginx proxy

**Resolution**:
```bash
# 1. Check the site configuration to find the correct password
docker exec adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && cat sites/adnoor-dev.local/site_config.json"

# 2. Update the database user password to match site config
docker exec adnoor-dev-mariadb-1 mysql -u root -p123 -e "ALTER USER '_dccaadb03538e418'@'%' IDENTIFIED BY 'G6bAc7Nt0aEx8kzt';"
docker exec adnoor-dev-mariadb-1 mysql -u root -p123 -e "ALTER USER '_dccaadb03538e418'@'localhost' IDENTIFIED BY 'G6bAc7Nt0aEx8kzt';"
docker exec adnoor-dev-mariadb-1 mysql -u root -p123 -e "FLUSH PRIVILEGES;"

# 3. Test site accessibility
curl -I http://adnoor-dev.local
```

**Prevention**: Always verify database user passwords match between site configuration and MariaDB user accounts after any database operations.

**Verification**: Should return `HTTP/1.1 200 OK` with proper site content.

**Time to Recovery**: ~2-3 minutes (including troubleshooting time)

---

*Last Updated: September 28, 2025*
*Version: 1.1*
