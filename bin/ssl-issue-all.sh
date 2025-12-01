#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOMAINS_FILE="${ROOT_DIR}/config/domains.txt"
ACME_BIN="${ACME_BIN:-$HOME/.acme.sh/acme.sh}"

# Load env
if [ -f "${ROOT_DIR}/.env" ]; then
  source "${ROOT_DIR}/.env"
fi

if [ ! -x "$ACME_BIN" ]; then
  echo "[ERROR] acme.sh not found at $ACME_BIN"
  exit 1
fi

if [ ! -f "$DOMAINS_FILE" ]; then
  echo "[ERROR] Domains file not found: $DOMAINS_FILE"
  exit 1
fi

while read -r DOMAIN; do
  [[ -z "$DOMAIN" || "$DOMAIN" =~ ^# ]] && continue

  echo "=== Issuing ECC wildcard cert for ${DOMAIN} ==="
  "$ACME_BIN" --issue \
    --dns dns_cf \
    -d "${DOMAIN}" \
    -d "*.${DOMAIN}" \
    --ecc

  echo
done < "$DOMAINS_FILE"
