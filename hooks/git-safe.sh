#!/usr/bin/env bash
# Usage: hooks/git-safe.sh <git-args>
#
# Serializes git operations across concurrent scheduled tasks + interactive
# sessions. Uses flock when available, falls back to atomic mkdir for
# portability (macOS ships without flock). Lock lives in /tmp so it works
# on both the Mac host and inside the Cowork virtiofs sandbox.
#
# Also defensively clears orphan .git/{index,HEAD,ORIG_HEAD}.lock files
# before handing off to git — the core fix for recurring lock leaks from
# killed scheduled-task subprocesses and virtiofs-stuck Cowork sessions.
#
# Ghost-aware orphan detection: uses lsof -F pca to check holders.
# Virtualization.framework (virtiofs) retains read-only fds on lock
# files after the sandbox git process exits — these ghost holders are
# ignored. Real holders (git processes, write-mode fds) cause the script
# to back off. When lsof is unavailable, falls back to a 5-minute age
# guard.
#
# Virtiofs EPERM handling: inside the Cowork sandbox, unlinking a
# host-owned lock returns Operation not permitted. When rm fails but
# the file still exists, emit an actionable error naming the exact
# host-side command to run (we can't auto-escape the sandbox).
#
# Why: Claude Code scheduled tasks and Cowork sessions both operate on
# ~/claudeGTM and race on .git/index. When a task crashes (Mac sleep,
# SIGKILL) it leaves .git/index.lock behind, blocking every subsequent
# git op. Tier 2 (stale-lock cleanup) + Tier 3A (serialization) from
# claude-code-git-lock-brief.md.
#
# Exit codes:
#   0   - git op succeeded
#   1   - a git lock file is held by a live process — do not clobber
#   2   - lock acquisition timeout (another git op held the /tmp lock)
#   3   - orphan lock detected but rm failed (virtiofs EPERM);
#         host-side cleanup required
#   *   - git's own exit code

set -euo pipefail

# Resolve repo root from the script's own location: <repo>/hooks/git-safe.sh
# -> <repo>. This works regardless of $HOME, which differs between the Mac
# host ($HOME=/Users/YOUR-USERNAME, repo at ~/claudeGTM) and the Cowork
# sandbox ($HOME=/sessions/<name>, repo at /sessions/<name>/mnt/claudeGTM).
# GIT_SAFE_REPO still overrides for anyone who needs an explicit target.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_ROOT="${GIT_SAFE_REPO:-$(cd "$SCRIPT_DIR/.." && pwd)}"
LOCK_DIR="/tmp/claudeGTM-git.lockd"
LOCK_FILE="/tmp/claudeGTM-git.lock"
INDEX_LOCK="$REPO_ROOT/.git/index.lock"
HEAD_LOCK="$REPO_ROOT/.git/HEAD.lock"
ORIG_HEAD_LOCK="$REPO_ROOT/.git/ORIG_HEAD.lock"
STALE_MIN=5
ACQUIRE_TIMEOUT=30

# has_real_holder FILE
# Returns 0 if any non-ghost process holds FILE (= back off).
# Returns 1 if no holders, or all holders are virtiofs read-only ghosts.
#
# NOTE: identical copy lives in hooks/reap-git-locks.sh — keep in sync.
# Not factored into a shared lib because the launchd reaper at the other
# call site is intentionally self-contained.
has_real_holder() {
  local file="$1"
  command -v lsof >/dev/null 2>&1 || return 1

  local lsof_out
  lsof_out=$(lsof -F pca -- "$file" 2>/dev/null) || return 1
  [ -n "$lsof_out" ] || return 1

  local cmd="" access="" found_real=0

  _eval_block() {
    [ -n "$cmd" ] || return
    case "$cmd" in
      com.apple.Virtualization*)
        case "$access" in
          *w*|*u*) found_real=1 ;;
        esac
        ;;
      *) found_real=1 ;;
    esac
  }

  while IFS= read -r line; do
    case "$line" in
      p*) _eval_block; cmd=""; access="" ;;
      c*) cmd="${line#c}" ;;
      a*) access="${access}${line#a}" ;;
    esac
  done <<< "$lsof_out"
  _eval_block

  [ "$found_real" -eq 1 ] && return 0
  return 1
}

# try_clear_lock LOCKFILE
# Detect and remove an orphan git lock. Returns 0 on success (cleared or
# absent), 1 if held by a live process, 3 if rm failed (virtiofs EPERM).
try_clear_lock() {
  local lock="$1"
  [ -f "$lock" ] || return 0
  local label="${lock#$REPO_ROOT/}"

  local is_held=0
  if command -v lsof >/dev/null 2>&1; then
    has_real_holder "$lock" && is_held=1
  else
    find "$lock" -mmin +$STALE_MIN -print -quit 2>/dev/null | grep -q . || is_held=1
  fi

  if [ $is_held -eq 1 ]; then
    echo "[git-safe] $label is held by a live process. Aborting." >&2
    return 1
  fi

  echo "[git-safe] Removing orphan $label" >&2
  rm -f "$lock" 2>/dev/null || true
  if [ -f "$lock" ]; then
    cat >&2 <<EOF
[git-safe] Cannot remove orphan $label (likely virtiofs EPERM
inside Cowork sandbox — host created the lock, guest can't unlink).
Run this on the Mac host to clear it:

    rm -f $lock

Then retry the git op.
EOF
    return 3
  fi
  return 0
}

cleanup_on_exit() {
  # Only remove the lock dir if we created it (mkdir path). The flock
  # path releases automatically when fd 200 closes on shell exit.
  if [ "${GIT_SAFE_OWNS_LOCKDIR:-0}" = "1" ]; then
    rmdir "$LOCK_DIR" 2>/dev/null || true
  fi
}
trap cleanup_on_exit EXIT INT TERM

try_clear_lock "$INDEX_LOCK" || exit $?
try_clear_lock "$HEAD_LOCK" || exit $?
try_clear_lock "$ORIG_HEAD_LOCK" || exit $?

rm -f "$REPO_ROOT/.git/index.lock.bak" "$REPO_ROOT/.git/index.tmp" "$REPO_ROOT/.git/HEAD.lock.bak" "$REPO_ROOT/.git/ORIG_HEAD.lock.bak" 2>/dev/null || true

if command -v flock >/dev/null 2>&1; then
  exec 200>"$LOCK_FILE"
  if ! flock -w $ACQUIRE_TIMEOUT 200; then
    echo "[git-safe] flock timeout after ${ACQUIRE_TIMEOUT}s" >&2
    exit 2
  fi
else
  # mkdir is atomic on all Unix filesystems — safe cross-process primitive.
  elapsed=0
  while ! mkdir "$LOCK_DIR" 2>/dev/null; do
    if [ $elapsed -ge $ACQUIRE_TIMEOUT ]; then
      echo "[git-safe] mkdir-lock timeout after ${ACQUIRE_TIMEOUT}s" >&2
      exit 2
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done
  export GIT_SAFE_OWNS_LOCKDIR=1
fi

cd "$REPO_ROOT"
git "$@"
