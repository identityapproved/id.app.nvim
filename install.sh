#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINK_SCRIPT="${SCRIPT_DIR}/scripts/link_nvim.sh"

if [[ ! -x "${LINK_SCRIPT}" ]]; then
  chmod +x "${LINK_SCRIPT}" 2>/dev/null || true
fi

if [[ ! -x "${LINK_SCRIPT}" ]]; then
  echo "Missing executable linker script: ${LINK_SCRIPT}" >&2
  exit 1
fi

echo "==> Linking this repo to ~/.config/nvim"
"${LINK_SCRIPT}" --repo "${SCRIPT_DIR}" "$@"

echo
echo "==> Dependency check"
MISSING=()
for cmd in nvim git rg fd; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    MISSING+=("${cmd}")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo "Missing commands: ${MISSING[*]}"
  echo "Install them with your package manager, then run:"
  echo "  nvim --headless \"+Lazy! sync\" +qa"
else
  echo "All required commands are available."
  echo "Recommended next step:"
  echo "  nvim --headless \"+Lazy! sync\" +qa"
fi

