# Outreach Framework

## Message Structure

Every outreach follows this structure regardless of channel:

### 1. Hook (1-2 sentences)

Lead with something specific to THEM. Options:
- **Data hook:** A specific finding about their situation. "Your [domain] has [X issue] that [consequence]."
- **Event hook:** A regulatory change or market event that affects them. "[Event] means [consequence] by [date]."
- **Peer hook:** A relevant comparison. "Companies your size in [sector] typically have [X]."

### 2. Pain (1-2 sentences)

Connect the hook to a business consequence in their language:
- Financial: "[Cost/risk] in exposure"
- Operational: "[Time/effort] currently spent on [manual process]"
- Regulatory: "[Deadline] approaching with [consequence]"

### 3. Credibility (1 sentence)

Why you're qualified. Brief — the hook already demonstrated expertise.

### 4. Ask (1 sentence)

Specific, low-commitment, outcome-oriented. Never "schedule a demo."
- "Can I share the full analysis? (15 minutes)"
- "Would it be useful to see how you compare to peers?"

## Channel Rules

**Email:** Subject line includes their company name + specific finding. 4-6 sentences max (see `frameworks/sequences.md` Cold Email Copy Rules for step-specific limits — Step 1 is tighter at 3 sentences).

**LinkedIn:** Connection request: 1 sentence. Follow-up: 3-4 sentences.

**Warm intro:** Ask the introducer for a 2-sentence email. Your follow-up references the intro + adds one finding.

## By Buyer Persona

**Technical buyer (domain expert):** Specific technical findings. Peer-to-peer tone. Don't over-explain.

**Business buyer (VP/Director):** Aggregate numbers. Business risk or budget impact. Numbers first, details on request.

**Champion (internal seller):** Something that makes them look good for finding it. Collaborative tone. Never go over their head.

## Cadence

Default cadence below. For specific sequence types (Cold Outbound, Warm Reactivation, Event Follow-Up, etc.), see `frameworks/sequences.md` which defines step-by-step cadences with exit conditions.

| Day | Action |
|-----|--------|
| 0 | Initial outreach with hook + finding |
| 3 | Follow-up with additional data point |
| 7 | Try alternate channel if no response |
| 14 | Final touch: share a relevant insight (not a pitch) |
| 21 | Breakup — leave value, don't close your file |
| 30+ | Move to nurture |

Rules: Never more than 5 touches without response. Every touch adds new value. Never "just checking in."

## Banned Patterns

- "Just checking in"
- "I'd love to pick your brain"
- "Our platform enables..."
- "Hope this finds you well"
- Feature lists in outreach
- Generic subject lines ("Quick question", "Following up")

## Research Before Drafting (MANDATORY)

Before drafting any outreach, complete this research:

**1. Read knowledge base:**
- `knowledge/communication-playbook.md` — YOUR-NAME's actual voice, tone, email patterns, and phrases. Match this exactly.
- `knowledge/domain-strategy.md` — [YOUR_PRODUCT]'s banking value proposition, competitive positioning, proof points, and buyer persona framing.

**2. Internal research via Glean MCP:**
- `search` with query "[Account Name]" — find recent Gong calls, Slack threads, email exchanges, SFDC records
- `search` with `app: "salescloud"` and "[Account Name]" — current opportunity stage, amount, contacts
- `chat` with "What's the latest on our relationship with [Account Name]?" — synthesized internal context

**3. External research (web search):**
- Recent news, earnings, leadership changes, regulatory actions
- Competitive landscape and market position
- Evidence that contradicts assumptions about their pain

**4. Account file:**
- Read `accounts/{account}.md` for relationship history, contacts, previous objections

**5. Usage data via Mixpanel MCP:**
- `Run-Query` on project [YOUR_PROJECT_ID], filter by `$account` — current product usage (if existing customer)
- Pull the three-component health scores from Notion: Leading Score, Lagging Score, Context Score
- Check which component is weakest — this determines your messaging approach (see Health-Aware Messaging Matrix below)

**Critical:** All outreach must sound like YOUR-NAME wrote it. Use his opening/closing patterns, his email length norms, and his relationship-first approach. Never use marketing language he avoids.

