#!/usr/bin/env bash
set -euo pipefail

# One-shot bootstrap for Ubuntu 24 VPS using official OpenClaw repo.
# Idempotent: safe to run multiple times.

OPENCLAW_REPO_URL="${OPENCLAW_REPO_URL:-https://github.com/openclaw/openclaw.git}"
OPENCLAW_REPO_REF="${OPENCLAW_REPO_REF:-main}"
OPENCLAW_INSTALL_DIR="${OPENCLAW_INSTALL_DIR:-/opt/openclaw}"
OPENCLAW_CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-/var/lib/openclaw/config}"
OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/var/lib/openclaw/workspace}"
OPENCLAW_IMAGE="${OPENCLAW_IMAGE:-ghcr.io/openclaw/openclaw:main}"
OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
OPENCLAW_BRIDGE_PORT="${OPENCLAW_BRIDGE_PORT:-18790}"
OPENCLAW_GATEWAY_BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
OPENCLAW_MEM_LIMIT="${OPENCLAW_MEM_LIMIT:-5g}"
OPENCLAW_MEMSWAP_LIMIT="${OPENCLAW_MEMSWAP_LIMIT:-5g}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root (or with sudo)."
  exit 1
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1"
    exit 1
  fi
}

generate_token() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  else
    python3 - <<'PY'
import secrets
print(secrets.token_hex(32))
PY
  fi
}

install_docker_if_missing() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    return
  fi

  apt-get update
  apt-get install -y ca-certificates curl git gnupg
  curl -fsSL https://get.docker.com | sh
  systemctl enable --now docker
}

sync_openclaw_repo() {
  mkdir -p "$(dirname "${OPENCLAW_INSTALL_DIR}")"
  if [[ -d "${OPENCLAW_INSTALL_DIR}/.git" ]]; then
    git -C "${OPENCLAW_INSTALL_DIR}" fetch --tags origin
    git -C "${OPENCLAW_INSTALL_DIR}" checkout "${OPENCLAW_REPO_REF}"
    git -C "${OPENCLAW_INSTALL_DIR}" pull --ff-only origin "${OPENCLAW_REPO_REF}"
  else
    rm -rf "${OPENCLAW_INSTALL_DIR}"
    git clone --branch "${OPENCLAW_REPO_REF}" --depth 1 "${OPENCLAW_REPO_URL}" "${OPENCLAW_INSTALL_DIR}"
  fi
}

prepare_storage() {
  mkdir -p "${OPENCLAW_CONFIG_DIR}" "${OPENCLAW_WORKSPACE_DIR}"
  chown -R 1000:1000 "${OPENCLAW_CONFIG_DIR}" "${OPENCLAW_WORKSPACE_DIR}"
  chmod -R u+rwX "${OPENCLAW_CONFIG_DIR}" "${OPENCLAW_WORKSPACE_DIR}"
}

load_or_generate_token() {
  local env_file="${OPENCLAW_INSTALL_DIR}/.env"
  local current_token=""
  if [[ -f "${env_file}" ]]; then
    current_token="$(grep -E '^OPENCLAW_GATEWAY_TOKEN=' "${env_file}" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi

  if [[ -n "${OPENCLAW_GATEWAY_TOKEN:-}" ]]; then
    echo "${OPENCLAW_GATEWAY_TOKEN}"
  elif [[ -n "${current_token}" ]]; then
    echo "${current_token}"
  else
    generate_token
  fi
}

write_env_file() {
  local token="$1"
  cat > "${OPENCLAW_INSTALL_DIR}/.env" <<EOF
OPENCLAW_CONFIG_DIR=${OPENCLAW_CONFIG_DIR}
OPENCLAW_WORKSPACE_DIR=${OPENCLAW_WORKSPACE_DIR}
OPENCLAW_GATEWAY_PORT=${OPENCLAW_GATEWAY_PORT}
OPENCLAW_BRIDGE_PORT=${OPENCLAW_BRIDGE_PORT}
OPENCLAW_GATEWAY_BIND=${OPENCLAW_GATEWAY_BIND}
OPENCLAW_GATEWAY_TOKEN=${token}
OPENCLAW_IMAGE=${OPENCLAW_IMAGE}
EOF
}

write_compose_override() {
  cat > "${OPENCLAW_INSTALL_DIR}/docker-compose.override.yml" <<EOF
services:
  openclaw-gateway:
    command:
      - node
      - dist/index.js
      - gateway
      - --allow-unconfigured
      - --bind
      - \${OPENCLAW_GATEWAY_BIND:-lan}
      - --port
      - "18789"
    mem_limit: ${OPENCLAW_MEM_LIMIT}
    memswap_limit: ${OPENCLAW_MEMSWAP_LIMIT}
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"
EOF
}

deploy_openclaw() {
  cd "${OPENCLAW_INSTALL_DIR}"
  docker compose up -d openclaw-gateway
}

print_summary() {
  cd "${OPENCLAW_INSTALL_DIR}"
  echo
  echo "OpenClaw deployed."
  echo "Install dir: ${OPENCLAW_INSTALL_DIR}"
  echo "Config dir:  ${OPENCLAW_CONFIG_DIR}"
  echo "Workspace:   ${OPENCLAW_WORKSPACE_DIR}"
  echo "Gateway URL: http://<VPS-IP>:${OPENCLAW_GATEWAY_PORT}/"
  echo
  echo "Health check:"
  echo "docker compose -C ${OPENCLAW_INSTALL_DIR} ps"
  echo
  echo "Dashboard link:"
  echo "docker compose -C ${OPENCLAW_INSTALL_DIR} run --rm openclaw-cli dashboard --no-open"
}

main() {
  install_docker_if_missing
  require_cmd docker
  require_cmd git
  sync_openclaw_repo
  prepare_storage
  token="$(load_or_generate_token)"
  write_env_file "${token}"
  write_compose_override
  deploy_openclaw
  print_summary
}

main "$@"
