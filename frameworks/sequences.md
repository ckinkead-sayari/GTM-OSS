# Outbound Sequence Framework

## Purpose

Multi-touch outreach sequences for contacts who are not current customers or haven't been engaged. Each sequence type has a defined cadence, messaging arc, and exit conditions.

## Sequence Types

### Cold Outbound (5 steps, 21 days)

For contacts at target accounts with no prior relationship. Grounded in domain-strategy.md pain points.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Research-led intro — lead with their specific problem | 4 sentences. Their pain + evidence you understand it. No pitch. |
| 2 | 3 | Value insight — share a relevant data point or regulatory trend | 3-4 sentences. Link to something useful (not a [YOUR_PRODUCT] asset). |
| 3 | 7 | Proof point — a Tier-1 reference bank PoC, 73.9% FP reduction, or relevant case | 4-5 sentences. Specific outcome at a peer institution. |
| 4 | 14 | Trigger event — reference something recent (enforcement, earnings, hire) | 3-4 sentences. Show you're paying attention to their world. |
| 5 | 21 | Breakup — honest close, leave the door open | 3 sentences. "I'll stop reaching out, but if X changes, happy to talk." |

Exit conditions: Reply received → mark Replied, stop sequence. Bounce → mark Bounced. No reply after step 5 → mark Completed, add to re-engagement list for 90 days later.

### Warm Reactivation (3 steps, 14 days)

For contacts you've spoken to before but the conversation went cold. Check Gong/Gmail for prior context.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Reconnect — reference last conversation, share what's changed since | 4 sentences. "Last time we spoke about X. Since then, Y happened." |
| 2 | 5 | Insight share — new capability, regulatory development, or peer outcome | 3-4 sentences. Something genuinely useful, not a product update email. |
| 3 | 14 | Direct ask — propose a specific 20-minute call with a clear agenda | 3 sentences. Specific date/time suggestion. |

Exit conditions: Same as cold. Prior context from Gong/Gmail must be referenced in step 1.

### Event Follow-Up (3 steps, 10 days)

For contacts met at conferences, webinars, or events. The lead-response-scanner often catches these.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Same-day follow-up — reference the specific conversation or session | 3-4 sentences. "Great meeting you at [event]. You mentioned X." |
| 2 | 3 | Value add — send something relevant to what they discussed | 3-4 sentences. Article, case study, or data point tied to their interest. |
| 3 | 10 | Meeting ask — propose a focused call on their specific use case | 3 sentences. Specific and low-commitment. |

Exit conditions: Same as cold. Must reference the specific event and conversation.

### Renewal Prep (4 steps, 120→30 days before renewal)

For existing customers approaching contract renewal. Triggered automatically when Renewal Date is within 120 days.

| Step | Day | Timing | Purpose |
|------|-----|--------|---------|
| 1 | 0 | 120 days out | Internal prep: pull usage report, identify expansion opportunities, assess health score |
| 2 | ~30 days | 90 days out | Champion touch: "Let's get ahead of the renewal. Here's what your team has accomplished." |
| 3 | ~60 days | 60 days out | Business case refresh: updated ROI, new use cases, expansion proposal if warranted |
| 4 | ~90 days | 30 days out | Procurement nudge: "Want to make sure this doesn't lapse. Who should I connect with on your side?" |

Exit conditions: Renewal signed → Completed. Churning → escalate, switch to Churn Intervention.

### Expansion (3 steps, 14 days)

For existing customers showing expansion signals: new business unit interest, usage spikes, new users.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Signal acknowledgment — "Noticed your team in [new area] started exploring X" | 4 sentences. Lead with the signal, not the upsell. |
| 2 | 5 | Use case mapping — how the new area connects to what they already use | 4-5 sentences. Specific workflow for the new use case. |
| 3 | 14 | Meeting ask — propose a call with the new stakeholder | 3 sentences. Offer to include their existing champion. |

Exit conditions: Meeting booked → Completed. No response → Paused for 30 days, then retry.

### Competitive Defense (3 steps, 7 days)

