# Account Dossier Framework

Per-account research files in `accounts/<lowercase-name>.md` are the system's compounding asset — every session that learns something about an account appends it here, so the next session starts warm instead of re-deriving context from CRM/Gong/email.

**Why this framework exists:** the accretive knowledge model failed silently in Q2 2026 — 12 of 15 account files went untouched from Apr 2 to Jun 10 while dozens of calls, debriefs, and research sessions happened. Knowledge stayed in active-context (which rolls off after 3 sessions) or in chat history (which evaporates). The fix is a hard rule, not good intentions.

## Rules

1. **One file per account**, named `accounts/<lowercase-name>.md` (e.g. `Account_A.md`, `Account_K-amro.md`).
2. **Append, don't rewrite.** The Activity Log is append-only with dated entries, newest first. Other sections are living state — update in place.
3. **Every call debrief ends with an append.** The debrief workflow (`frameworks/call-debrief.md`) is not DONE until the account file has a dated Activity Log entry and refreshed sections.
4. **Every account research session ends with an append.** Same rule for research (`account_research` analytics events should correlate with account-file commits).
5. **Touch the `Last updated:` header every time.** The session-start digest flags files >30 days old — that flag means rules 3–4 are being violated.

## Template

```markdown
# [Account Name]

**Last updated:** YYYY-MM-DD (S-NNN)
**AE/AM:** | **CSM:** | **Current ARR:** | **Health:** GREEN/YELLOW/RED (score, date)

## Snapshot

Two-3 sentences: where this account is right now, the defining dynamic, and the single most important next move.

## Stakeholder Map

| Name | Role | Buying Center | Stance | Last Touch | Notes |
|------|------|---------------|--------|------------|-------|
| | | | Champion / Supporter / Neutral / Blocker / Unknown | YYYY-MM-DD | |

## Active Deals

| Deal | Stage | ARR | Close | Forecast | Next Step |
|------|-------|-----|-------|----------|-----------|

## Usage Signal

Latest Mixpanel read: active users, events 30d, concentration risk, trend. Date the data.

## Competitive Presence

Known competitor footprint, displacement risk, counter-positioning in play.

## Regulatory Hooks

Which drivers bite this account (AMLR, DORA, FCA, FinCEN, fraud-to-sanctions) and which buying center owns each.

## Layer 1 — Public Knowledge

Annual reports, press, enforcement actions, leadership changes.

## Layer 2 — Industry Context

Peer behavior, regulatory trends affecting their segment, market position.

## Layer 3 — First-Principles Insight

Original observations that are not written anywhere else. This is where value compounds.

## Activity Log (append-only, newest first)

### YYYY-MM-DD — [call / email thread / research / debrief] (S-NNN)
- What happened, what was learned, what changed.

## Objections Heard

Log per `frameworks/objections.md` — date, persona, objection, response used, outcome.

## Open Questions / Discovery Agenda

Gaps in what we know = the agenda for the next conversation.

## Next Actions

- [ ] Dated, owned, specific.
```

## Migration note (existing files)

Existing `accounts/*.md` files don't need to be rewritten to this structure wholesale. Adopt incrementally: on the next touch of each account, add the missing sections (Activity Log at minimum) and the `Last updated:` header, then append going forward.
