#!/usr/bin/env bash
set -euo pipefail

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_BLUE=$'\033[34m'
  C_CYAN=$'\033[36m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
else
  C_RESET=''
  C_BOLD=''
  C_DIM=''
  C_BLUE=''
  C_CYAN=''
  C_GREEN=''
  C_YELLOW=''
  C_RED=''
fi

section() { printf "\n%s%s[%s]%s %s\n" "${C_BOLD}" "${C_BLUE}" "$1" "${C_RESET}" "$2"; }
ok() { printf "%s  ✓%s %s\n" "${C_GREEN}" "${C_RESET}" "$1"; }
info() { printf "%s  •%s %s\n" "${C_CYAN}" "${C_RESET}" "$1"; }
warn() { printf "%s  !%s %s\n" "${C_YELLOW}" "${C_RESET}" "$1"; }
err() { printf "%s  x%s %s\n" "${C_RED}" "${C_RESET}" "$1" >&2; }

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Link this repo to ~/.config/nvim and optionally run dependency checks.

Options:
  --repo DIR         Repo directory to link from (default: current script dir)
  --target DIR       Target path (default: ~/.config/nvim)
  --force            Replace an existing symlink even if it points elsewhere
  --no-backup        Do not create backup when target is a real directory/file
  --dry-run          Print actions without changing anything
  -h, --help         Show this help
EOF
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${SCRIPT_DIR}"
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
      err "Unknown argument: $1"
      usage >&2
      exit 2
      ;;
  esac
done

run() {
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    printf "%s[dry-run]%s " "${C_DIM}" "${C_RESET}"
    printf '%q ' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

if [[ ! -d "${REPO_DIR}" ]]; then
  err "Repo directory does not exist: ${REPO_DIR}"
  exit 1
fi

if [[ ! -f "${REPO_DIR}/init.lua" ]]; then
  err "Repo does not look like a Neovim config (missing init.lua): ${REPO_DIR}"
  exit 1
fi

printf "%s%sNeovim Config Installer%s\n" "${C_BOLD}" "${C_CYAN}" "${C_RESET}"
info "Repo: ${REPO_DIR}"
info "Target: ${TARGET}"
if [[ "${DRY_RUN}" -eq 1 ]]; then
  warn "Dry-run enabled (no files will be changed)"
fi

section "LINK" "Linking config directory"
TARGET_PARENT="$(dirname "${TARGET}")"
run mkdir -p "${TARGET_PARENT}"

if [[ -L "${TARGET}" ]]; then
  CURRENT_REAL="$(readlink -f "${TARGET}" || true)"
  TARGET_REAL="$(readlink -f "${REPO_DIR}")"

  if [[ "${CURRENT_REAL}" == "${TARGET_REAL}" ]]; then
    ok "Already linked: ${TARGET} -> ${REPO_DIR}"
  else
    if [[ "${FORCE}" -eq 1 ]]; then
      run rm -f "${TARGET}"
      run ln -s "${REPO_DIR}" "${TARGET}"
      if [[ "${DRY_RUN}" -eq 1 ]]; then
        info "Would relink: ${TARGET} -> ${REPO_DIR}"
      else
        ok "Relinked: ${TARGET} -> ${REPO_DIR}"
      fi
    else
      err "Refusing to replace existing symlink at ${TARGET}."
      warn "Use --force to replace it."
      exit 1
    fi
  fi
elif [[ -e "${TARGET}" ]]; then
  if [[ "${NO_BACKUP}" -eq 1 ]]; then
    err "Refusing to overwrite existing ${TARGET} without backup."
    warn "Remove it manually or run without --no-backup."
    exit 1
  fi
  TS="$(date +%Y%m%d-%H%M%S)"
  BACKUP="${TARGET}.bak-${TS}"
  run mv "${TARGET}" "${BACKUP}"
  run ln -s "${REPO_DIR}" "${TARGET}"
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    info "Would back up existing target to: ${BACKUP}"
    info "Would link: ${TARGET} -> ${REPO_DIR}"
  else
    ok "Backed up existing target to: ${BACKUP}"
    ok "Linked: ${TARGET} -> ${REPO_DIR}"
  fi
else
  run ln -s "${REPO_DIR}" "${TARGET}"
  if [[ "${DRY_RUN}" -eq 1 ]]; then
    info "Would link: ${TARGET} -> ${REPO_DIR}"
  else
    ok "Linked: ${TARGET} -> ${REPO_DIR}"
  fi
fi

section "CHECK" "Dependency check"

MISSING=()
for cmd in nvim git rg fd; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    MISSING+=("${cmd}")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  warn "Missing commands: ${MISSING[*]}"
  info "Install them with your package manager, then run:"
  printf "  %snvim --headless \"+Lazy! sync\" +qa%s\n" "${C_BOLD}" "${C_RESET}"
else
  ok "All required commands are available."
  info "Recommended next step:"
  printf "  %snvim --headless \"+Lazy! sync\" +qa%s\n" "${C_BOLD}" "${C_RESET}"
fi
