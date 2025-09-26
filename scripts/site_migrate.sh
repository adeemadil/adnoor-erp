#!/usr/bin/env bash
set -euo pipefail

# Idempotent site create/migrate/install for Frappe/ERPNext using the easy-install compose outputs.
#
# Usage (defaults shown):
#   PROJECT=${PROJECT:-adnoor-staging} \
#   SITE=${SITE:-staging.adnoorerp.com} \
#   COMPOSE_FILE=${COMPOSE_FILE:-$HOME/${PROJECT}-compose.yml} \
#   ./scripts/site_migrate.sh
#
# Optional:
#   ADMIN_PASS / DB_PASS will be read from $HOME/${PROJECT}-passwords.txt if not provided.
#   INSTALL_APPS="erpnext" to ensure app(s) are installed.

PROJECT=${PROJECT:-adnoor-staging}
SITE=${SITE:-staging.adnoorerp.com}
COMPOSE_FILE=${COMPOSE_FILE:-"$HOME/${PROJECT}-compose.yml"}
PASSWORDS_FILE=${PASSWORDS_FILE:-"$HOME/${PROJECT}-passwords.txt"}
INSTALL_APPS=${INSTALL_APPS:-"erpnext"}

need_sudo=""
if ! groups "$USER" | grep -q "\bdocker\b"; then
  need_sudo="sudo"
fi

die() { echo "[site_migrate] ERROR: $*" >&2; exit 1; }

[ -f "$COMPOSE_FILE" ] || die "Compose file not found: $COMPOSE_FILE"

# Load passwords if available
if [ -z "${ADMIN_PASS:-}" ] || [ -z "${DB_PASS:-}" ]; then
  if [ -f "$PASSWORDS_FILE" ]; then
    ADMIN_PASS=${ADMIN_PASS:-$(grep -E '^ADMINISTRATOR_PASSWORD=' "$PASSWORDS_FILE" | cut -d= -f2)}
    DB_PASS=${DB_PASS:-$(grep -E '^MARIADB_ROOT_PASSWORD=' "$PASSWORDS_FILE" | cut -d= -f2)}
  fi
fi

# Helper to run docker compose with project
dc() {
  $need_sudo docker compose -p "$PROJECT" -f "$COMPOSE_FILE" "$@"
}

echo "[site_migrate] Ensuring core services are up..."
dc up -d db redis-cache redis-queue backend

# Wait for DB healthy (max ~180s)
echo "[site_migrate] Waiting for DB health..."
end=$((SECONDS+180))
while [ $SECONDS -lt $end ]; do
  status=$($need_sudo docker inspect -f '{{.State.Health.Status}}' "${PROJECT}-db-1" 2>/dev/null || echo "none")
  [ "$status" = "healthy" ] && break
  sleep 2
done
[ "$status" = "healthy" ] || die "DB did not become healthy"

# Create site if missing
echo "[site_migrate] Checking if site exists..."
if ! dc exec -T backend bash -lc "[ -d \"sites/${SITE}\" ]"; then
  echo "[site_migrate] Creating new site: $SITE"
  [ -n "${DB_PASS:-}" ] || die "DB_PASS not set and not found in ${PASSWORDS_FILE}"
  [ -n "${ADMIN_PASS:-}" ] || die "ADMIN_PASS not set and not found in ${PASSWORDS_FILE}"
  dc exec -T backend bash -lc "bench new-site ${SITE} --mariadb-user-host-login-scope=% --db-root-password=${DB_PASS} --admin-password=${ADMIN_PASS}"
else
  echo "[site_migrate] Site already exists: $SITE"
fi

# Install requested apps if not present
for app in $INSTALL_APPS; do
  if ! dc exec -T backend bash -lc "bench --site ${SITE} list-apps | grep -q '^${app}$'"; then
    echo "[site_migrate] Installing app: ${app}"
    dc exec -T backend bash -lc "bench --site ${SITE} install-app ${app}"
  else
    echo "[site_migrate] App already installed: ${app}"
  fi
done

echo "[site_migrate] Running migrate + cache clear"
dc exec -T backend bash -lc "bench --site ${SITE} migrate && bench clear-cache"

echo "[site_migrate] Starting all services"
dc up -d

echo "[site_migrate] Done. Current services:"
dc ps


