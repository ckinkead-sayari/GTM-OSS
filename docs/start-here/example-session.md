# An Example Session, End to End

The fastest way to understand the system is to watch one session run the full loop: preamble → research → outreach → debrief → end-session. Everything below is **fictional** (same cast as `accounts/EXAMPLE-northwind-insurance.md`: you're an AM at "Acme Analytics" selling ClaimSight, a claims-fraud analytics platform; the account is Northwind Insurance) — but the mechanics, hook outputs, and log lines are exactly what the system produces.

---

## 1. Session start — the digest fires before you type anything

The SessionStart hook prints, automatically:

```
=== claudeGTM session-start digest — 2026-02-12 09:04 EST ===
CONFIG CHECK PASSED — all required fields configured.
MCP CHECK — 4 ok
Git: branch main, 0 uncommitted path(s)
STALE: 1/4 account files >30d untouched — debriefs/research must append to accounts/<name>.md
TODOS.md: 2 P0 item(s).
Next: run the full preamble (frameworks/preamble.md) ...
```

Claude then runs the preamble: pulls git, loads `memory/active-context.md` (priorities, pipeline), the last 20 handoff lines, mints a session ID (`S-014`), logs `session_start`, and announces:

> S-014 open. Priorities from last session: (1) Northwind seat expansion — Dana confirms headcount in March planning; (2) renewal prep opens 2026-03-02. Flag: the claims-ops pilot seats have been dormant 6 weeks — that's the expansion blocker, not a footnote. What are we working on?

Note that the flag came unprompted — that's Non-Negotiable #8 (see something, say something).

## 2. You ask for outreach — and the system refuses to draft first

**You:** "Draft an email to Priya Raman about the workflow integration demo."

Claude does **not** start writing. Two gates fire first:

**Research gate.** External research before any account-specific draft (Non-Negotiable #2). Claude runs web search: Northwind's new COO named "claims cycle time" as metric #1 in a town hall two days ago. That changes the email's framing — cycle time, not fraud catch-rate. The finding is appended to the dossier's Activity Log and logged:

```json
{"ts":"2026-02-12T14:21:00Z","session_id":"S-014","event":"account_research","details":"Northwind: COO town hall 2026-02-10 — cycle time is metric #1; DOI exam Q3 confirmed. Reframe for Priya."}
```

**Warm-path check.** Before drafting cold (Non-Negotiable #3), Claude checks email history: Priya replied warmly to Dana's forwarded one-pager three weeks ago. So this is a warm follow-up referencing that thread — not a cold pitch.

## 3. The draft — and the quality gate catching a violation

First attempt (internal):

> Subject: Northwind's claims cycle time
> Priya — when Dana shared our Q4 results you mentioned the consolidation review. One thing that didn't come up: referrals currently arrive outside your adjusters' queue, which is why two of your four pilot seats went quiet. We've built a seamless integration into the adjuster workflow…

The PreToolUse hook **blocks the draft** before it reaches the email tool:

```
[check-outbound-quality] BLOCKED: banned term "seamless" (marketing fluff).
Rewrite in consultant tone. See frameworks/document-quality.md.
```

Claude rewrites — specific, no fluff, 4 sentences, ends with a low-friction ask:

> Subject: Northwind's claims cycle time
>
> Priya — when Dana shared our Q4 results, you flagged the consolidation review; fair, and worth a sharper look at one detail first. Two of your four claims-ops seats went quiet in January, and the reason is mechanical: ClaimSight referrals land outside the adjuster queue, so acting on them costs a context switch. We can route referrals directly into the existing adjuster workflow — your team would see them where they already work, which is also the shortest path to the cycle-time number your new COO put on the board. Worth 20 minutes to see it against your own January claims?

The draft is created in your email tool's Drafts folder — **never sent**. You review and send. Two more log lines:

```json
{"ts":"2026-02-12T14:38:00Z","session_id":"S-014","event":"framework_used","details":"outreach.md + document-quality.md + communication-playbook.md applied (Priya/Northwind warm follow-up)"}
{"ts":"2026-02-12T14:39:00Z","session_id":"S-014","event":"outreach_drafted","details":"Northwind/Priya — workflow-integration demo ask, cycle-time framing"}
```

## 4. After your call — the debrief that actually persists

Later, you say: "debrief the Priya call — she wants the demo, but procurement needs it before March 20."

Claude runs the 7-point debrief from `frameworks/call-debrief.md` and — this is the part that compounds — **appends it to the dossier**, because a debrief that lives only in chat history is gone by next week (Non-Negotiable #6):

```markdown
### 2026-02-12 — call debrief (S-014)

Priya call (25 min). Demo agreed: week of 2026-03-09, her team + Marcus invited.
Forcing function surfaced: consolidation review closes March 20 — demo must land
before it. New stakeholder: warehouse integration owned by "the data platform
group" — name TBD (discovery agenda). Next actions updated.
```

…plus `call_debriefed` in analytics, and the pipeline table in `active-context.md` gets the new date.

## 5. End session — nothing strands

**You:** "end session."

Claude executes `/end-session`: rolls `active-context.md` forward (this session's work becomes "previous session"), updates action items, logs `session_end` with the same `S-014` id, appends one handoff line, commits with a descriptive message, pushes:

```
session end: S-014 — Northwind COO research, Priya warm follow-up drafted,
call debriefed (demo wk 3/9, procurement deadline 3/20), dossier + pipeline updated
```

Next session's preamble reads all of it back in. Nothing was lost; the dossier got richer; the retro on Friday will mine the four analytics events this session produced.

---

## Why this matters

Run that loop 3–4 times a week and the system's value stops being the drafting — it's that **Claude argues with you from your own accumulated evidence**: the dormant seats, the COO's metric, the procurement deadline. That's what a fresh chat can never do.

Now run `/bootstrap` and build yours. Then work one real account through this exact loop.