**Delivery:** Use `gmail_create_draft` to create the email as a Gmail draft. NEVER auto-send.

## Health-Aware Messaging Matrix

When drafting outreach to existing customers, the **weakest health score component** determines your messaging focus. Don't pitch expansion when adoption is declining. Don't offer training when a competitor is running a POC.

| Weakest Component | Messaging Focus | Open With | Avoid |
|-------------------|----------------|-----------|-------|
| **Leading Score** (adoption declining, feature breadth narrowing, users not growing) | Training, onboarding help, workflow optimization. "Your team might not know about X." | "I noticed your team hasn't used [feature] yet — it's been a game-changer for [peer bank] in [use case]." | Expansion pitches, upsell, new scope proposals |
| **Lagging Score** (event volume dropping, users going dark, concentration spiking) | Value reinforcement, "here's what you'd lose", exec-level engagement, root cause investigation. | "I wanted to check in — I've noticed a shift in how your team is using [YOUR_PRODUCT] and wanted to make sure everything's aligned." | Feature announcements, training offers, casual check-ins |
| **Context Score** (competitor mentioned, MEDDPICC gaps, renewal imminent, exec sponsor changed) | Competitive differentiation, business case refresh, exec sponsorship, "You Said / We Did" value narrative. | "I heard [competitor] came up in conversation. I wanted to share what our customers typically find when they compare..." | Generic check-ins, product updates, training |
| **All components healthy** | Expansion, new use cases, peer benchmarking, QBR scheduling. | "Your team's usage has been strong — I wanted to explore whether [new capability/scope] makes sense." | Rescue/concern messaging, defensive tone |

**Rule:** If Lagging Score z < -2 (significant drop), skip the normal sequence cadence and reach out same-day with the Lagging messaging approach. This is time-sensitive.

## Data-Triggered Micro-Outreach

These are single-touch, time-sensitive actions triggered by specific usage data — not full sequences. The `daily-gtm-briefing` should flag these as "Quick Touches Available Today."

| Trigger | Data Source | Template (2-3 sentences) |
|---------|-----------|-------------------------|
| User does first `export` or `add_to_graph` (high-value event) | Mixpanel usage sync | "I noticed [Name] ran their first [export/graph build] — that's a great sign. Here's a quick tip: [specific workflow suggestion]. Happy to do a 15-min walkthrough if useful." |
| Previously dark user logs back in after 30+ days | Mixpanel `$last_seen` vs prior | "Good to see [Name] back in the platform. If anything's changed on your end or you need a refresher on what's new, I'm around." |
| Feature breadth jumps (3+ new event types in a week) | Mixpanel event type count | "I see your team started using [X, Y, Z] — that's exactly how [peer bank] expanded their workflow. Worth a quick chat about how to get the most from those features?" |
| Account z-score crosses -2 (significant drop) | Mixpanel EWMA/z-score | "I noticed a shift in your team's usage this week and wanted to check in directly — is everything working as expected? Happy to jump on a quick call." |
| Competitor mentioned in Gong transcript | gong-pipeline-sync extraction | See Competitive Defense sequence in `frameworks/sequences.md` |

**Rule:** Micro-outreach is conversational, not formal. 2-3 sentences max. The goal is to be noticed as attentive, not to start a sales cycle.

## Vertical Templates

*Add vertical-specific templates below as you learn what works for different buyer types.*

### MCP / Agentic Architecture (technical buyer at a bank)

When outreach, replies, or follow-ups concern [YOUR_PRODUCT]'s MCP offering — covering either the use-case question ("why is this a good fit for agentic orchestration?") or the protocol question ("why MCP over a traditional API?") — load `knowledge/mcp-banking-positioning.md` before drafting. It contains:
- The two-question framing so replies don't duck the product-fit half of the question
- Five drop-in email snippets (A: use-case opener, B: data-shape, C: protocol, D: trade-offs, E: the ask) tuned to senior-consultant voice
- Persona-tailored guidance for technical, business, and risk/audit buyers
- Seven-row objection library and verified-numbers table

Pair with `knowledge/product-capabilities.md` Section 9 for the architecture-depth details (tool surface, TM workflow mapping).
