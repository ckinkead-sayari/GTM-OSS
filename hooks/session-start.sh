#!/usr/bin/env bash
# session-start.sh — automated preamble digest, wired as a SessionStart hook
# in .claude/settings.json. Output lands in Claude's context at session start,
# so enforcement state is visible even when the manual preamble gets skipped
# (the S-033 failure mode). This is the detection layer; the full preamble
# (frameworks/preamble.md) is still the protocol.
# Keep it fast and read-only: no git pull, no writes. One exception to
# no-network: a 5s-bounded, fail-silent GitHub visibility probe (privacy
# guard) — a PUBLIC origin holding account dossiers publishes client data,
# which is the one mistake this system cannot undo.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT" || exit 0

now=$(date +%s)
age_days() { # whole days since file mtime, or "?" if missing
  local m
  m=$(stat -f %m "$1" 2>/dev/null) || { echo "?"; return; }
  echo $(( (now - m) / 86400 ))
}

echo "=== claudeGTM session-start digest — $(date '+%Y-%m-%d %H:%M %Z') ==="

bash hooks/check-config.sh 2>&1 | tail -1
bash hooks/check-mcp.sh 2>&1 | head -3

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "Git: branch ${branch}, ${dirty} uncommitted path(s)$( [ "${dirty:-0}" -gt 0 ] && echo ' — if these predate this session, a prior end-session commit was missed' )"

# Privacy guard: warn loudly if origin is PUBLIC while the repo holds working
# data (dossiers beyond the shipped example, or analytics). Bounded to 5s and
# fail-silent — offline/no-gh sessions skip it without noise.
origin_url=$(git remote get-url origin 2>/dev/null || true)
if [ -n "$origin_url" ] && command -v gh >/dev/null 2>&1 && command -v python3 >/dev/null 2>&1; then
  slug=$(printf '%s' "$origin_url" | sed -E 's#^(git@github\.com:|https://github\.com/)##; s#\.git$##')
  case "$slug" in
    */*)
      vis=$(python3 - "$slug" <<'PY' 2>/dev/null
import subprocess, sys
try:
    r = subprocess.run(["gh", "api", f"repos/{sys.argv[1]}", "--jq", ".visibility"],
                       capture_output=True, timeout=5, text=True)
    print(r.stdout.strip())
except Exception:
    pass
PY
)
      if [ "$vis" = "public" ]; then
        has_data=0
        for f in accounts/*.md; do
          [ -e "$f" ] || continue
          case "$f" in */README.md|*/EXAMPLE-*) continue ;; esac
          has_data=1; break
        done
        [ -s memory/analytics.jsonl ] && has_data=1
        if [ "$has_data" -eq 1 ]; then
          echo "🔴 PRIVACY: origin (${slug}) is PUBLIC and this repo contains working data (dossiers/analytics)."
          echo "   Client data is being published. Fix NOW: gh repo edit ${slug} --visibility private"
        fi
      fi
      ;;
  esac
fi

# Fresh fork that hasn't been set up yet → point at the guided path once.
if [ ! -f knowledge/domain-summary.md ] && [ -f .claude/commands/bootstrap.md ]; then
  echo "SETUP: knowledge files not built yet — run /bootstrap (guided ~30-45 min: interview + research, Claude writes them)."
fi

ac_age=$(age_days memory/active-context.md)
ho_age=$(age_days memory/handoff.jsonl)
if [ "$ac_age" != "?" ] && [ "$ac_age" -ge 7 ]; then
  echo "STALE: memory/active-context.md last touched ${ac_age}d ago — reconcile before relying on priorities/pipeline in it."
fi
if [ "$ho_age" != "?" ] && [ "$ho_age" -ge 5 ]; then
  echo "STALE: memory/handoff.jsonl last write ${ho_age}d ago. Enabled scheduled tasks should write >=2x/week."
  echo "       If the Desktop app shows recent lastRunAt anyway, tasks are firing but failing silently (known failure mode — see Active Flags in memory/active-context.md)."
fi

# Account-file freshness — the accretive knowledge model breaks silently
# when debriefs/research stop being appended (12/15 files went stale Apr-Jun 2026).
stale_accounts=0; total_accounts=0
for f in accounts/*.md; do
  [ -e "$f" ] || continue
  case "$f" in */README.md) continue ;; esac
  total_accounts=$((total_accounts + 1))
  a=$(age_days "$f")
  [ "$a" != "?" ] && [ "$a" -ge 30 ] && stale_accounts=$((stale_accounts + 1))
done
if [ "$stale_accounts" -gt 0 ]; then
  echo "STALE: ${stale_accounts}/${total_accounts} account files >30d untouched — debriefs/research must append to accounts/<name>.md (template: frameworks/account-dossier.md)."
fi

p0=$(grep -c 'Priority:\*\* P0' TODOS.md 2>/dev/null)
oldest=$(grep -oE '\(added [^)]*20[0-9]{2}-[0-9]{2}-[0-9]{2}\)' TODOS.md 2>/dev/null \
  | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | sort | head -1)
p0_line="TODOS.md: ${p0:-0} P0 item(s)."
if [ -n "${oldest:-}" ]; then
  oldest_epoch=$(date -j -f '%Y-%m-%d' "$oldest" +%s 2>/dev/null || true)
  if [ -n "${oldest_epoch:-}" ]; then
    p0_line="$p0_line Oldest dated backlog section: $oldest ($(( (now - oldest_epoch) / 86400 ))d old)."
  fi
fi
echo "$p0_line"
echo "Next: run the full preamble (frameworks/preamble.md) — git pull, read active-context + TODOS + last 20 handoff lines, re-probe MCPs if stale, mint session ID via: bash hooks/next-session-id.sh"
exit 0
