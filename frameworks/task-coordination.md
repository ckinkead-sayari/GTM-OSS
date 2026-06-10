# Task Coordination Framework

Defines how scheduled tasks coordinate: dependency checking, retry/resilience, observability, and idempotency. Inspired by DAG-based multi-agent orchestration patterns.

## Task Dependency Map

Tasks have implicit data dependencies. Downstream tasks must check upstream freshness before running.

```
mixpanel-usage-sync ──→ daily-gtm-briefing     (needs fresh health scores)
mixpanel-usage-sync ──→ external-call-prep      (needs fresh usage for call context)
gong-pipeline-sync  ──→ renewal-tracker         (needs latest opp/contact data)
lead-response-scanner-am ──→ outbound-sequence-engine (new leads → new sequences)
```

Tasks with no upstream dependencies: `mixpanel-usage-sync`, `gong-pipeline-sync`, `lead-response-scanner-am`, `lead-response-scanner-pm`, `pipeline-staleness-check`, `weekly-gtm-retro`.

## Task Registry Protocol

Every task writes a status record to `memory/task-registry.jsonl` on completion.

### Record Format

```json
{
  "task": "mixpanel-usage-sync",
  "status": "completed",
  "ts": "2026-04-07T09:08:00Z",
  "data_freshness": "2026-04-07",
  "accounts_updated": 8,
  "errors": []
}
```

Failed run:
```json
{
  "task": "mixpanel-usage-sync",
  "status": "failed",
  "ts": "2026-04-08T09:08:00Z",
  "data_freshness": "2026-04-07",
  "error": "Mixpanel MCP unavailable after 2 retries",
  "fallback_used": true
}
```

### Downstream Freshness Check

Before running, downstream tasks read the last record for each upstream dependency:

1. **Fresh** (`data_freshness` = today): Proceed normally.
2. **Stale** (`data_freshness` = yesterday): Proceed but flag output as `DEGRADED — upstream data is 1 day old`.
3. **Very stale** (`data_freshness` > 2 days old): Proceed with `STALE` flag. Use last-known-good data from Notion. Note in Slack output which data source is stale.
4. **No record found**: Proceed with `UNKNOWN FRESHNESS` flag. This is expected on first run.

Downstream tasks NEVER skip execution due to upstream failure. They always run, but transparently communicate data confidence.

## Retry & Resilience Policy

### MCP Call Retry

When an MCP tool call fails (timeout, unavailable, auth error):

1. **First failure**: Wait 60 seconds, retry once.
2. **Second failure**: Wait 120 seconds, retry once more.
3. **Third failure**: Stop retrying this MCP. Log the failure. Use fallback strategy.

Max retries per MCP call: **2** (3 total attempts).

### Fallback Strategies

When all retries for an MCP are exhausted:

| MCP | Fallback |
|-----|----------|
| Mixpanel | Use last-known health scores from Notion. Flag as `STALE — Mixpanel unavailable`. |
| Glean | Use last-known pipeline data from Notion + active-context.md. Flag as `STALE — Glean unavailable`. |
| Gmail | Skip email-dependent steps. Log as `SKIPPED — Gmail unavailable`. |
| GCal | Skip calendar-dependent steps. Log as `SKIPPED — GCal unavailable`. |
| Notion | Critical failure — log to Slack and task-registry.jsonl. Cannot proceed without Notion for most tasks. |
| Slack | Write output to handoff.jsonl instead. User will see it at next interactive session. |

### Circuit Breaker

Track consecutive failures per MCP across task runs (via task-registry.jsonl):

- **3 consecutive runs** with same MCP failure → Post escalation to Slack:
  ```
  CIRCUIT BREAKER: {MCP name} has failed for 3 consecutive task runs ({task names}).
  Last success: {date}. Investigate MCP connectivity.
  ```
- Circuit breaker resets when any task successfully uses that MCP.

### Checkpoint Cleanup

If `memory/task-state/*.json` checkpoint files are >48 hours old, archive them to `memory/task-state/archive/` with a note. Stale checkpoints indicate a task that started but never finished.

## Trace Event Logging

Every task logs structured events to `memory/analytics.jsonl` for observability.

### Required Events

