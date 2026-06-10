# Scheduled Tasks Reference

Full detail on the scheduled-task catalog. Load only when debugging a task or investigating its behavior.

**Current operating state (verified 2026-06-10, S-036):** 4 enabled — `daily-gtm-briefing` Mon ~10:23, `pipeline-staleness-check` Wed ~10:01, `mixpanel-usage-sync` Wed ~13:06, `weekly-gtm-retro` Fri ~11:08. 5 manual-only (run on demand): `external-call-prep`, `lead-response-scanner-pm`, `outbound-sequence-engine`, `renewal-tracker`, `gong-pipeline-sync`. `lead-response-scanner-am` was removed from the scheduler (its SKILL dir remains). The per-task descriptions below document full behavior regardless of cadence.

## Execution model

All tasks run as **Local scheduled tasks** via the Claude Code Desktop app. Desktop app must be open and Mac awake for tasks to fire. If the Mac is asleep at the scheduled time, that run is skipped. All tasks start at 9AM or later to ensure the machine is on.

To manage: use `mcp__scheduled-tasks__list_scheduled_tasks` / `update_scheduled_task`, or the Desktop app sidebar under "Scheduled". Outputs post to the Slack DM channel in `.claude/MY-CONFIG.md`.

## Task table

| Task | Schedule | What It Does |
|------|----------|-------------|
| `mixpanel-usage-sync` | Weekdays ~9:06 AM | **Step 0 — Product type check**: Read Notion Accounts DB `Product Type` field. Skip Mixpanel queries for Data File accounts (Account_Q, Account_J, Account_O) — score them on Context only (see ARCHITECTURE.md Data File section). **Step 1 — Cross-BU aggregation**: For each Graph/Hybrid account, query Mixpanel using `$account contains "{root name}"` (per MY-CONFIG.md Account Name Mapping table) to capture ALL BU variants. Never use `equals` — use `contains`. **Step 2 — Three-component health scoring** (Graph/Hybrid accounts only): (1) **Leading Score** — feature breadth (distinct event types / total), user growth (net new active users), session depth trend (EWMA), time-to-value for new users. (2) **Lagging Score** — weighted event volume (events × value weight per Event Value Weights table), active users (excluding `$deprovisioned`), concentration risk %, usage trend (EWMA λ=0.3 vs 90d baseline, z-score). (3) **Context Score** — renewal proximity, MEDDPICC completeness, deal stage velocity, competitive/qualitative signals. **Composite** = Leading×0.35 + Lagging×0.45 + Context×0.20, reported as ±8 confidence band. **Step 3 — Data quality gates**: (a) flag if weighted events >3× EWMA as potential overcounting (Account_M-pattern), (b) exclude `$deprovisioned` users from all counts, (c) flag 0-event Graph customers as pipeline break not churn, (d) check for `$account = "undefined"` users whose `$email` domain matches key account domains — flag for attribution correction. **Z-score anomaly detection**: z<-2 = significant drop alert, z>2 = spike investigation. **State-change alerting**: only alert on tier changes (not stable states). Alert format: `[Account] [OLD→NEW]: What changed | Why it matters | Action`. **Churn Risk** uses lower confidence band: Critical (<30 + renewal <180d), High (30-49 + EWMA declining z<-1), Medium (50-64 + declining or renewal <120d), Low (65+ stable/improving). Updates Notion: Health Score, Leading Score, Lagging Score, Context Score, Churn Risk, EWMA Baseline, Feature Breadth, User Growth, Concentration %, Lifecycle Stage, 30d Weighted Events, Usage Trend (top 5 users). Posts to Slack with narrative format. |
| `daily-gtm-briefing` | Weekdays ~9:23 AM | Morning standup: GCal MCP (calendar) + Gmail MCP (key emails) + Mixpanel MCP (overnight usage alerts) + Glean `chat` (overnight activity digest) + **State-change health alerts** (only accounts that changed tier since yesterday — narrative format: what changed, why, action) + **Z-score anomaly alerts** (accounts with z<-2 significant drops) + **Stable-state summary** (one-line per account for non-changing accounts) + **Renewal reminders** (Urgent/Active/Planning) + **Sequence activity** (due touches, replies, paused) + **Multi-threading alerts** (accounts with concentration >60% that haven't started the multi-threading playbook) + active-context + TODOS |
| `external-call-prep` | Weekdays ~9:34 AM | GCal MCP for external meetings → match to accounts → Mixpanel MCP for fresh usage → Glean for SFDC/Gong/Drive context → Glean for Notion product knowledge (PRDs, roadmap) → Glean for Jira feature status → stakeholder mapping → posts structured call prep to Slack |
| `lead-response-scanner-am` | Weekdays ~9:48 AM | Gmail MCP (`gmail_search_messages` for LeanData notifications from `leandata@[your-company].com`) → **Mixpanel active user check** (skip outreach if lead has events in 30d) → **ICP relevance check** (skip if wrong persona) → Glean for lead enrichment → **dedup check against Notion Contacts DB** → `gmail_create_draft` for qualifying non-active leads only → creates/updates contacts in Notion, alerts on Slack. Monday AM looks back to Friday (covers weekends). |
| `lead-response-scanner-pm` | Weekdays ~3:08 PM | Same as AM scanner but covers leads since morning run. 6-hour lookback window. |
| `outbound-sequence-engine` | Weekdays ~10:05 AM | Reads Notion Sequences DB for due steps → checks for replies before sending → researches account context → drafts emails via `gmail_create_draft` → advances sequence state → suggests new sequence candidates (paused for approval) |
| `gong-pipeline-sync` | Weekdays ~5:08 PM | Glean MCP: SFDC opportunities + contacts + Gong transcripts → **enriches Notion Contacts from SFDC** (dedup, create/update) → **tracks Last Contacted via Gmail/Gong** → **updates Last Touch on Accounts** → multi-threading assessment → **competitive intelligence extraction** (scan Gong transcripts for mentions of Quantexa, LSEG, Moody's, LexisNexis, Encompass, D&B — update Competitor Mentions counter on Notion Accounts, apply Context Score penalty) → **qualitative sentiment extraction** (positive: expansion interest, champion advocacy; negative: frustration, budget concerns, exec sponsor changes — feed into Context Score qualitative sub-metric) → updates Notion + pipeline table, posts to Slack |
| `renewal-tracker` | Manual-only | Scans Notion Accounts for Renewal Date → categorizes urgency (Critical 0-30d, Urgent 31-60d, Active 61-90d, Planning 91-120d) → **contract-terms awareness (fields added S-036, 2026-06-10):** read `Auto-Renewal` (Yes/No/Unknown), `Notice Period (days)`, `Price Cap %`, `Price Change Window (days)` on each account. For auto-renewing contracts the binding deadline is **Renewal Date − Notice Period** (the non-renewal window), not the renewal date itself — alert on THAT date. Flag accounts where Auto-Renewal = Unknown as data gaps to fill. → generates renewal prep docs → auto-triggers Churn Intervention and Renewal Prep sequences → posts reminders to Slack |
| `pipeline-staleness-check` | Wednesday 10:00 AM | Mid-week hygiene: Glean cross-source activity verification + Mixpanel z-score anomaly check (flag z<-2 accounts for investigation) + multi-threading risk scan (flag >60% concentration accounts without active multi-threading playbook per `frameworks/multi-threading.md`) + competitive mention monitoring + **surprise non-renewal detection** (unknown renewal date + declining usage + no exec engagement in 60d → flag as silent churn risk) + **API vs human event audit** (flag accounts where >50% of events are API-generated, as health score should primarily reflect human usage) |
| `weekly-gtm-retro` | Friday 4:00 PM | Full retrospective: pipeline health (Leading/Lagging/Context decomposition per account), Mixpanel WoW trends (EWMA-based, z-score flagged), Glean weekly synthesis, multi-threading trends + playbook execution status, account plan freshness, competitive intel (from gong-pipeline-sync extraction), next-week focus + **Health Score Accuracy Review** (which accounts changed tier? were changes validated by outcomes? did interventions work? log `health_outcome` events to analytics.jsonl) + **Weight calibration check** (after 60d: correlate component scores with actual outcomes) |

## Current cadence

**Weekly:** briefing Mon ~10:23 → staleness check Wed ~10:01 → Mixpanel sync Wed ~13:06 → retro Fri ~11:08. Everything else is manual-only — the original staggered daily flow (sync → briefing → call prep → lead scans → sequences → pipeline sync) was retired ~May 2026 as more cadence than the workflow needed; the schedules in the task table are historical defaults for anyone re-enabling.

## Weekly flow

Renewal tracker Monday ~10:23 → pipeline staleness check Wednesday ~10:01 → weekly retro Friday ~4:08.

## Shared inputs

Tasks read from `memory/active-context.md`, `TODOS.md`, `memory/analytics.jsonl`, `accounts/`, and the Notion databases to produce their outputs. The retro saves its output to `memory/retros/retro-YYYY-MM-DD.md`.

## Shared protocols

See `frameworks/task-preamble.md` for the coordination boilerplate (git sync, handoff logging, retry, trace logging) that ALL scheduled tasks follow.

## Native MCPs used

- Mixpanel MCP: project/workspace IDs per MY-CONFIG.md, account property `$account`
- Gmail MCP: `gmail_search_messages`, `gmail_read_message`, `gmail_create_draft`
- GCal MCP: `gcal_list_events`, `gcal_get_event`
- Glean MCP: `search` (with app filters), `chat`, `read_document`

## Notion databases

- **Accounts** — Product Usage, 30d Weighted Events, Usage Trend, Health Score (composite ±8 band), Leading/Lagging/Context Scores, Churn Risk, EWMA Baseline, Feature Breadth, User Growth, Concentration %, Lifecycle Stage, Competitor Mentions, Renewal Date, Last Gong Sync, Last Mixpanel Sync
- **Deals** — stages, amounts, risk flags, account relations. Updated by Gong sync.
- **Contacts** — auto-enriched from SFDC by gong-pipeline-sync; Last Contacted auto-tracked from Gmail + Gong; dedup enforced by lead-response-scanner.
- **Sequences** — multi-touch outreach. Executed by outbound-sequence-engine daily; fed by renewal-tracker (auto-creates Renewal Prep + Churn Intervention sequences).
