# Task Preamble (shared by all scheduled tasks)

Every scheduled task SKILL.md should reference this file for the coordination boilerplate below. This file is read once per task run — the SKILL.md only needs to include task-specific setup and the actual task steps.

## Setup (always run these, in order)

0. **Heartbeat FIRST — before the git pull below or any file read.** As your very first action, append a `task_start` event to `memory/analytics.jsonl` AND a `task_started` line to `memory/handoff.jsonl` (run_id `{task-abbrev}-{YYYYMMDD}`). *Why:* a scheduled task that dies during setup or an early step otherwise leaves NO trace — silent failure is indistinguishable from "never fired" (postmortem: `ARCHITECTURE.md` → "Scheduled task fires but produces no output"). The heartbeat converts a silent death into "started at T, never completed," which is the diagnostic signal everything else depends on. Output written only at the end of a task is a blind spot if the task can die early.
1. Run `bash /Users/ckinkead-sayari/GTM-OSS/hooks/git-safe.sh pull` to get latest state. `git-safe.sh` defensively clears stale `.git/index.lock` files (>5m old) and serializes git ops across concurrent tasks. If it exits with code 1, `.git/index.lock` is recent — another git op may be live; wait 60s and retry once, then abort with `task_blocked` if still locked.
2. Read `/Users/ckinkead-sayari/GTM-OSS/.claude/CLAUDE.md` for system context.

Task-specific additional reads (if any) are listed in the SKILL.md's own Setup section.

## Coordination

**Upstream check:** Read last 10 lines of `/Users/ckinkead-sayari/GTM-OSS/memory/task-registry.jsonl`. Check upstream dependencies for data freshness. If any upstream is stale (>24h) or failed, set CONFIDENCE = DEGRADED for affected data and note it in output.

**Retry policy:** If any MCP call fails, wait 60s and retry (max 2 retries with 60s/120s delays). If all retries fail, use fallback per `frameworks/task-coordination.md`. Log each MCP call outcome.

**Trace logging:** The `task_start` event is the **Step 0 heartbeat** above — it is your first action, not a step you reach later. Log `task_complete` (or `task_failed`) at the end with duration and key metrics, and append the matching completion line to handoff. Use run_id format: `{task-abbrev}-{YYYYMMDD}` (same id as the heartbeat). If you ever reach the end without a heartbeat already logged, that's an ordering bug — log both and flag it.

**Task registry:** After completion, append a status record to `/Users/ckinkead-sayari/GTM-OSS/memory/task-registry.jsonl` with task name, status, timestamp, data_freshness date, and any errors.

## Handoff format

Append a one-line summary to `/Users/ckinkead-sayari/GTM-OSS/memory/handoff.jsonl` in this shape (source, action, output_id, and details are task-specific):

```json
{"source":"{task-name}","ts":"TIMESTAMP","action":"{task_action}","output_id":"{abbrev-YYYYMMDD}","account":"ACCOUNT_OR_ALL","contact":"EMAIL_OR_NA","state":"complete","details":"brief description"}
```

## Git sync (if files modified)

Always use `hooks/git-safe.sh` instead of raw `git` for scheduled tasks — it handles stale-lock cleanup and serializes concurrent writers:

- `bash /Users/ckinkead-sayari/GTM-OSS/hooks/git-safe.sh add <specific files>` (not `add -A`)
- `bash /Users/ckinkead-sayari/GTM-OSS/hooks/git-safe.sh commit -m "scheduled: {task-name} YYYY-MM-DD"`
- `bash /Users/ckinkead-sayari/GTM-OSS/hooks/git-safe.sh push`

Exit-code handling: code 1 = live holder (wait 60s, retry once, then `task_blocked`); code 2 = serialization timeout (retry once after 60s, then `task_blocked`); code 3 = virtiofs EPERM (host reaper auto-resolves within ~10s — wait 15s and retry once); non-zero from git = log and proceed per retry policy.

**Host reaper dependency:** exit-3 recovery depends on `hooks/reap-git-locks.sh` running as a launchd LaunchAgent on the Mac host (label `com.claudegtm.git-reaper`, `StartInterval=10`). Reaper audit trail is `memory/reap-log.jsonl`. If the reaper isn't running, exit 3 stays stuck until manual host-side `rm`. Install: `bash hooks/install-reaper.sh`.

## MCP fallback rules

If a required MCP is unavailable in this session, do NOT retry indefinitely:
1. Log the unavailability to handoff.jsonl with `action:"task_blocked"` and `details` naming the missing MCP
2. Skip the dependent steps; produce a partial output noting what's missing
3. Do NOT fabricate data. Write "BLOCKED: {MCP} unavailable" where that data would have gone.

## Dedup check (for tasks that create outbound artifacts)

Before creating any Gmail draft, Notion contact, or Slack message: check last 48h of `memory/handoff.jsonl` for matching contact+action records. If a matching record exists with state != "resolved", skip and log as "already_pending".
