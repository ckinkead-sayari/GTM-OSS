---
name: end-session
description: Run the full end-session protocol — roll active-context forward, update action items, log analytics + handoff, commit + push. Triggers: "end session", "wrap up", "done for today".
---


Execute the End Session Protocol (this file is the procedure; `.claude/CLAUDE.md` → "Session Lifecycle" triggers it). Run every step in order, report each step's outcome, and finish with a completion status. Do not skip steps — S-034 and S-035 both skipped this protocol and stranded two weeks of state.

1. **Roll sessions forward** in `memory/active-context.md`:
   - Two Sessions Ago ← Previous Session; Previous Session ← This Session; This Session ← populated with this session's work
   - Update the `Last updated:` header line and add a row to the Session Index table
2. **Update open action items** — mark completed items, add new ones discovered this session
3. **Sync knowledge base to Notion** only if `knowledge/domain-summary.md` or `knowledge/communication-playbook.md` changed this session (page ID in `.claude/MY-CONFIG.md`). Otherwise skip.
4. **Log session_end** to `memory/analytics.jsonl` with this session's `session_id` (must match the session_start event; if no session_start was logged, mint an ID with `bash hooks/next-session-id.sh` and log both events now)
5. **Append a handoff summary** to `memory/handoff.jsonl`:
   `{"source":"interactive","ts":"<UTC ISO>","session_id":"S-NNN","action":"session_summary","details":"<key work done>"}`
6. **Commit + push**: stage the specific changed files (never `git add -A`), commit `"session end: <brief summary>"`, push to origin. Route through `hooks/git-safe.sh` when running in a sandbox or scheduled context.
7. **Announce** what was committed and pushed, then report `DONE` / `DONE_WITH_CONCERNS` / `BLOCKED` with specifics.
