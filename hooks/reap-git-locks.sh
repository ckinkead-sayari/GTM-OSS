#!/usr/bin/env bash
# reap-git-locks.sh — host-side launchd cleanup for orphan git lock files
#
# Scope: <repo>/.git/{index.lock,HEAD.lock,ORIG_HEAD.lock}, where <repo>
# is derived from this script's own location (<repo>/hooks/reap-git-locks.sh)
# — portable across forks/clone paths while keeping single-repo scope.
# No globs, no parameters, no recursion, no other paths. Lock-name scope
# grows only when a lock type is actually observed stranded (index S-020,
# HEAD S-027, ORIG_HEAD S-036 — stranded 3x: Apr 22, May 21, Jun 8).
#
# Ghost-aware holder check: Virtualization.framework (virtiofs) retains
# read-only fds on lock files after the sandbox git process exits. These
# are not real holders — the script ignores them and reaps anyway.
#
# Fail-closed: aborts without action if any guard fails — missing repo,
# mid-operation state, real holder, or fresh lock (<2s old). Parsing
# uncertainty in lsof output defaults to "real holder."
#
# Exit codes: always 0 (launchd parses nothing). Observability lives
# in memory/reap-log.jsonl.

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GITDIR="$REPO_ROOT/.git"
LOG="$REPO_ROOT/memory/reap-log.jsonl"

# has_real_holder FILE
# Returns 0 if any non-ghost process holds FILE (= back off).
# Returns 1 if no holders, or all holders are virtiofs read-only ghosts.
# Side-effect: sets HOLDERS_FOUND=1 if lsof saw any holders, else 0.
# Lets callers distinguish "ghost-only" from "no holders" without re-running lsof.
#
# NOTE: identical copy lives in hooks/git-safe.sh — keep in sync.
# Not factored into a shared lib because the launchd reaper is intentionally
# self-contained (single-file audit, no source-chain failure modes).
has_real_holder() {
  local file="$1"
  HOLDERS_FOUND=0
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
      p*) _eval_block; cmd=""; access=""; HOLDERS_FOUND=1 ;;
      c*) cmd="${line#c}" ;;
      a*) access="${access}${line#a}" ;;
    esac
  done <<< "$lsof_out"
  _eval_block

  [ "$found_real" -eq 1 ] && return 0
  return 1
}

[ -d "$GITDIR" ] || exit 0

# Mid-operation guard — leave everything alone during merge/rebase/etc.
for f in "$GITDIR/MERGE_HEAD" "$GITDIR/CHERRY_PICK_HEAD" "$GITDIR/BISECT_LOG" "$GITDIR/rebase-merge" "$GITDIR/rebase-apply"; do
  [ -e "$f" ] && exit 0
done

NOW=$(date +%s)

for LOCK in "$GITDIR/index.lock" "$GITDIR/HEAD.lock" "$GITDIR/ORIG_HEAD.lock"; do
  [ -e "$LOCK" ] || continue

  HOLDERS_FOUND=0
  if has_real_holder "$LOCK"; then
    continue
  fi
  ghost_only=$HOLDERS_FOUND

  LOCK_MTIME=$(stat -f %m "$LOCK" 2>/dev/null || echo 0)
  AGE=$((NOW - LOCK_MTIME))
  [ "$AGE" -lt 2 ] && continue

  LOCK_SIZE=$(stat -f %z "$LOCK" 2>/dev/null || echo 0)

  if rm -f "$LOCK" 2>/dev/null; then
    TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    if [ "$ghost_only" -eq 1 ]; then
      ACTION="reaped_ghost"
    else
      ACTION="reaped"
    fi
    printf '{"ts":"%s","action":"%s","lock":"%s","lock_size":%s,"lock_age_seconds":%s,"reaped_ok":true}\n' \
      "$TS" "$ACTION" "$(basename "$LOCK")" "$LOCK_SIZE" "$AGE" >> "$LOG"
  fi
done

exit 0
