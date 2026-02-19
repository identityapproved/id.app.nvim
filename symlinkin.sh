#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="${SCRIPT_DIR}/install.sh"

if [[ ! -x "${INSTALL_SCRIPT}" ]]; then
  chmod +x "${INSTALL_SCRIPT}" 2>/dev/null || true
fi

exec "${INSTALL_SCRIPT}" --link-only "$@"
