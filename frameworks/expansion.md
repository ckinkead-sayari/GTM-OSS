# Account Expansion Framework

Net-new pipeline is important. Expansion revenue from existing accounts is more efficient. This framework covers when and how to grow accounts.

Target: 110%+ Net Revenue Retention.

## Expansion Triggers

Watch for these signals in existing accounts. When one fires, act within the timeframe listed.

| Trigger | Upsell Path | Act Within |
|---------|------------|-----------| 
| Client enters new market / geography | Expand analysis scope to new region | 1 week of learning about it |
| New regulation or enforcement action in their sector | Re-analyze against new requirements | 48 hours |
| Client mentions a new use case on a call | Propose expanded scope or new product module | Next scheduled touchpoint |
| QBR reveals coverage gaps | Propose broader scope or higher frequency | During the QBR |
| Client asks "how do we compare to peers?" | Introduce benchmarking / intelligence tier | Immediately — this is buying intent |
| New capability launched in your product | Re-analyze with new capability, show incremental value | Within 1 week of launch |
| Leadership change at client (new CRO, CCO, CTO) | Intro meeting with new stakeholder + refresh business case | Within 2 weeks |
| Client's competitor had a public incident | "Here's what this means for you" analysis | 48 hours |
| Contract renewal approaching (60 days out) | QBR + expansion proposal + updated business case | 60 days before renewal |

## QBR Framework (Quarterly Business Review)

QBRs are the expansion motion. Every QBR should advance the account, not just report on it.

**Cadence:** Quarterly for meaningful accounts.

**Format:** 30 minutes. Primary buyer + optional exec sponsor.

**Agenda:**
1. **Trend direction** — improving, stable, declining (their data, not your opinion)
2. **Top findings this quarter** — severity trends, new issues, resolved issues
3. **Landscape update** — regulatory changes, enforcement trends, market shifts affecting them
4. **Expansion opportunity** — new scope, higher frequency, new module, benchmarking
5. **Product roadmap preview** — what's coming that benefits them specifically

**Rule:** Never leave a QBR without a next action. Either an expansion proposal, a referral ask, or a case study conversation.

### QBR Prep Workflow (Two-Source Pattern)

Combine automated data from two sources for complete QBR prep:

**Source 1 — Notion Dashboard (Three-Component Health):**
- **Leading Score** (0-100): Feature breadth, user growth, session depth trend, time-to-value. If Leading is high but Lagging is moderate = growth trajectory, expansion-ready.
- **Lagging Score** (0-100): Weighted events (EWMA), active users, concentration risk %, trend (z-score). If declining = defend before expanding.
- **Context Score** (0-100): Renewal proximity, MEDDPICC, deal velocity, competitive signals. Competitor mentions > 0 = address before proposing expansion.
- **Composite Health Score** (band, e.g., 55-71): Overall health with ±8 confidence interval.
- Concentration Risk %: If >60%, execute `frameworks/multi-threading.md` BEFORE proposing expansion.
- Feature Breadth ratio: If <40% of event types used, propose feature adoption before scope expansion.
- WoW trend direction from EWMA-based mixpanel-usage-sync

