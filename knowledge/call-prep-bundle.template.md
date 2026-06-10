# Call Prep Bundle

**Purpose:** consolidated checklist Claude loads before any external call. Combines domain knowledge + product capabilities + account-specific context + discovery hygiene into a single pointer, so call prep doesn't require hunting across 5 files.

**Who reads this:** Claude, when you say "prep me for my call with [account]".

---

## 1. Read these first (always)

- `knowledge/domain-summary.md` — what the industry cares about, what's driving spend
- `knowledge/product-capabilities.md` — what the product actually does today
- `knowledge/communication-playbook.md` — your voice, so the follow-up sounds like you

## 2. Account-specific context

- `accounts/[account].md` — everything known about this account (layer 1 / 2 / 3 findings)
- `memory/handoff.jsonl` — last 20 lines for any recent scheduled-task context on this account
- Recent Gmail threads with the contact(s) attending — check before the call, not after

## 3. Attendees

For each attendee, pull and skim:

- Their LinkedIn (check for job changes in the last 6 months)
- Any prior call debriefs in `accounts/[account].md`
- Their role's typical concerns per `knowledge/domain-summary.md` persona framing

## 4. Current account state

Pull live:

- Pipeline state (open deals, stages, close dates) — from your CRM / deal tracking layer
- Usage state (if product is instrumented) — from your product analytics layer
- Health score (if you have one) — from your CS / analytics layer
- Open action items from last touch — from `accounts/[account].md` or Notion

## 5. Discovery hygiene

Every external call should surface or verify answers to:

1. **What's their current process for [the problem area]?**
2. **What's broken about it?** (coverage gaps, speed, cost, accuracy)
3. **Who else is involved in the decision?**
4. **What would "good" look like?**
5. **What's the cost of doing nothing?**
6. **Is there a deadline or forcing function?**

Gaps in what you know = your discovery agenda for this call.

## 6. Health briefing checklist (if this is an existing customer)

For CS / renewal / expansion calls, also load:

- **Leading indicators** — recent activity trajectory (logins, product usage, feature adoption)
- **Lagging indicators** — renewal signals, NPS, support ticket trends
- **Context** — contract dates, exec sponsor state, recent changes at the account
- **Cross-threaded relationships** — concentration risk (% of usage from N users), multi-threading state

## 7. After the call

1. Run `frameworks/call-debrief.md` — 7-point structure captures what happened
2. Append debrief to `accounts/[account].md`
3. Log any objections to `memory/analytics.jsonl` (so the retro can spot patterns)
4. Log any expansion signals to `memory/analytics.jsonl`
5. Draft the follow-up email using `knowledge/communication-playbook.md` + `frameworks/outreach.md`
6. Update `memory/active-context.md` with new next steps

## See also

- `frameworks/call-debrief.md` — what happens after the call
- `frameworks/expansion.md` — expansion signal detection (customer calls)
- `frameworks/objections.md` — objection logging
