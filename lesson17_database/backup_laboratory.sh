#!/bin/bash

set -euo pipefail

DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="laboratory"
DB_USER="admin"

BACKUP_DIR="/home/vadim/backups/laboratory"

REMOTE_USER="backuper"
REMOTE_HOST="192.168.1.181"
REMOTE_DIR="/home/backuper/laboratory"
SSH_KEY="${HOME}/.ssh/id_rsa"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/laboratory_${TIMESTAMP}.sql"
LOG_PREFIX="[$(date '+%Y-%m-%d %H:%M:%S')]"

log() {
    echo "${LOG_PREFIX} $*"
}

die() {
    log "ERROR: $*"
    exit 1
}

mkdir -p "${BACKUP_DIR}"

log "Starting backup of ${DB_NAME}..."

if ! command -v pg_dump >/dev/null 2>&1; then
    die "pg_dump not found. Install: sudo apt install postgresql-client"
fi

pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    -F p \
    -f "${BACKUP_FILE}"

log "Backup created: ${BACKUP_FILE} ($(du -h "${BACKUP_FILE}" | cut -f1))"

log "Sending to ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/ ..."

scp -i "${SSH_KEY}" -o BatchMode=yes -o ConnectTimeout=30 \
    "${BACKUP_FILE}" \
    "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/" \
    || die "scp failed. Check SSH key and remote directory."

log "Backup sent successfully."

log "Done."
