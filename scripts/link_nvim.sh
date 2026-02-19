#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: link_nvim.sh [options]

Create or update a symlink from this repo to ~/.config/nvim.

Options:
  --repo DIR         Repo directory to link from (default: script parent dir)
  --target DIR       Target path (default: ~/.config/nvim)
  --force            Replace an existing symlink even if it points elsewhere
  --no-backup        Do not create backup when target is a real directory/file
  --dry-run          Print actions without changing anything
  -h, --help         Show this help
EOF
}

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${HOME}/.config/nvim"
FORCE=0
NO_BACKUP=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_DIR="$2"
      shift 2
      ;;
    --target)
      TARGET="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --no-backup)
      NO_BACKUP=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

run() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    printf '[dry-run] %q ' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

if [[ ! -d "${REPO_DIR}" ]]; then
  echo "Repo directory does not exist: ${REPO_DIR}" >&2
  exit 1
fi

if [[ ! -f "${REPO_DIR}/init.lua" ]]; then
  echo "Repo does not look like a Neovim config (missing init.lua): ${REPO_DIR}" >&2
  exit 1
fi

TARGET_PARENT="$(dirname "${TARGET}")"
run mkdir -p "${TARGET_PARENT}"

if [[ -L "${TARGET}" ]]; then
  CURRENT_REAL="$(readlink -f "${TARGET}" || true)"
  TARGET_REAL="$(readlink -f "${REPO_DIR}")"

  if [[ "${CURRENT_REAL}" == "${TARGET_REAL}" ]]; then
    echo "Already linked: ${TARGET} -> ${REPO_DIR}"
    exit 0
  fi

  if [[ "${FORCE}" -eq 1 ]]; then
    run rm -f "${TARGET}"
  else
    echo "Refusing to replace existing symlink at ${TARGET}." >&2
    echo "Use --force to replace it." >&2
    exit 1
  fi
elif [[ -e "${TARGET}" ]]; then
  if [[ "${NO_BACKUP}" -eq 1 ]]; then
    echo "Refusing to overwrite existing ${TARGET} without backup." >&2
    echo "Remove it manually or run without --no-backup." >&2
    exit 1
  fi
  TS="$(date +%Y%m%d-%H%M%S)"
  BACKUP="${TARGET}.bak-${TS}"
  run mv "${TARGET}" "${BACKUP}"
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "Would back up existing target to: ${BACKUP}"
  else
    echo "Backed up existing target to: ${BACKUP}"
  fi
fi

run ln -s "${REPO_DIR}" "${TARGET}"
if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "Would link: ${TARGET} -> ${REPO_DIR}"
else
  echo "Linked: ${TARGET} -> ${REPO_DIR}"
fi
echo "Next: open nvim and run :Lazy sync"
