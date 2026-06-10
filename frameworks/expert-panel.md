# Expert Panel Quality Gate

Recursive scoring loop for prospect-facing content. Assembles domain-relevant experts, scores against rubric, iterates until 90+. Max 3 rounds.

## When to Use

Run this gate on any content that will be seen by a prospect, champion, or executive:
- Outreach emails (cold or warm)
- Champion 1-pagers
- Business cases / proposals
- QBR slides
- Competitive battle cards
- Follow-up emails after important calls

Do NOT use for internal updates, session notes, or pipeline hygiene.

## Step 1: Auto-Assemble the Panel

Build a panel of 7-10 experts tailored to the content type and audience.

### Assembly Rules

1. **Start with content-type experts.** Match the content being scored to the relevant expert set below.
2. **Add domain experts.** Based on the account's vertical (banking, insurance, crypto, shipping), add 1-2 experts who understand the buyer's world.
3. **Always include these two:**
   - **AI Writing Detector** — scores against the 24-pattern rubric in `frameworks/document-quality.md`. Weight: 1.5x. Non-negotiable.
   - **YOUR-NAME Voice Match** — checks alignment with `knowledge/communication-playbook.md`. Does this sound like YOUR-NAME wrote it? Docks points for marketing language, corporate tone, or patterns YOUR-NAME avoids.
4. **Cap at 10 experts.** Merge overlapping roles if you have more.

### Expert Sets by Content Type

**Outreach / Sequences:**

| Expert | Lens | Red Flags |
|--------|------|-----------|
| Cold Email Specialist | Reply rate potential. Brevity, specificity, offer clarity. | Vague value props, walls of text, over-explaining |
| Frame & Status Expert | Does this position sender as peer/advisor, not vendor? | "I just wanted to...", begging energy, weak positioning |
| Prospect Respect Check | Is this genuinely useful or just noise? Non-pushy CTA? | Fake personalization, presumptuous asks, spray-and-pray signals |
| Pattern Interrupt Analyst | Does the opening stop the scroll? Subject + first sentence combo. | Generic openers, predictable subject lines |
| Research Depth Scorer | Does the email prove the sender knows this prospect specifically? | Generic compliments, "I noticed your website..." |
| Sequence Architecture | Does each step add new value? Follow-up ladder logic? | "Just checking in", repetitive bumps, no value escalation |
| Deliverability Analyst | Spam triggers, link density, send structure safety? | Spam words, link overload in early steps |

**Champion Docs / Business Cases / Proposals:**

| Expert | Lens | Red Flags |
|--------|------|-----------|
| Buyer Empathy | Does this address THEIR problems in THEIR language? | Product-centric framing, internal jargon |
| Data Rigor | Are claims specific, sourced, and verifiable? | Round numbers, vague "industry reports" |
| Competitive Awareness | Would this hold up if the buyer also has a competitor proposal? | Ignoring known competitor strengths |
| Executive Readability | Can a VP skim this in 2 minutes and get the point? | Buried lede, excessive detail before impact |
| Internal Sellability | Can the champion hand this to their boss without editing? | Needs too much context, too vendor-y |
| Risk Honesty | Does it acknowledge tradeoffs and limitations? | "No downsides" framing |

## Step 2: Select Scoring Rubric

| Content Type | Rubric |
|---|---|
| Outreach, sequences, follow-up emails | Cold Email Copy Rules (in `frameworks/sequences.md`) + 24-pattern AI rubric (in `frameworks/document-quality.md`) |
| Champion docs, business cases, proposals | Strategic Quality rubric (below) |
| QBR slides, exec summaries | Content Quality rubric (below) |

### Strategic Quality Rubric (champion docs, business cases, proposals)