```json
{"event":"task_start","task":"mixpanel-usage-sync","ts":"2026-04-07T09:06:00Z","run_id":"mus-20260407"}
{"event":"task_mcp_call","task":"mixpanel-usage-sync","mcp":"mixpanel","status":"success","ts":"2026-04-07T09:06:15Z","run_id":"mus-20260407"}
{"event":"task_mcp_call","task":"mixpanel-usage-sync","mcp":"notion","status":"failed","error":"timeout","retry":1,"ts":"2026-04-07T09:07:00Z","run_id":"mus-20260407"}
{"event":"task_mcp_call","task":"mixpanel-usage-sync","mcp":"notion","status":"success","retry":2,"ts":"2026-04-07T09:08:30Z","run_id":"mus-20260407"}
{"event":"task_complete","task":"mixpanel-usage-sync","status":"completed","accounts_updated":8,"duration_min":3,"ts":"2026-04-07T09:09:00Z","run_id":"mus-20260407"}
```

### Run ID Format

`{task-abbreviation}-{YYYYMMDD}` — e.g., `mus-20260407`, `dgb-20260407`, `ecp-20260407`.

For tasks that run twice daily (lead-response-scanner), append `-am` or `-pm`: `lrs-20260407-am`.

### What Gets Logged

| Event | When | Required Fields |
|-------|------|-----------------|
| `task_start` | Task begins execution | task, ts, run_id |
| `task_upstream_check` | Dependency freshness verified | task, upstream_task, freshness_status, data_freshness |
| `task_mcp_call` | Each MCP tool invocation | task, mcp, status, ts, run_id, retry (if >0), error (if failed) |
| `task_fallback` | Fallback strategy activated | task, mcp, fallback_action, ts, run_id |
| `task_complete` | Task finishes | task, status, ts, run_id, duration_min, key metrics |
| `task_circuit_breaker` | Circuit breaker triggered | task, mcp, consecutive_failures, last_success |

## Idempotency & Dedup

### Output Dedup Protocol

Before creating any external output (Gmail draft, Notion record, sequence step):

1. Read last 48 hours of `memory/handoff.jsonl`.
2. Search for matching records by `contact` + `action` combination.
3. If match found with `state` != `"resolved"` → **Skip**. Log as `already_pending` in handoff.jsonl.
4. If no match or match is `"resolved"` → Proceed with creation.

### Handoff Record Format (Extended)

Standard handoff records gain optional state tracking fields:

```json
{
  "source": "lead-response-scanner",
  "ts": "2026-04-07T09:48:00Z",
  "action": "gmail_draft_created",
  "output_id": "draft-xyz",
  "account": "Acme Bank",
  "contact": "jane.doe@acme-bank.example",
  "state": "awaiting_review",
  "details": "Qualifying email for inbound lead"
}
```

Interactive sessions resolve pending items:
```json
{
  "source": "interactive",
  "ts": "2026-04-07T14:00:00Z",
  "action": "draft_sent",
  "output_id": "draft-xyz",
  "resolved_by": "S-012"
}
```

### State Values

| State | Meaning |
|-------|---------|
| `awaiting_review` | Output created, needs human review before action |
| `resolved` | Human reviewed and acted (sent, approved, dismissed) |
| `expired` | Output became irrelevant (>7 days without resolution) |
| `already_pending` | Dedup triggered — identical output already exists |

## Task Preamble Block

Every scheduled task prompt should include this preamble after git pull and config read:

```
## Coordination Check
1. Read last 10 lines of memory/task-registry.jsonl for upstream task status.
2. For each upstream dependency, note data_freshness and status.
3. If any upstream is stale (>24h) or failed, set CONFIDENCE = DEGRADED for affected data.
4. Proceed with execution — never skip due to upstream failure.
5. After completion, append status record to memory/task-registry.jsonl.
6. Log task_start and task_complete events to memory/analytics.jsonl.
```

## Task Postamble Block

Every scheduled task prompt should include this after main work:

```
## Completion Protocol
1. Append status record to memory/task-registry.jsonl (status, data_freshness, metrics, errors).
2. Log task_complete event to memory/analytics.jsonl with duration and key metrics.
3. Append handoff summary to memory/handoff.jsonl.
4. Git add + commit + push all changed files.
5. Post summary to Slack (include any DEGRADED/STALE flags prominently).
```

## Weekly Retro: Task Health Section

The weekly retro (`frameworks/retro.md`) should include a Task Health section:

```
## Task Execution Health
| Task | Runs This Week | Successes | Failures | Avg Duration | MCP Issues |
|------|---------------|-----------|----------|-------------|------------|

### MCP Reliability
| MCP | Success Rate | Failures | Circuit Breaker Triggered? |
|-----|-------------|----------|---------------------------|

### Pending Outputs (Unresolved)
| Output | Created | Age | Action Needed |
|--------|---------|-----|--------------|

### Observations
- [Any patterns in task failures]
- [MCP reliability trends]
- [Dedup triggers — are tasks creating redundant outputs?]
```
