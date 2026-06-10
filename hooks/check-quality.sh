#!/usr/bin/env bash
# check-quality.sh — Document quality enforcement hook
# Scans content for banned language and patterns from document-quality.md
# Can be run standalone: echo "content" | bash hooks/check-quality.sh
# Or wired into Claude Code PreToolUse hooks for automated enforcement
set -euo pipefail

# Read content from stdin or first argument
if [ -n "${1:-}" ]; then
  CONTENT="$1"
else
  CONTENT=$(cat)
fi

VIOLATIONS=""
COUNT=0

# scan_category <label> <suffix> <term...>
# Emits one violation per term found (case-insensitive, literal-string match).
scan_category() {
  local label="$1"
  local suffix="$2"
  shift 2
  local term
  for term in "$@"; do
    if printf '%s' "$CONTENT" | grep -qiF -- "$term"; then
      VIOLATIONS="${VIOLATIONS}\n  - ${label}: \"${term}\"${suffix}"
      COUNT=$((COUNT + 1))
    fi
  done
}

scan_category "Banned word" "" \
  "seamless" "next-gen" "next gen" "cutting-edge" "cutting edge" \
  "comprehensive solution" "leverage" "synergy" "paradigm" "disruptive" \
  "best-in-class" "world-class" "turnkey" "holistic" "robust" \
  "scalable solution" "innovative" "transformative" "game-changing" \
  "mission-critical" "state-of-the-art" "end-to-end"

scan_category "Banned opener" "" \
  "In today's rapidly" "In an era of" "In today's fast-paced" \
  "In the ever-evolving" "As we navigate" "It's important to note" \
  "It is worth noting" "I wanted to reach out" "I hope this finds you" \
  "I hope this email finds" "Just checking in" "Per my last" \
  "As per our" "Touching base"

scan_category "Banned CTA" "" \
  "Schedule a demo" "Learn more" "Book a meeting" "Let's connect" \
  "Would love to chat" "Pick your brain" "Happy to discuss"

scan_category "AI vocabulary" "" \
  "delve" "tapestry" "multifaceted" "nuanced" "pivotal" "realm" \
  "testament" "underscore" "utilize" "whilst" "keen" "embark" \
  "intricate" "commendable" "meticulous" "paramount" "groundbreaking" \
  "ecosystem" "Additionally" "align with" "crucial" "enduring" \
  "enhance" "fostering" "garner" "interplay" "intricacies" "showcase" \
  "vibrant" "valuable" "profound" "renowned" "breathtaking" "nestled" \
  "stunning" "elevate" "unleash" "empower" "revolutionary"

scan_category "Significance inflation" "" \
  "stands as" "pivotal moment" "indelible mark" "deeply rooted" \
  "setting the stage for"

scan_category "Superficial -ing analysis" "" \
  "highlighting" "underscoring" "emphasizing" "reflecting" \
  "showcasing" "contributing to"

scan_category "Promotional language" "" \
  "boasts a" "exemplifies" "commitment to"

scan_category "Copula avoidance" " - use is/are/has instead" \
  "serves as" "stands as" "represents a"

scan_category "Collaborative artifact" " - remove AI assistant tone" \
  "I hope this helps" "Of course!" "Certainly!" "Would you like me to" \
  "Great question" "You're absolutely right"

scan_category "Filler phrase" "" \
  "In order to" "Due to the fact that" "At this point in time" \
  "It should be noted" "It is worth mentioning" "It's important to note"

scan_category "Generic positive conclusion" "" \
  "The future looks bright" "Exciting times" "looks promising" \
  "well-positioned"

scan_category "Vague attribution" " - cite the specific source" \
  "Industry reports" "Experts argue" "Some critics argue" \
  "Studies show" "Research suggests"

# --- Style patterns that need per-pattern logic ---

# Em dash detection: any in short content; >1 per 200 words in long content.
# grep -c returns exit 1 on zero matches even with -c, so `|| true` is required
# under set -e; grep still prints "0" on its stdout.
EM_DASH_COUNT=$(printf '%s' "$CONTENT" | grep -c '—' || true)
WORD_COUNT=$(printf '%s' "$CONTENT" | wc -w | tr -d ' ')
if [ "$EM_DASH_COUNT" -gt 0 ]; then
  ALLOWED=$(( (WORD_COUNT / 200) + 1 ))
  if [ "$EM_DASH_COUNT" -gt "$ALLOWED" ] || [ "$WORD_COUNT" -lt 200 ]; then
    VIOLATIONS="${VIOLATIONS}\n  - Style: em dash detected ($EM_DASH_COUNT found) - use periods, commas, or dashes instead"
    COUNT=$((COUNT + 1))
  fi
fi

# Fake precision: round-number multipliers + suspicious percentages
if printf '%s' "$CONTENT" | grep -qE '(10x|100x|1000x) (improvement|better|faster|more)'; then
  VIOLATIONS="${VIOLATIONS}\n  - Fake precision: round-number multiplier claim"
  COUNT=$((COUNT + 1))
fi

if printf '%s' "$CONTENT" | grep -qE '99\.9%|99\.99%'; then
  VIOLATIONS="${VIOLATIONS}\n  - Fake precision: suspiciously round percentage"
  COUNT=$((COUNT + 1))
fi

# --- Output ---
if [ $COUNT -gt 0 ]; then
  echo "QUALITY CHECK FAILED — $COUNT violation(s):"
  printf '%b\n' "$VIOLATIONS"
  echo ""
  echo "Fix these before sending. See frameworks/document-quality.md for the full rules."
  exit 1
else
  echo "QUALITY CHECK PASSED"
  exit 0
fi
