# Weekly GTM Retrospective

Run this at the end of each week (or when asked for a "retro" or "weekly review").

## Step 1: Gather Data

Read the following:
- `memory/active-context.md` — session logs for the past week
- `memory/analytics.jsonl` — framework usage data
- `TODOS.md` — what was completed, what's still open

If per-account files exist in `accounts/`, scan for recent updates.

## Step 2: Pipeline Health Check (Three-Component Decomposition)

For each account, review the three health score components from Notion:

| Component | What to Check | Flag If |
|-----------|--------------|---------|
| **Leading Score** | Feature breadth, user growth, session depth trend | Declining while Lagging stable = early warning |
| **Lagging Score** | Weighted events (EWMA), active users, concentration %, trend | z < -2 = significant drop. Concentration >60% = multi-threading needed |
| **Context Score** | Renewal proximity, MEDDPICC, deal velocity, competitive signals | Competitor mentions increasing. MEDDPICC gaps near renewal. |

Also check:
| Check | Flag If |
|-------|---------|
| Stage movement | No stage change in 30+ days |
| Next action | Overdue or missing |
| Champion status | No champion identified |
| Last contact | No activity in 21+ days |
| Multi-threading | Concentration >60% without active playbook (`frameworks/multi-threading.md`) |

Produce pipeline status per account: GREEN (active, progressing, Leading+Lagging stable/improving), YELLOW (stalling, Leading declining or concentration risk), RED (stale, Lagging declining, churn risk HIGH/CRITICAL).

## Step 3: Activity Summary

Summarize the week's work:
- Accounts touched (research, outreach, calls, follow-ups)
- Accounts NOT touched (flag gaps)
- Frameworks used (which ones, how often)
- Objections logged
- Expansion signals captured

## Step 4: Health Score Accuracy Review (Feedback Loop)

This step measures whether the health scoring system actually works. Skip only if the system has been running <2 weeks.

1. **Tier changes this week**: Which accounts moved between tiers (STRONG → WATCH, AT RISK → CRITICAL, etc.)? List each with the specific data that drove the change.
2. **Outcome validation**: For accounts that were flagged CRITICAL/HIGH in previous weeks — did the prediction hold? Did the account actually show churn signals, or was it a false alarm?
3. **Intervention effectiveness**: For accounts where Churn Intervention or multi-threading plays were executed — did the trajectory improve? Compare Leading/Lagging scores before vs after intervention.
4. **False positives/negatives**: Any accounts that churned or had issues that the health score did NOT predict? Any accounts flagged as critical that are actually fine? These are calibration errors.
5. **Log outcomes**: For each validated/invalidated prediction, log to analytics.jsonl:
```json
{"event":"health_outcome","account":"NAME","ts":"TIMESTAMP","predicted_tier":"AT_RISK","actual_outcome":"improved|churned|stable|false_alarm","intervention":"churn_intervention|multi_threading|none","notes":"brief context"}
```

**After 60 days of outcomes data:** Run correlation analysis — which component (Leading, Lagging, Context) best predicted actual outcomes? Adjust 35/45/20 weights based on evidence. Document the calibration in ARCHITECTURE.md.

**After 90 days:** Optimize thresholds (30/49/64) using empirical score distributions and outcomes. Replace intuitive boundaries with data-driven cutoffs.

## Step 5: Pattern Recognition

Look for patterns across accounts:
- **Recurring objections** — same objection from multiple accounts = systemic issue. Promote to `frameworks/objections.md` if not already there.
- **Competitive mentions** — same competitor appearing across accounts = competitive trend. Cross-reference with Context Score competitor sub-metric.
- **Stall patterns** — multiple accounts stuck at the same stage = process issue.
- **Win patterns** — what's working in accounts that are progressing.
- **Health score patterns** — are Leading Score declines consistently predicting Lagging Score drops 2-4 weeks later? This validates the leading indicator design.

## Step 6: Recommendations

Based on the retro data, recommend:
1. **Focus accounts for next week** — which accounts need the most attention and why
2. **Framework gaps** — any recurring situations not covered by existing frameworks
3. **Process improvements** — what could work better in the GTM workflow
4. **Overdue items** — action items that have been open too long

## Step 7: Output Format

```
# Weekly GTM Retro — Week of [DATE]

## Portfolio Health Summary
| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Accounts STRONG | X | Y | +/- |
| Accounts WATCH | X | Y | +/- |
| Accounts AT RISK / CRITICAL | X | Y | +/- |
| Data File (limited visibility) | X | - | - |
| ARR-weighted avg health score | XX | YY | +/- |
| Accounts with z < -2 (anomaly) | X | - | alert |
| Accounts with concentration >60% | X | - | flag |
| Active multi-threading plays | X | - | - |
| Active competitive defense sequences | X | - | - |

## Pipeline Health (Per-Account)
| Account | Status | Leading | Lagging | Context | Composite Band | Flag |
|---------|--------|---------|---------|---------|---------------|------|

## This Week
- Accounts touched: X/Y
- Outreach sent: N
- Calls completed: N
- Objections logged: N
- Expansion signals: N

## Patterns
- [Pattern observed across accounts]

## Next Week Focus
1. [Account] — [why and what to do]
2. [Account] — [why and what to do]

## Open Risks
- [Risk and recommended action]

STATUS: DONE | DONE_WITH_CONCERNS
```

## Step 8: Task Execution Health

Read `memory/task-registry.jsonl` and `memory/analytics.jsonl` (filter for `task_*` events this week) to assess scheduled task reliability.

### Output Format

```
## Task Execution Health
| Task | Runs | Successes | Failures | Avg Duration | MCP Issues |
|------|------|-----------|----------|-------------|------------|

### MCP Reliability
| MCP | Success Rate | Failures | Circuit Breaker? |
|-----|-------------|----------|-----------------|

### Pending Outputs (Unresolved >48h)
| Output | Source Task | Created | Age | Action Needed |
|--------|-----------|---------|-----|--------------|

### Task Observations
- [Patterns in failures — same MCP? same time? same task?]
- [Dedup triggers — are tasks creating redundant outputs?]
- [Data freshness gaps — which data sources went stale this week?]
```

If no task-registry.jsonl data exists yet, note "Task coordination tracking not yet active" and skip.

## Step 9: Update Active Context

After the retro, update `memory/active-context.md`:
- Roll "This Session" to "Previous Session"
- Update priorities based on retro findings
- Update pipeline table with any stage changes
- Add new action items from retro recommendations
