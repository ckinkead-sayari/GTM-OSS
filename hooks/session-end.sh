#!/usr/bin/env bash
# session-end.sh — SessionEnd hook (wired in .claude/settings.json).
# When a session terminates with uncommitted work, append a marker to
# memory/handoff.jsonl so the next session's start digest reports exactly
# what was dropped — instead of stranded state being discovered weeks later
# (the S-034/S-035 failure mode). SessionEnd output is not seen by the model
# and cannot block termination: this is detection, not enforcement.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 0

# Exclude handoff.jsonl itself: a marker written by a previous session-end
# must not count as "dirty work" or every clean session would re-log it.
dirty=$(git status --porcelain 2>/dev/null | grep -cv 'memory/handoff\.jsonl')
[ "${dirty:-0}" -eq 0 ] && exit 0

last_sid=$(grep -oE '"session_id" *: *"S-[0-9]+"' memory/analytics.jsonl 2>/dev/null \
  | tail -1 | grep -oE 'S-[0-9]+')
if [ -n "${last_sid:-}" ] && grep -q "\"session_end\".*\"${last_sid}\"" memory/analytics.jsonl 2>/dev/null; then
  end_state="session_end was logged"
else
  end_state="NO session_end logged"
fi

ts=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
files=$(git status --porcelain 2>/dev/null | grep -v 'memory/handoff\.jsonl' \
  | awk '{print $NF}' | head -8 | tr '\n' ' ' | tr -d '"')
printf '{"source":"session-end-hook","ts":"%s","action":"unclean_session_end","details":"Session terminated with %s uncommitted path(s); latest interactive session %s (%s). Files: %s. Next session: review these, then commit or discard — do not let them strand."}\n' \
  "$ts" "$dirty" "${last_sid:-unknown}" "$end_state" "$files" >> memory/handoff.jsonl
exit 0
