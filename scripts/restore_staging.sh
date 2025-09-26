#!/usr/bin/env bash
set -euo pipefail

# Restore a site from production backups into staging using the easy-install compose outputs.
# Allows skipping public files (branding) and reapplying simple staging overrides.
#
# Usage example:
#   PROJECT=adnoor-staging SITE=staging.adnoorerp.com \
#   DB_SQL=/home/$USER/backups/latest_production_database.sql.gz \
#   PUBLIC_FILES=/home/$USER/backups/production_files.tar.gz \
#   PRIVATE_FILES=/home/$USER/backups/production_private_files.tar.gz \
#   SKIP_PUBLIC=1 ./scripts/restore_staging.sh
#
# Notes:
# - Requires the site to exist. Use scripts/site_migrate.sh first.
# - If SKIP_PUBLIC=1, public files (e.g., logos/headers) are not restored.

PROJECT=${PROJECT:-adnoor-staging}
SITE=${SITE:-staging.adnoorerp.com}
COMPOSE_FILE=${COMPOSE_FILE:-"$HOME/${PROJECT}-compose.yml"}
DB_SQL=${DB_SQL:-}
PUBLIC_FILES=${PUBLIC_FILES:-}
PRIVATE_FILES=${PRIVATE_FILES:-}
SKIP_PUBLIC=${SKIP_PUBLIC:-0}

need_sudo=""
if ! groups "$USER" | grep -q "\bdocker\b"; then
  need_sudo="sudo"
fi

die() { echo "[restore_staging] ERROR: $*" >&2; exit 1; }
dc() { $need_sudo docker compose -p "$PROJECT" -f "$COMPOSE_FILE" "$@"; }

[ -f "$COMPOSE_FILE" ] || die "Compose file not found: $COMPOSE_FILE"
[ -n "$DB_SQL" ] || die "DB_SQL path is required"

echo "[restore_staging] Ensuring backend is up"
dc up -d backend

echo "[restore_staging] Copying backup(s) into container"
dc cp "$DB_SQL" backend:/workspace/restore.sql.gz
[ "$SKIP_PUBLIC" = "1" ] || { [ -n "${PUBLIC_FILES:-}" ] && dc cp "$PUBLIC_FILES" backend:/workspace/public.tar.gz || true; }
[ -n "${PRIVATE_FILES:-}" ] && dc cp "$PRIVATE_FILES" backend:/workspace/private.tar.gz || true

echo "[restore_staging] Restoring database/files"
RESTORE_FLAGS=("--mariadb-root-password=$(grep -E '^MARIADB_ROOT_PASSWORD=' "$HOME/${PROJECT}-passwords.txt" | cut -d= -f2)")
[ "$SKIP_PUBLIC" = "1" ] || { [ -n "${PUBLIC_FILES:-}" ] && RESTORE_FLAGS+=("--with-public-files" "/workspace/public.tar.gz"); }
[ -n "${PRIVATE_FILES:-}" ] && RESTORE_FLAGS+=("--with-private-files" "/workspace/private.tar.gz")

dc exec -T backend bash -lc "bench --site ${SITE} restore /workspace/restore.sql.gz ${RESTORE_FLAGS[*]}"

echo "[restore_staging] Post-restore migrate + cache clear"
dc exec -T backend bash -lc "bench --site ${SITE} migrate && bench clear-cache"

echo "[restore_staging] Done"


