#!/usr/bin/env bash
# check-framework.sh — Framework reading enforcement
# Verifies that the relevant framework file was read before generating content
# Usage: bash hooks/check-framework.sh "task_type"
# Task types: outreach, business-case, champion-doc, objections, call-debrief, expansion, retro, mcp
set -euo pipefail

TASK="${1:-}"

if [ -z "$TASK" ]; then
  echo "Usage: bash hooks/check-framework.sh 'task_type'"
  echo "Valid types: outreach, business-case, champion-doc, objections, call-debrief, expansion, retro, mcp, amlr, fraud"
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Map task type to framework file
case "$TASK" in
  outreach|email|linkedin|cold|warm)
    FRAMEWORK="frameworks/outreach.md"
    ALSO_READ="frameworks/document-quality.md"
    ;;
  business-case|business_case|proposal)
    FRAMEWORK="frameworks/business-case.md"
    ALSO_READ=""
    ;;
  champion|champion-doc|champion_doc|one-pager)
    FRAMEWORK="frameworks/champion-doc.md"
    ALSO_READ=""
    ;;
  objection|objections|handle-objection)
    FRAMEWORK="frameworks/objections.md"
    ALSO_READ=""
    ;;
  debrief|call-debrief|call_debrief|post-call)
    FRAMEWORK="frameworks/call-debrief.md"
    ALSO_READ=""
    ;;
  expansion|upsell|qbr|renewal)
    FRAMEWORK="frameworks/expansion.md"
    ALSO_READ=""
    ;;
  retro|retrospective|weekly-review)
    FRAMEWORK="frameworks/retro.md"
    ALSO_READ=""
    ;;
  mcp|mcp-conversation|mcp-outreach|technical-buyer|agentic|co-pilot|architecture-review)
    FRAMEWORK="knowledge/mcp-banking-positioning.md"
    ALSO_READ="knowledge/product-capabilities.md (Section 9 — TM Integration)"
    ;;
  amlr|amla|regulatory-outreach)
    FRAMEWORK="knowledge/amlr-positioning.md"
    ALSO_READ="frameworks/outreach.md + frameworks/document-quality.md"
    ;;
  fraud|fraud-to-sanctions|correspondent-banking)
    FRAMEWORK="knowledge/fraud-positioning.md"
    ALSO_READ="frameworks/outreach.md + frameworks/document-quality.md"
    ;;
  *)
    echo "Unknown task type: $TASK"
    echo "Valid types: outreach, business-case, champion-doc, objections, call-debrief, expansion, retro, mcp, amlr, fraud"
    exit 1
    ;;
esac

# Check if framework file exists
FRAMEWORK_PATH="$REPO_ROOT/$FRAMEWORK"
if [ ! -f "$FRAMEWORK_PATH" ]; then
  echo "FRAMEWORK CHECK FAILED — File not found: $FRAMEWORK"
  echo "Expected at: $FRAMEWORK_PATH"
  exit 1
fi

# Output the required reading
echo "FRAMEWORK CHECK — Before proceeding with '$TASK', read:"
echo "  1. $FRAMEWORK"
if [ -n "$ALSO_READ" ]; then
  echo "  2. $ALSO_READ"
fi
echo ""
echo "Do not generate content without reading the framework first."
echo "This is enforced by CLAUDE.md: 'Don't generate content without reading the relevant framework file first.'"
exit 0
