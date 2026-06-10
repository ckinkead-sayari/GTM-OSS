#!/usr/bin/env bash
# check-config.sh — Validates MY-CONFIG.md exists and has required fields populated
# Runs at session start (preamble) and before each scheduled task.
# Exit 0 = config valid, Exit 1 = missing or incomplete with actionable errors.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CONFIG_FILE="$REPO_ROOT/.claude/MY-CONFIG.md"
TEMPLATE_FILE="$REPO_ROOT/.claude/MY-CONFIG.template.md"
PLAYBOOK_FILE="$REPO_ROOT/knowledge/communication-playbook.md"
PLAYBOOK_TEMPLATE="$REPO_ROOT/knowledge/communication-playbook.template.md"

ERRORS=()
WARNINGS=()

# --- Check 1: Config file exists ---
if [ ! -f "$CONFIG_FILE" ]; then
  echo "CONFIG CHECK FAILED"
  echo ""
  echo "  .claude/MY-CONFIG.md does not exist."
  echo ""
  echo "  To fix: cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md"
  echo "  Then fill in your personal values (name, accounts, service IDs)."
  echo ""
  echo "  See FORK-GUIDE.md for full setup instructions."
  exit 1
fi

# --- Check 2: Required fields are filled (not placeholder text) ---
check_field() {
  local label="$1"
  local pattern="$2"
  local section="$3"

  if grep -q "$pattern" "$CONFIG_FILE" 2>/dev/null; then
    ERRORS+=("$label is still a placeholder. Edit .claude/MY-CONFIG.md → $section section.")
  fi
}

# Identity fields
check_field "Name" "\[Your name\]" "Who I Am"
check_field "Role" "\[Your role" "Who I Am"
check_field "Territory" "\[Your territory" "Who I Am"
check_field "Accounts" "\[Comma-separated" "Who I Am"

# Service IDs
check_field "Mixpanel Project ID" "\[e.g.," "Service IDs"
check_field "Slack DM Channel" "\[Your Slack" "Service IDs"
check_field "Git Repo Slug" "\[your-username" "Service IDs"

# Notion DB IDs
check_field "Notion Accounts DB" "\[your-accounts-db" "Notion Database IDs"
check_field "Notion Deals DB" "\[your-deals-db" "Notion Database IDs"
check_field "Notion Contacts DB" "\[your-contacts-db" "Notion Database IDs"
check_field "Notion Sequences DB" "\[your-sequences-db" "Notion Database IDs"
check_field "Notion KB Page" "\[your Notion KB" "Notion Database IDs"

# --- Check 3: Account mapping table has at least one real row ---
MAPPING_ROWS=$(grep -c "^|" "$CONFIG_FILE" 2>/dev/null || echo "0")
# Header + separator = 2 rows. Need at least 3 for one data row.
if [ "$MAPPING_ROWS" -lt 6 ]; then
  WARNINGS+=("Account → Mixpanel mapping table has few entries. Add your accounts for scheduled tasks to work.")
fi

# --- Check 4: Communication playbook exists ---
if [ ! -f "$PLAYBOOK_FILE" ]; then
  if [ -f "$PLAYBOOK_TEMPLATE" ]; then
    WARNINGS+=("knowledge/communication-playbook.md does not exist. Create it from the template: cp knowledge/communication-playbook.template.md knowledge/communication-playbook.md")
  else
    WARNINGS+=("knowledge/communication-playbook.md does not exist. Create your voice playbook from 30+ sent emails. See FORK-GUIDE.md.")
  fi
fi

# --- Output ---
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo "CONFIG CHECK FAILED — ${#ERRORS[@]} required field(s) not configured:"
  echo ""
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
  if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo ""
    echo "Also:"
    for warn in "${WARNINGS[@]}"; do
      echo "  - (warning) $warn"
    done
  fi
  echo ""
  echo "Fix these in .claude/MY-CONFIG.md and re-run: bash hooks/check-config.sh"
  exit 1
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
  echo "CONFIG CHECK PASSED with ${#WARNINGS[@]} warning(s):"
  for warn in "${WARNINGS[@]}"; do
    echo "  - $warn"
  done
  exit 0
fi

echo "CONFIG CHECK PASSED — all required fields configured."
exit 0
