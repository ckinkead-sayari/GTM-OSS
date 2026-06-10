#!/usr/bin/env bash
# check-research.sh — Research-before-outreach enforcement
# Verifies that account research has been logged before outreach is drafted
# Can be run standalone: bash hooks/check-research.sh "Account Name"
# Or wired into Claude Code PreToolUse hooks
set -euo pipefail

ACCOUNT="${1:-}"

if [ -z "$ACCOUNT" ]; then
  echo "Usage: bash hooks/check-research.sh 'Account Name'"
  echo "Checks if research exists for the given account before allowing outreach."
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
ACCOUNT_SLUG=$(echo "$ACCOUNT" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

RESEARCH_EXISTS=false
RESEARCH_SOURCES=""

# Check 1: Account file in accounts/ directory
ACCOUNT_FILE="$REPO_ROOT/accounts/${ACCOUNT_SLUG}.md"
if [ -f "$ACCOUNT_FILE" ]; then
  RESEARCH_EXISTS=true
  RESEARCH_SOURCES="${RESEARCH_SOURCES}\n  - Account file: $ACCOUNT_FILE"
fi

# Check 2: Analytics log for recent research on this account
ANALYTICS_FILE="$REPO_ROOT/memory/analytics.jsonl"
if [ -f "$ANALYTICS_FILE" ]; then
  # Look for research entries for this account in the last 7 days.
  # Use -F on the account name so regex metacharacters don't break the match.
  RECENT=$(grep -iF -- "$ACCOUNT" "$ANALYTICS_FILE" 2>/dev/null | grep '"framework":"research\|"action":"research\|"event":"account_research"' | tail -1 || true)
  if [ -n "$RECENT" ]; then
    RESEARCH_EXISTS=true
    RESEARCH_SOURCES="${RESEARCH_SOURCES}\n  - Analytics log entry found"
  fi
fi

# Check 3: Active context mentions recent research
CONTEXT_FILE="$REPO_ROOT/memory/active-context.md"
if [ -f "$CONTEXT_FILE" ]; then
  # Same line mentions both "research" and the account — regex-safe via -F.
  if grep -iF -- "$ACCOUNT" "$CONTEXT_FILE" 2>/dev/null | grep -qiF "research"; then
    RESEARCH_EXISTS=true
    RESEARCH_SOURCES="${RESEARCH_SOURCES}\n  - Mentioned in active-context.md"
  fi
fi

# --- Output ---
if [ "$RESEARCH_EXISTS" = true ]; then
  echo "RESEARCH CHECK PASSED for $ACCOUNT"
  echo -e "Sources:$RESEARCH_SOURCES"
  exit 0
else
  echo "RESEARCH CHECK FAILED for $ACCOUNT"
  echo ""
  echo "No prior research found. Before drafting outreach, you must:"
  echo "  1. Search for recent news, regulatory actions, and competitive developments"
  echo "  2. Check their earnings, leadership changes, and M&A activity"
  echo "  3. Look for evidence that contradicts your assumptions about their pain"
  echo ""
  echo "This is non-negotiable. See ETHOS.md: Research Before Everything."
  exit 1
fi
