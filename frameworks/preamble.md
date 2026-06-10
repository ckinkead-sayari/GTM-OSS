# Session Preamble

Run these checks at the start of every session. The preamble ensures context is loaded, stale data is flagged, and the session starts informed.

## Step 0: Validate Config

Run `bash hooks/check-config.sh`. If it fails:
- Announce exactly which fields are missing
- Tell the user: "Run `cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md` and fill in the flagged sections."
- **STOP** — do not proceed with the rest of the preamble until config is valid.

If it passes, read `.claude/MY-CONFIG.md` and load all values into working memory:
- Identity (name, role, territory, accounts)
- Service IDs (Mixpanel project/workspace, Glean agent, Slack channel, git repo)
- Notion database IDs
- Account → Mixpanel mapping table

These values are used throughout the session. Do not re-read MY-CONFIG.md — cache in working memory.

## Step 1: Load Context

Read `memory/active-context.md`. This has:
- Current priorities
- Pipeline state (accounts, stages, next actions)
- What happened in the last 3 sessions
- Open action items
- Objections heard this week
- Expansion signals

If the file is empty or has placeholder text, flag it: "Active context needs to be populated. What are your current priorities and pipeline state?"

## Step 2: Check for Stale Data

Scan the active context for staleness:

- **Pipeline entries with past-due actions:** Flag any "Due" date that has passed. "Account_A follow-up was due 3/20 — is this still open?"
- **Sessions older than 2 weeks:** If "What Happened This Session" hasn't been updated in 14+ days, flag it. Context is going stale.
- **Open action items with no progress:** If the same action item appears across 3+ sessions with no update, flag it. It's either done (mark it) or stuck (escalate it).

## Step 3: Check TODOS.md

Read `TODOS.md` for any P0 items that haven't been started. Flag them.

## Step 4: Log Session Start

Append to `memory/analytics.jsonl`:

```json
{"event":"session_start","ts":"TIMESTAMP","priorities":"CURRENT_PRIORITIES_SUMMARY"}
```

## Step 5: Announce Context

Briefly tell the user:
1. What the current priorities are
2. Any stale or overdue items
3. Any P0 TODOs that need attention

Keep it to 3-4 sentences. Don't repeat the entire active-context file.

## Step 6: Ready

Proceed with the user's request. If they haven't specified what to work on, recommend the highest-priority open item from TODOS.md or the most overdue pipeline action.
