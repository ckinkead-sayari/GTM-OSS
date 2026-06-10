#!/usr/bin/env bash
# check-outbound-quality.sh — PreToolUse hook gating outbound email drafts.
# Wired in .claude/settings.json with a matcher on *create_draft* tool names.
# Reads the hook payload JSON from stdin, extracts draft-like text fields
# from tool_input, and runs them through hooks/check-quality.sh.
# Exit 2 = block the tool call and feed violations back to Claude.
# Exit 0 = allow. Any extraction failure fails open (allow) — the gate must
# never break unrelated tools.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

payload=$(cat 2>/dev/null) || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

text=$(printf '%s' "$payload" | python3 -c '
import json, sys
KEYS = {"body", "content", "text", "message", "subject", "html",
        "messagebody", "bodytext", "snippet"}

def collect(node, out):
    if isinstance(node, dict):
        for k, v in node.items():
            if isinstance(v, str) and k.lower() in KEYS:
                out.append(v)
            else:
                collect(v, out)
    elif isinstance(node, list):
        for v in node:
            collect(v, out)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
out = []
collect(data.get("tool_input", {}), out)
sys.stdout.write("\n".join(out))
') || exit 0

# No draft-like text in this call — let it through.
[ -z "$(printf '%s' "$text" | tr -d '[:space:]')" ] && exit 0

if ! result=$(printf '%s' "$text" | bash "$REPO_ROOT/hooks/check-quality.sh" 2>&1); then
  {
    echo "BLOCKED: outbound draft failed the document quality gate (hooks/check-quality.sh)."
    echo "$result"
    echo "Rewrite the draft to clear every violation, then retry the tool call."
    echo "Full rules: frameworks/document-quality.md"
  } >&2
  exit 2
fi
exit 0