Triggered when `gong-pipeline-sync` detects a competitor mention (Quantexa, LSEG, Moody's, LexisNexis, Encompass, D&B) in a Gong transcript for a key account. Speed matters — competitor POCs move fast.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Champion reinforcement — address the competitor directly. Pull differentiators from `knowledge/domain-strategy.md`. Surface a relevant proof point. | 4-5 sentences. "I heard [Competitor] came up. Here's what our customers typically find when they compare: [specific differentiator]. [Proof point from a Tier-1 reference bank/similar bank]." |
| 2 | 3 | Value summary — specific to what they already use, quantified. Not generic. Show switching cost. | 4-5 sentences. "Your team has built [X graphs/resolved Y cases/exported Z analyses] in [YOUR_PRODUCT]. Here's what that would look like to rebuild." |
| 3 | 7 | Executive engagement — if no response, escalate internally. [YOUR_PRODUCT] leadership reaches out to account sponsor. | Internal escalation, not email to customer. Flag to [YOUR_PRODUCT] leadership: "[Account] has active competitor evaluation. Champion not responding. Need exec-to-exec." |

Exit conditions: Champion confirms [YOUR_PRODUCT] retained → Completed. Active POC confirmed → escalate to exec engagement + urgent competitive battle plan. No response after step 3 → flag as HIGH churn risk.

**Key rule:** Never badmouth the competitor. Lead with what makes [YOUR_PRODUCT] different (data breadth, 10.6B records, ownership structures, regulatory coverage), not what's wrong with the alternative.

### Early Warning Outreach (2 steps, 10 days)

Triggered when Leading Score declines (z < -1) while Lagging Score remains stable. This catches adoption slowdown before it shows up in volume — the earliest possible signal that value perception is eroding.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Proactive check-in — "I noticed your team hasn't explored [feature they stopped using]. Wanted to share how [peer bank] uses it for [use case]." | 3-4 sentences. Helpful, not alarming. Position as training/optimization, not concern. |
| 2 | 10 | Offer structured training — "I'd like to run a 30-minute session for your team on [under-adopted features]. [Peer bank] found it increased their investigation speed by X." | 3-4 sentences. Specific training proposal tied to their unused features. |

Exit conditions: Feature breadth recovers (Leading Score z > 0) → Completed. No response + Lagging starts declining → escalate to Churn Intervention.

### Churn Intervention (3 steps, 7 days)

Emergency sequence for accounts with Critical or High churn risk. Fast cadence.

| Step | Day | Purpose | Email Style |
|------|-----|---------|-------------|
| 1 | 0 | Champion call — reach out to primary contact, understand what's changed | Direct call/email. "I noticed X — wanted to check in directly." |
| 2 | 2 | Value reinforcement — usage summary showing what they'd lose | 4-5 sentences with data. Specific workflows that would break. |
| 3 | 7 | Executive escalation — involve [YOUR_PRODUCT] leadership if no response | Internal escalation + senior-level outreach from [YOUR_PRODUCT] side. |

Exit conditions: Engagement restored → Completed. No response → Escalate to leadership.

## Messaging Rules (Apply to ALL sequences)

1. Read `knowledge/communication-playbook.md` before drafting any email
2. Read `knowledge/domain-strategy.md` for pain points, proof points, and positioning
3. Lead with THEIR problem, not our product
4. 4-6 sentences max per email. Subject line includes their company name.
5. No banned language — see full list in `frameworks/document-quality.md` (includes extended AI vocabulary ban)
6. No generic CTAs. Every email ends with a specific, low-friction next step.
7. Research the contact and account BEFORE drafting step 1
8. Reference prior interactions if they exist (Gong, Gmail, meetings)
9. All drafts via `gmail_create_draft` — NEVER auto-send
10. Run against the 24-pattern AI detection rubric in `frameworks/document-quality.md` — target 90+

## Cold Email Copy Rules

### First Sentence

**NEVER start with:** "I", "We", "Our team", "I wanted to", "Hope this finds you well", "My name is..."

**ALWAYS start with one of:**
- Their company name — "{{Company}}'s recent..."
- A specific market observation — "Most [vertical] firms we talk to are..."
- A specific finding — "Your [blog post / LinkedIn post / job listing] on..."
- A relevant trend — "Since [event] happened in [sector]..."

The first sentence earns the second. If it doesn't make the prospect think "relevant," the email is dead.

### Body Length by Step

| Step | Max Sentences | Notes |
|------|--------------|-------|
| Step 1 | 3 sentences | Open + value + CTA. That's it. |
| Steps 2-4 | 3-5 sentences | Add new angle or asset, not a repeat |
| Step 5 (bump) | 1-2 sentences | "Still relevant?" style |
| Breakup | 2-3 sentences | Leave value, don't close your file |

### CTAs by Stage

**Soft asks (Steps 1-3, preferred):**
- "Worth a look?"
- "Want the data?"
- "Does this match what you're seeing?"
- "Relevant to what you're working on?"

**Direct asks (Steps 4+ only, if engagement signals exist):**
- "Would a 20-minute call make sense to walk through this?"
- Soften even these — never "Book a call with me" or "Are you free Thursday?"

### Links

- **Step 1:** No links (deliverability + trust)
- **Steps 2-3:** Max 1 link, only if genuinely useful (case study, report). Never a landing page with a form.
- **Breakup:** Include 1 real link to genuinely useful content
- **Never:** Hallucinate URLs. All links must be verified before use.

### Stats & Social Proof

**Use observation framing:** "Most banks we audit are leaving 30-40% of their adverse media alerts unresolved."
**Not study framing:** "According to our data, 73% of banks have this problem."

Observation sounds like earned experience. Study framing sounds like a marketing claim. Never fabricate specific client names, revenue numbers, or case study specifics you can't verify.

### Subject Lines

- 3-7 words. No exclamation points. No all-caps. No emoji for B2B.
- Include their company name or a specific reference
- Best patterns: question, observation, specificity, intrigue

### Breakup Email

Leave something genuinely useful — a real article, report, or framework. Not "closing your file" (manipulative negative framing).

### Tone

Peer-to-peer, not vendor-to-prospect. Curious, not desperate. Specific, not generic. Short, not comprehensive. Human, not corporate. If it sounds like a marketing email, rewrite it.

## Cadence Rules

- Never send two sequence emails to the same account on the same day
- If a contact replies to any step, mark the sequence as Replied and STOP
- If YOUR-NAME manually reaches out to a contact in a sequence, pause the sequence and note it
- Business days only — Next Touch Date must be Monday-Friday
- Respect timezone: EMEA contacts should receive emails during their business hours

## Health Score → Sequence Type Mapping

Uses the **lower bound** of the ±8 confidence band (conservative — avoids false triggers from noisy data). See `ARCHITECTURE.md` Health Score Model for full three-component scoring methodology.

| Condition | Auto-Trigger | Score Component |
|-----------|-------------|----------------|
| Lower band < 30 + renewal within 180 days | Churn Intervention (7d emergency cadence) | Composite |
| Lower band < 50 + renewal within 120 days | Renewal Prep (accelerated) | Composite |
| Renewal within 120 days + lower band > 50 | Renewal Prep (standard) | Composite |
| Leading Score declining (z < -1) + Lagging stable | Early Warning outreach (proactive check-in) | Leading |
| Usage spike + new users in different business unit | Expansion | Lagging (user growth sub-metric) |
| Concentration risk > 60% + no active multi-threading play | Multi-Threading Play (`frameworks/multi-threading.md`) | Lagging (concentration sub-metric) |
| Competitor mentioned in Gong transcript | Competitive Defense (champion reinforcement) | Context (competitive sub-metric) |
| Contact from event with no follow-up within 48 hours | Event Follow-Up | N/A |
| New contact at target account, no prior relationship | Cold Outbound | N/A |
| Prior contact gone cold > 60 days | Warm Reactivation | N/A |

**New trigger types added:** Leading Score early warning (catches declining adoption before usage drops), multi-threading play (converts concentration detection into systematic action), competitive defense (responds to competitor POC signals from Gong extraction).

## Notion Sequences DB

**Collection ID:** `collection://[YOUR_UUID]`

Properties: Sequence Name (title), Contact (relation), Account (relation), Sequence Type, Current Step, Total Steps, Status, Next Touch Date, Last Touch Date, Reply Received (checkbox), [YOUR_PRODUCT] Owner, Notes.

The `outbound-sequence-engine` scheduled task reads this DB daily, executes due steps, and advances state.