**Source 2 — Glean QBR Agent (Deal & Relationship):**
- Route to QBR Agent (`[YOUR_AGENT_ID]`) via Glean `chat`
- Pulls: bookings, pipeline, deal narratives, cross-deal themes, call summaries
- Template deck: [QBR Template](https://docs.google.com/presentation/d/1l4Pk9j4g8e1VLY4tzJc1NEgpBVmXikGaXBYNvx9SbYk)
- Gong Dashboard for revenue intelligence overlay

**Synthesis step:** Layer claudeGTM account context (from `accounts/{account}.md`) on top of both sources. The account file has relationship history, competitive intel, and strategic context that neither automated source captures.

**Health Score Slide (required in every QBR):**
```
Account Health: [composite band, e.g., 55-71] | Trend: [↑/→/↓]

What's Working (highest component):
  [Leading/Lagging/Context] at [score] — [specific reason, e.g., "Feature breadth at 80%, 3 new users in 30d"]

Watch Area (lowest component):
  [Leading/Lagging/Context] at [score] — [specific reason, e.g., "Concentration at 72% — one user dependency"]

Action: [what needs to happen to improve the watch area]

Feature Adoption: [X/Y] event types used. Unused high-value: [list]
Active Users: [N] (top: [name, events]) | Concentration: [%]
```

This turns the QBR from a backward-looking activity report into a forward-looking health diagnostic that naturally leads to the expansion conversation. If the watch area is Leading (adoption) → propose training. If Lagging (volume) → investigate root cause. If Context (competitive) → reinforce differentiation.

## Expansion Conversation Starters

- "Since we started, your [metric] has moved from [X] to [Y]. The next lever is [expansion scope]."
- "Three of your peers are now monitoring [new area]. Want to see how you compare?"
- "[Regulation/event] just happened. Here's what it means for your current coverage."
- "We just launched [capability]. I ran it against your data — here's what it found."

## Tracking

Log expansion signals in `memory/active-context.md` under "Expansion Signals." When a signal matures into a proposal, move it to the pipeline table.

## Retention Mechanics

The living business case IS the retention mechanism:
- Business case updates with every analysis cycle
- Trend lines show improvement over time
- When the CFO asks "why are we paying for this?" the answer is already written
- Canceling means going blind — they lose the trend data and coverage

If a client goes quiet (no engagement in 30+ days), that's a churn risk. Re-engage with a proactive finding or landscape update, not "just checking in."

## MEDDPICC Expansion Framework (Adapted from CS)

Source: Tunji Onigbanjo's "AI Prompts for CS [2026]." Adapted for EMEA FI account expansion.

Before proposing any expansion, qualify through MEDDPICC:

| Element | Question to Answer | Where to Find It |
|---------|-------------------|-----------------|
| **Metrics** | What measurable outcomes has the current deployment delivered? | Mixpanel usage data (events, users, feature breadth), QBR history |
| **Economic Buyer** | Who controls the expansion budget? Same as renewal owner? | SFDC contacts, Gong calls, stakeholder mapping |
| **Decision Criteria** | What will they evaluate the expansion against? | Discovery calls, competitor positioning, regulatory requirements |
| **Decision Process** | How does procurement work for expansion vs net-new? | Previous deal history, champion intel |
| **Identified Pain** | What problem does the expansion solve that the current scope doesn't? | Usage gaps (features not adopted), customer feedback, regulatory changes |
| **Champion** | Who will sell this internally? Are they willing and able? | Relationship mapping, Gong sentiment, engagement patterns |
| **Paper Process** | Can this be a simple addendum or does it need a new RFP? | Legal/procurement context from account history |
| **Competition** | Who else could fill this gap? Is the incumbent at risk? | Competitive intel, recent mentions on calls |

### Stakeholder Mapping for Expansion

For any expansion >$50K, map at minimum:
- **Economic Buyer** — controls budget
- **Technical Buyer** — evaluates product fit
- **Champion** — internal advocate
- **Blocker** — who could say no and why
- **End Users** — who will actually use the expanded scope (check Mixpanel for current power users)

Cross-reference against Notion Contacts DB. If you're single-threaded (only one contact engaged) or concentration risk >60%, that's a **multi-threading risk** — execute `frameworks/multi-threading.md` before proposing expansion. The Lagging Score concentration sub-metric directly measures this.

### Renewal Strategy by Health Profile

Before any renewal conversation, check which health component is weakest. Don't use a one-size-fits-all approach when you have component-level diagnostic data.

| Weakest Component | Renewal Strategy | Key Risk | Conversation Opener |
|-------------------|-----------------|----------|-------------------|
| **Leading** (low adoption, narrow features, users not growing) | Lead with training + adoption roadmap. Show untapped features. Offer 90-day adoption sprint as part of renewal. | They don't see the value because they're not using the product fully. | "Before we discuss renewal, I want to make sure your team is getting full value. You're paying for X but only using Y — here's a plan to close that gap." |
| **Lagging** (declining usage, users gone dark, concentration spiking) | Lead with root cause investigation. Are users leaving? Is the workflow broken? Is there a data quality issue? | Real churn risk — they may already have decided. Don't pitch; listen. | "Before we talk renewal, I want to understand what changed. Your team's usage shifted recently and I want to make sure we're still aligned with your workflow." |
| **Context** (competitor mentioned, weak sponsorship, procurement blocking) | Lead with competitive differentiation + exec sponsorship renewal. Refresh the business case with current data. | Someone is selling against you, or your internal champion lost influence. | "I know [Competitor] has been in conversation. Let me share what you'd lose and what the switch would actually cost — then let's talk about what we can improve." |
| **All healthy** | Lead with expansion. The renewal is a formality — the real conversation is about growing scope. | Complacency. Don't take the renewal for granted. | "Your team's engagement has been excellent. I want to discuss what the next phase looks like — there are [N] capabilities your team hasn't tapped yet." |

**Data File accounts (Account_Q, Account_J, Account_O):** Leading and Lagging Scores are N/A. Focus entirely on Context Score and engagement signals (Last Touch, support tickets, delivery success, Gong sentiment). The renewal conversation should center on data quality, delivery reliability, and whether the data is actually being used downstream.

### "You Said / We Did" Framework (Renewal & Expansion)

Source: Rob Page (CS International). Use at renewal touchpoints and expansion conversations.

Structure for every renewal/expansion conversation:
1. **"You said..."** — Summarize their stated goals, pain points, and requirements from onboarding or last QBR
2. **"We did..."** — Document specific actions taken, features delivered, support provided
3. **"Here's the value..."** — Quantify the impact using Mixpanel data + qualitative wins
4. **"What's next..."** — Propose expansion scope tied to their evolving needs

This creates an auditable value narrative that makes renewal/expansion a logical conclusion rather than a sales pitch. Update the "You Said / We Did" doc with every meaningful interaction.
