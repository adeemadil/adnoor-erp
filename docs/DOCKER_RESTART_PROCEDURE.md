# Docker Restart Procedure

## Overview
After Docker Desktop restarts or system reboot, the Frappe application inside the container needs to be manually started. This is a simple 30-second process.

## Quick Fix (30 seconds)

### Step 1: Start Frappe Application
```bash
docker exec -it adnoor-dev-frappe-1 bash -c "cd /workspace/development/frappe-bench && bench start"
```

### Step 2: Wait 30 seconds
The application will start and be available at:
- **Local**: https://adnoor-dev.local/
- **Direct**: http://localhost:8000

## What Happens
1. ✅ **Docker containers start automatically** (MariaDB, Redis, Frappe container)
2. ❌ **Frappe application doesn't auto-start** (needs manual trigger)
3. ✅ **Nginx reconnects automatically** (no configuration needed)

## Why This Happens
- Docker containers start fine
- The `bench start` command inside the Frappe container doesn't run automatically
- This is normal behavior for development containers
- Nginx configuration is persistent and reconnects automatically

## Verification
```bash
# Check if containers are running
docker ps

# Check if application is responding
curl -I http://localhost:8000

# Should return: HTTP/1.1 200 OK
```

## Troubleshooting
If the above doesn't work:

### Check Container Status
```bash
docker ps
# Should show: adnoor-dev-frappe-1, adnoor-dev-mariadb-1, adnoor-dev-redis-cache-1, adnoor-dev-redis-queue-1
```

### Restart Containers if Needed
```bash
cd /Users/adeemadilkhatri/adnoor-erp/frappe_docker
docker compose restart
```

### Check Application Logs
```bash
docker logs adnoor-dev-frappe-1
```

## Notes
- This procedure only takes 30 seconds
- Your data is safe (containers preserve data between restarts)
- No configuration changes needed
- Nginx automatically reconnects once Frappe starts
