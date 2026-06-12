# Accretive Knowledge

The system is designed so every session leaves Claude smarter than it found it. Four files (and a set of patterns around them) carry context forward. Nothing is generated twice, nothing is re-researched unnecessarily.

## The four accretive stores

### `accounts/*.md` — per-account findings

Every research session appends to the relevant account file: new findings, stakeholders, pain points, competitive context, objection history, call debriefs.

Impact: the fourth research session on ACME Bank is 5× faster than the first because the Layer 1 and Layer 2 context is already there. Claude can start at Layer 3 — first-principles observations — instead of re-deriving the basics.

### `memory/handoff.jsonl` — cross-session log

Scheduled tasks and interactive sessions both write one-line summaries here on completion. Reading the last 20 lines at session start gives you hours of prior work in seconds.

Example entries:

```json
{"source":"gong-pipeline-sync","ts":"2026-04-14T17:08:00Z","action":"pipeline_synced","details":"Account_F TM API CLOSED LOST -$170K; Account_A Vendor_X CLOSED LOST -$125K; Account_E CIB CLOSED WON +$873K"}
{"source":"interactive","ts":"2026-04-20T13:05:00Z","action":"session_summary","details":"S-020: unblocked stale .git/index.lock, shipped hooks/git-safe.sh (fb8df2a)"}
```

No session rediscovers pipeline changes from Gong. Claude just reads what the sync task already did.

### `memory/analytics.jsonl` — pattern data

Every framework use, research session, outreach draft, objection, expansion signal — logged as one JSON line.

Impact: the weekly retro mines this. Patterns that would be invisible in any single session (e.g. "objection pattern X appeared across 4 accounts this week") surface because the data is there to find.

### `knowledge/*.md` — institutional knowledge

Banking strategy, product capabilities, Glean usage patterns, communication playbook, MCP positioning. Captured once, reused every session.

Impact: one-time cost, permanent benefit. The banking strategy file was written once and has now been read into ~25 sessions. That's 25 sessions that started with Layer 2 industry context instead of Claude's generic training defaults.

## The compounding effect

Each source individually is useful. Together they compound:

- `accounts/Account_A.md` references a call debrief from three weeks ago
- That debrief cites an objection logged in `analytics.jsonl`
- That objection has a response in `frameworks/objections.md` (which accumulates as patterns emerge)
- The response cites a proof point from `knowledge/domain-strategy.md`
- All of this surfaces in today's outreach draft in ~2 minutes

Without accretion: Claude generates an outreach email from generic training. With it: Claude generates an email that references the 3-week-old call, addresses the objection that's now logged across 4 accounts, and cites the proof point that has landed in similar conversations at peer banks.

## Three-session lookback

`memory/active-context.md` carries exactly three sessions forward, then archives. The structure:

- **This Session** — what happened in the session that just ended.
- **Previous Session** — one ago.
- **Two Sessions Ago** — two ago.

On session end, sessions roll forward (Previous → Two Ago, This → Previous, new → This). Anything older than three sessions moves to `memory/active-context-archive.md`.

Why three? Fewer and important context falls off too fast. More and the file becomes a graveyard Claude can't actually reason about. Three sessions maps to roughly a work-week of context at typical cadence.

## What isn't accretive

- **Pipeline state.** SFDC is the source of truth for deal state. The `gong-pipeline-sync` task refreshes into Notion + active-context every weekday at 5:08 PM. Don't rely on active-context as a pipeline authority — rely on it as a workspace view of what was true at the last sync.
- **Contact information.** Notion is the editable layer. Don't accumulate contact data in `accounts/*.md` — write it to the shared Notion databases.
- **Pending drafts.** Gmail drafts created via `gmail_create_draft` live in Gmail, not the repo. Claude logs the draft ID to `analytics.jsonl` for later reference.

Accretion is for findings, patterns, and institutional context — not for live state.

## See also

- [The Preamble](the-preamble.md) — how the accretive stores get loaded at session start.
- [ARCHITECTURE.md → Accretive Knowledge Model](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/ARCHITECTURE.md) for the fuller treatment.
