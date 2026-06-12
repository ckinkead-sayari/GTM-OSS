#!/usr/bin/env bash
# check-mcp.sh — Reports MCP connection health from memory/mcp-status.json.
# The probe itself is run by Claude at session start (see CLAUDE.md preamble)
# because bash cannot directly invoke Claude's MCP tools. This script reads
# the probe results and surfaces issues.
#
# Exit 0 = all MCPs OK or only known-intentional failures, exit 1 = real problems.
# Usage: bash hooks/check-mcp.sh [--max-age-hours N]  (default 24)
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATUS_FILE="$REPO_ROOT/memory/mcp-status.json"
MAX_AGE_HOURS=24

while [ $# -gt 0 ]; do
  case "$1" in
    --max-age-hours) MAX_AGE_HOURS="$2"; shift 2 ;;
    *) echo "unknown flag: $1" >&2; exit 2 ;;
  esac
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "MCP CHECK SKIPPED — python3 not found"
  exit 0
fi

if [ ! -f "$STATUS_FILE" ]; then
  echo "MCP CHECK FAILED — memory/mcp-status.json does not exist."
  echo ""
  echo "Claude should probe MCPs at session start and write this file."
  if [ -f "$REPO_ROOT/.claude/commands/bootstrap.md" ]; then
    echo "Fresh instance? /bootstrap (phase 5) maps and probes your MCPs and writes it."
  else
    echo "See .claude/CLAUDE.md → 'Session Preamble' step 0.5."
  fi
  exit 1
fi

# Fresh-install seed: the kit ships mcp-status.json with an explicit
# "unconfigured" marker. That's setup-pending, not failure — don't open a
# brand-new forker's first digest with FAILED.
if grep -q '"status"[[:space:]]*:[[:space:]]*"unconfigured"' "$STATUS_FILE"; then
  echo "MCP CHECK — setup pending (no probes recorded yet)."
  echo "Run /bootstrap (phase 5) or the session preamble to map and probe your MCP connectors."
  exit 0
fi

python3 - "$STATUS_FILE" "$MAX_AGE_HOURS" <<'PY'
import json, sys, datetime as dt

status_file, max_age_hours = sys.argv[1], int(sys.argv[2])

with open(status_file) as f:
    data = json.load(f)

last_probe = dt.datetime.fromisoformat(data["last_probe_ts"].replace("Z", "+00:00"))
now = dt.datetime.now(dt.timezone.utc)
age_hours = (now - last_probe).total_seconds() / 3600

broken, degraded, ok, unavailable = [], [], [], []
for name, info in data["mcps"].items():
    s = info["status"]
    if s == "OK":
        ok.append(name)
    elif s == "BROKEN":
        broken.append((name, info.get("error", "")))
    elif s == "DEGRADED":
        degraded.append((name, info.get("error", info.get("note", ""))))
    elif s == "UNAVAILABLE":
        unavailable.append((name, info.get("error", "")))

stale = age_hours > max_age_hours
exit_code = 0

if broken or stale:
    exit_code = 1

parts = []
if broken:
    parts.append(f"{len(broken)} broken")
if degraded:
    parts.append(f"{len(degraded)} degraded")
if unavailable:
    parts.append(f"{len(unavailable)} unavailable (expected)")
parts.append(f"{len(ok)} ok")
summary = ", ".join(parts)

if broken:
    print(f"MCP CHECK FAILED — {summary}")
    print("")
    print("Broken:")
    for name, err in broken:
        print(f"  - {name}: {err}")
    if degraded:
        print("")
        print("Degraded:")
        for name, err in degraded:
            print(f"  - {name}: {err}")
    print("")
    print("To fix: open Desktop app → /mcp → reconnect flagged servers. Then re-run probe.")
elif stale:
    print(f"MCP CHECK STALE — last probe {age_hours:.1f}h ago (threshold {max_age_hours}h). Re-probe needed.")
    print(f"  Last probe: {data['last_probe_ts']} (session {data.get('probe_session', 'unknown')})")
    print(f"  Statuses as of last probe: {summary} — do NOT trust these until re-probed.")
elif degraded:
    print(f"MCP CHECK OK with warnings — {summary}")
    print("")
    print("Degraded:")
    for name, err in degraded:
        print(f"  - {name}: {err}")
else:
    print(f"MCP CHECK PASSED — {summary} (probed {age_hours:.1f}h ago)")

sys.exit(exit_code)
PY