| Dimension | 0-25 Scale | What Earns Points |
|-----------|-----------|-------------------|
| **Data Foundation** | 0-5: no data. 6-15: some stats, unverified. 16-20: specific + sourced. 21-25: real data, recent, verifiable, prospect-specific. | Real numbers from Mixpanel, SFDC, or public sources. Named proof points (a Tier-1 reference bank PoC, 73.9% FP reduction). No round numbers. |
| **Actionability** | 0-5: vague recommendation. 6-15: clear next step, unclear path. 16-20: specific timeline + resources. 21-25: step-by-step with owners and dates. | "Sign by [date]" beats "consider this." Named stakeholders. Realistic timelines. |
| **ROI Clarity** | 0-5: no business case. 6-15: qualitative benefits only. 16-20: estimated savings/returns. 21-25: 4:1+ ROI demonstrated with cost comparison to alternatives. | Comparison to status quo cost. Break-even timeline. Conservative estimates with assumptions stated. |
| **Risk Assessment** | 0-5: "no downsides." 6-15: mentions risks vaguely. 16-20: specific risks + mitigations. 21-25: honest tradeoffs, dependencies identified, contingency plan. | Acknowledging implementation effort. Naming what could go wrong. Not overselling. |

### Content Quality Rubric (QBR slides, exec summaries)

| Dimension | 0-25 Scale | What Earns Points |
|-----------|-----------|-------------------|
| **Hook Power** | 0-5: generic, no reason to keep reading. 6-15: interesting but not urgent. 16-20: strong curiosity or contrarian claim. 21-25: impossible to ignore, specific + surprising. | Leads with their data, not product features. Specific to this account. |
| **Voice Authenticity** | 0-5: obvious AI. 6-15: corporate but passable. 16-20: sounds professional and human. 21-25: sounds like YOUR-NAME wrote it. | Short punchy sentences. Specific numbers. No corporate jargon. Matches `communication-playbook.md`. |
| **Value Density** | 0-5: filler. 6-15: some insight mixed with fluff. 16-20: every sentence earns its place. 21-25: "I learned something I can use today." | Actionable insight, not observation. Specific data points. Nothing that could be deleted without losing meaning. |
| **Engagement Potential** | 0-5: no response expected. 6-15: might get a "thanks." 16-20: likely to generate discussion. 21-25: will be forwarded internally. | Sparks debate. Surfaces something the audience didn't know. CTA invites genuine response. |

## Step 3: Score — Recursive Loop Until 90+

**Target: 90/100. Non-negotiable. Max 3 rounds.**

Each round produces:

```
## Round [N] — Score: [AVG]/100

| Expert | Score | Key Feedback |
|--------|-------|--------------|
| [Name] | [0-100] | [One-line rationale] |
| AI Writing Detector (1.5x) | [0-100] | [Pattern count + top violations] |
| YOUR-NAME Voice Match | [0-100] | [Voice alignment assessment] |

**Aggregate:** [weighted average — AI Detector at 1.5x]
**Top 3 weaknesses:** [ranked]
**Changes made:** [specific edits addressing each weakness]
```

Then the revised content.

### Rules

- Scores must be honest. No padding to 90.
- AI Writing Detector weighted 1.5x in aggregate.
- If aggregate < 90: identify top 3 weaknesses, revise, next round.
- If aggregate >= 90: finalize.
- After 3 rounds, if still < 90: return best version with honest score + note on what's holding it back.
- Show ALL rounds — the iteration trail is part of the value.

## Step 4: Output

```
## Result: [SCORE]/100 — [PASS / NEEDS WORK]

[Final content]

**Iterations:** [N] rounds
**Panel:** [Expert names]
```

## Step 5: Learn from Rejections

If the user rejects panel-approved content (score 90+ but user says "no"):
1. Ask why (or infer from context)
2. Log the pattern to `memory/` as a feedback memory
3. Apply the learned pattern in future scoring rounds

## Integration with Existing Frameworks

- The panel reads `frameworks/document-quality.md` for the 24-pattern rubric
- The panel reads `knowledge/communication-playbook.md` for YOUR-NAME's voice
- The panel reads `knowledge/domain-strategy.md` for domain accuracy
- Outreach scoring also applies the Cold Email Copy Rules from `frameworks/sequences.md`
- Run `bash hooks/check-quality.sh` as a final automated pass after panel approval
