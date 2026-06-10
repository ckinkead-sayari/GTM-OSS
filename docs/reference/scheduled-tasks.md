# Scheduled Tasks Reference

Local scheduled tasks run via the Claude Code Desktop app. Mac must be awake + Desktop open for them to fire. All tasks start at 9 AM or later so the machine is on.

**Current operating state (since ~May 2026):** 4 tasks enabled on a weekly cadence, 5 kept as manual-only — the original everything-daily flow proved more than the workflow needed. Enable more only when the cadence earns it.

## Enabled (weekly cadence)

| Task | Time | What it does |
|------|------|--------------|
| `daily-gtm-briefing` | Monday ~10:23 AM | Pipeline health, overdue items, top priorities, Slack DM |
| `pipeline-staleness-check` | Wednesday ~10:01 AM | Flags stalled opps, missing next steps, contact gaps |
| `mixpanel-usage-sync` | Wednesday ~1:06 PM | Pulls product usage, refreshes health scores, flags DQ anomalies |
| `weekly-gtm-retro` | Friday ~11:08 AM | Retrospective — pipeline health, patterns, recommendations |

## Manual-only (run on demand from the Desktop app Scheduled sidebar)

| Task | What it does |
|------|--------------|
| `external-call-prep` | Call briefs for the day's external meetings |
| `lead-response-scanner-pm` | Scans Gmail for leads needing response |
| `outbound-sequence-engine` | Advances multi-touch sequences |
| `renewal-tracker` | Upcoming renewals, health flags, outreach triggers |
| `gong-pipeline-sync` | SFDC opp state refresh via Glean |

## How tasks coordinate

All tasks share `frameworks/task-preamble.md`:

- `git pull` via `hooks/git-safe.sh` at start
- Check `memory/task-registry.jsonl` for upstream dependency state
- Retry policy: wait 60s, retry (max 2 attempts)
- Log `task_start` and `task_complete` events to `memory/analytics.jsonl`
- Write one-line summary to `memory/handoff.jsonl` on completion
- `git add` + `git commit` + `git push` via `hooks/git-safe.sh` at end

Per-task detail: [`frameworks/scheduled-tasks-reference.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/scheduled-tasks-reference.md) (lazy-loaded — only read when debugging or designing new tasks).

## Why Local, not Cloud

Cloud-based project-scoped triggers cannot reliably resolve MCP tools at runtime as of April 2026 — despite connectors showing as configured. Local tasks inherit the Desktop app's authenticated MCP sessions and work.

Claude Code Routines (cloud) were evaluated and rejected in April 2026: research preview instability, MCP resolution uncertainty, non-trivial migration cost. Revisit when Routines hit GA.

## Known constraints

- **Mac sleep is a missed run.** If the Mac is asleep at the scheduled time, the task is skipped (not queued). Start all tasks ≥9 AM to minimize this.
- **MCP token scope doesn't propagate to subagents.** Parent session authenticated MCPs work; subagents may not inherit.
- **Git ops must route through `hooks/git-safe.sh`.** Raw `git` in tasks is a correctness bug — race conditions and stale-lock failures follow.

## Common failures and fixes

| Symptom | Fix |
|---------|-----|
| Task didn't fire | Check Desktop app was open + Mac awake at scheduled time |
| Task "fired" (fresh `lastRunAt`) but produced nothing — no Slack post, no handoff entry, no commit | Silent execution failure (observed Jun 2026). `hooks/session-start.sh` detects it via handoff-gap staleness. Diagnose: run the task manually from the Scheduled sidebar and capture the error; if opaque, delete + re-create the task. |
| MCP unavailable | Reconnect in Claude Code settings (`/mcp` → reconnect). Scheduled tasks inherit the Desktop app's session. |
| `git-safe.sh` exit 3 | Host-side reaper should auto-resolve within 10s. If reaper not installed, `bash hooks/install-reaper.sh`. |
| Stale handoff chain | Check last 20 lines of `memory/handoff.jsonl` for gaps — a broken task upstream can starve downstream tasks |

## See also

- [`frameworks/task-preamble.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/task-preamble.md) — shared coordination boilerplate.
- [`frameworks/task-coordination.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/task-coordination.md) — dependency DAG, retry policy, trace events.
- [`frameworks/scheduled-tasks-reference.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/scheduled-tasks-reference.md) — per-task steps.
- [ARCHITECTURE.md](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/ARCHITECTURE.md) — full system design.
