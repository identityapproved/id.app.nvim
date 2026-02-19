#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINK_SCRIPT="${SCRIPT_DIR}/scripts/link_nvim.sh"

if [[ ! -x "${LINK_SCRIPT}" ]]; then
  chmod +x "${LINK_SCRIPT}" 2>/dev/null || true
fi

exec "${LINK_SCRIPT}" --repo "${SCRIPT_DIR}" "$@"

