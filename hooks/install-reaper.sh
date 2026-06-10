#!/usr/bin/env bash
# install-reaper.sh — install/uninstall the claudegtm-git-reaper LaunchAgent.
#
# Usage:
#   bash hooks/install-reaper.sh              # install + start
#   bash hooks/install-reaper.sh --uninstall  # stop + remove
#
# Idempotent: tearing down an existing version before installing fresh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

LABEL="com.claudegtm.git-reaper"
SRC_PLIST="${SCRIPT_DIR}/${LABEL}.plist"
REAPER_SCRIPT="${SCRIPT_DIR}/reap-git-locks.sh"
DEST_PLIST="${HOME}/Library/LaunchAgents/${LABEL}.plist"
DOMAIN="gui/$(id -u)"
TARGET="${DOMAIN}/${LABEL}"

uninstall() {
  echo "[install-reaper] Stopping ${LABEL}..."
  launchctl bootout "${TARGET}" 2>/dev/null || true
  if [ -f "${DEST_PLIST}" ]; then
    rm -f "${DEST_PLIST}"
    echo "[install-reaper] Removed ${DEST_PLIST}"
  fi
  echo "[install-reaper] Uninstalled."
  exit 0
}

if [ "${1:-}" = "--uninstall" ]; then
  uninstall
fi

if [ ! -f "${SRC_PLIST}" ]; then
  echo "[install-reaper] ERROR: ${SRC_PLIST} not found." >&2
  exit 1
fi

if [ ! -x "${REAPER_SCRIPT}" ]; then
  echo "[install-reaper] ERROR: reap-git-locks.sh is not executable. Run:" >&2
  echo "  chmod +x ${REAPER_SCRIPT}" >&2
  exit 1
fi

mkdir -p "${HOME}/Library/LaunchAgents"

# Tear down any prior version first.
echo "[install-reaper] Tearing down prior version (if any)..."
launchctl bootout "${TARGET}" 2>/dev/null || true

# Render the plist rather than copying it: substitute this repo's actual
# location into ProgramArguments/StandardOutPath so the agent works for any
# user at any clone path (the shipped plist's paths are just template values).
echo "[install-reaper] Rendering plist (paths -> ${REPO_ROOT}) -> ${DEST_PLIST}"
sed -E \
  -e "s|<string>[^<]*/hooks/reap-git-locks\.sh</string>|<string>${REPO_ROOT}/hooks/reap-git-locks.sh</string>|" \
  -e "s|<string>[^<]*/memory/reap-stderr\.log</string>|<string>${REPO_ROOT}/memory/reap-stderr.log</string>|" \
  "${SRC_PLIST}" > "${DEST_PLIST}"

echo "[install-reaper] Bootstrapping LaunchAgent..."
launchctl bootstrap "${DOMAIN}" "${DEST_PLIST}"

echo "[install-reaper] Kickstarting first run..."
launchctl kickstart "${TARGET}"

echo ""
echo "[install-reaper] Installed and running."
echo ""
echo "Status:    launchctl print ${TARGET} | head -20"
echo "Audit log: tail -f ${REPO_ROOT}/memory/reap-log.jsonl"
echo "Stderr:    tail -f ${REPO_ROOT}/memory/reap-stderr.log"
echo "Uninstall: bash $(basename "$0") --uninstall"
