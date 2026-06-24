---
name: preamble
description: Run the full session preamble — config + MCP probe, git pull, load active-context + TODOS + handoff, staleness scan, mint session ID. Triggers: "preamble", "start session", "start my day".
---


Execute the Session Preamble (spec: `frameworks/preamble.md`; summary: `.claude/CLAUDE.md` → "Session Lifecycle"). The SessionStart hook has already printed the quick digest — this command runs the full protocol on top of it.

1. `bash hooks/check-config.sh` — if it fails, announce the missing config and STOP. Read `.claude/MY-CONFIG.md` into working memory (identity, accounts, service IDs, Mixpanel mapping).
2. `bash hooks/check-mcp.sh` — if stale (>24h) or broken, re-probe every MCP listed in `memory/mcp-status.json` using its recorded `probe_tool`/`probe_args`, rewrite the file with fresh statuses + `last_probe_ts` + `probe_session`, and announce any BROKEN MCPs immediately.
3. `git pull` (route through `hooks/git-safe.sh pull` when sandboxed) — scheduled tasks may have pushed since the last interactive session.
4. Read `memory/active-context.md`, `TODOS.md`, and the last 20 lines of `memory/handoff.jsonl`.
5. Check the Slack DM channel (ID in MY-CONFIG.md) for scheduled-task outputs from the last 24–48h.
6. Staleness scan: past-due pipeline actions; action items unchanged 3+ sessions; active-context >14d old; handoff gap ≥5 days (that last one means scheduled tasks are failing silently — cross-check Desktop app `lastRunAt`).
7. Mint the session ID with `bash hooks/next-session-id.sh` and log `session_start` to `memory/analytics.jsonl`.
8. Announce: current priorities, overdue items, P0 TODOs, and anything notable from handoffs. If no task was requested, recommend the highest-priority open item.
