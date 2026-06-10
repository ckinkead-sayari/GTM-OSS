#!/usr/bin/env bash
# next-session-id.sh — mint the next interactive session ID (S-NNN).
#
# Uses max(existing)+1 across analytics.jsonl AND handoff.jsonl — NOT
# count(session_start)+1. Counting collides as soon as one session is
# logged twice or a start event is lost (S-028 was minted for two
# different sessions this way; by 2026-06 count said 34 while max was 35).
# Usage: bash hooks/next-session-id.sh   → prints e.g. "S-036"
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

max=$(cat "$REPO_ROOT/memory/analytics.jsonl" "$REPO_ROOT/memory/handoff.jsonl" 2>/dev/null \
  | grep -oE '"session_id" *: *"S-[0-9]+' \
  | grep -oE '[0-9]+$' \
  | sort -n | tail -1)

# 10# forces base-10: "035" would otherwise be read as octal (29)
printf 'S-%03d\n' "$(( 10#${max:-0} + 1 ))"
