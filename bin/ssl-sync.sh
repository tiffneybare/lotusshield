#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOMAINS_FILE="${ROOT_DIR}/config/domains.txt"
ACME_BIN="${ACME_BIN:-$HOME/.acme.sh/acme.sh}"

# Load env
if [ -f "${ROOT_DIR}/.env" ]; then
  source "${ROOT_DIR}/.env"
fi

if [ -z "${CPANEL_SERVER:-}" ] || [ -z "${CPANEL_USER:-}" ] || [ -z "${CPANEL_TOKEN:-}" ]; then
  echo "[ERROR] cPanel credentials missing from .env"
  exit 1
fi

if [ ! -x "$ACME_BIN" ]; then
  echo "[ERROR] acme.sh not found: $ACME_BIN"
  exit 1
fi

if [ ! -f "$DOMAINS_FILE" ]; then
  echo "[ERROR] Domains file missing: $DOMAINS_FILE"
  exit 1
fi

renew_and_install() {
  local DOMAIN="$1"

  echo "=== Processing ${DOMAIN} ==="

  # Attempt renewal
  if ! "$ACME_BIN" --renew -d "${DOMAIN}" --days 2 --ecc --dns dns_cf >/dev/null 2>&1; then
    echo "  [INFO] Not due for renewal. Continuing..."
  else
    echo "  [INFO] Certificate renewed."
  fi

  local CERT_DIR="$HOME/.acme.sh/${DOMAIN}_ecc"

  if [ ! -d "$CERT_DIR" ]; then
    echo "  [ERROR] ECC directory not found for ${DOMAIN}. Skipping."
    return
  fi

  local CERT_PATH="${CERT_DIR}/${DOMAIN}.cer"
  local KEY_PATH="${CERT_DIR}/${DOMAIN}.key"
  local CABUNDLE_PATH="${CERT_DIR}/ca.cer"

  if [[ ! -f "$CERT_PATH" || ! -f "$KEY_PATH" || ! -f "$CABUNDLE_PATH" ]]; then
    echo "  [ERROR] Missing cert/key/ca in ${CERT_DIR}"
    return
  fi

  echo "  [INFO] Installing cert in cPanel..."

  local RESPONSE
  RESPONSE=$(curl -s "${CPANEL_SERVER}/execute/SSL/install_ssl" \
    -H "Authorization: cpanel ${CPANEL_USER}:${CPANEL_TOKEN}" \
    --data-urlencode "domain=${DOMAIN}" \
    --data-urlencode "cert@${CERT_PATH}" \
    --data-urlencode "key@${KEY_PATH}" \
    --data-urlencode "cabundle@${CABUNDLE_PATH}")

  echo "  [CPANEL] ${RESPONSE}"
  echo
}

while read -r DOMAIN; do
  [[ -z "$DOMAIN" || "$DOMAIN" =~ ^# ]] && continue
  renew_and_install "$DOMAIN"
done < "$DOMAINS_FILE"
