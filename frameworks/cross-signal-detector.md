# Cross-Signal Detector

Finds overlapping signals across data sources. When Mixpanel usage data, Glean/Gong call transcripts, Gmail threads, and Notion pipeline data all flag the same account or pattern, that convergence is worth acting on immediately.

## Purpose

Individual signals are noise. Converging signals are conviction. This framework formalizes what the scheduled tasks do implicitly — detecting when multiple independent data sources point at the same account or pattern.

## Signal Sources

| Source | What It Captures | Updated By |
|--------|-----------------|-----------|
| **Mixpanel** | Usage volume, feature breadth, user growth, concentration, z-scores | `mixpanel-usage-sync` (daily) |
| **Gong via Glean** | Call transcripts, competitor mentions, objections, buying signals, sentiment | `gong-pipeline-sync` (daily) |
| **Gmail** | Inbound interest, reply velocity, thread activity, lead notifications | `lead-response-scanner` (2x daily) |
| **SFDC via Glean** | Opportunity stage changes, contact additions, deal amount changes | `gong-pipeline-sync` (daily) |
| **Notion** | Health scores, sequence status, deal stages, contact engagement, renewal dates | All tasks write here |
| **Slack via Glean** | Internal discussion volume, escalation signals, cross-team mentions | `pipeline-staleness-check` (weekly) |

## Signal Types

### 1. Account Convergence (highest value)

Multiple sources independently flag the same account in the same timeframe.

| Signal Combination | Confidence | Interpretation | Action |
|-------------------|-----------|----------------|--------|
| Usage spike (Mixpanel) + Gong call scheduled + Gmail thread active | **95%** | Account is engaged across all channels — momentum | Prioritize, prepare for expansion conversation |
| Usage decline (z < -1) + No Gong calls in 30d + No Gmail activity | **90%** | Account going dark across all channels — churn risk | Immediate outreach, escalate if no response in 48h |
| Competitor mention (Gong) + Usage decline (Mixpanel) + Renewal < 90d | **95%** | Active competitive evaluation during renewal window | Emergency competitive defense sequence |
| New user signup (Mixpanel) + New contact added (SFDC) + No sequence exists | **85%** | Organic expansion happening without AM engagement | Start expansion sequence, identify the new stakeholder |
| Gmail inbound from new persona + No Gong history + Usage stable | **80%** | New thread at existing account — could be expansion or issue | Research the contact, prepare for discovery conversation |

### 2. Pattern Convergence (cross-account)

The same signal appears across multiple accounts simultaneously.

| Pattern | What It Means | Action |
|---------|--------------|--------|
| 3+ accounts mention same competitor in same week | Competitor running coordinated campaign | Competitive battle plan, alert leadership |
| 3+ accounts show usage decline in same week | Possible product issue or market shift | Investigate product side, check for incidents |
| Multiple accounts show new users in same BU type | Emerging use case | Document the pattern, build use-case content |
| Multiple renewals clustering in same month | Capacity risk for AM | Front-load prep, stagger conversations |

### 3. Contradiction Signals (anomaly detection)

Sources disagree — investigate before acting.

| Contradiction | Possible Explanation | Action |
|--------------|---------------------|--------|
| Usage up + Champion going dark (no Gong/Gmail) | Champion left, new users found [YOUR_PRODUCT] independently | Find the new power user, they may be your next champion |
| Usage down + Positive Gong sentiment | Team restructuring, seasonal, or API migration | Ask directly — don't assume churn |
| SFDC stage advancing + No Gong calls logged | Conversations happening off-Gong (in-person, WhatsApp) | Verify with champion, update records |
| Gmail active + Mixpanel zero events | Prospect in evaluation, not yet onboarded | Normal for pre-sales — don't flag as health issue |

## Execution

### When to Run

The cross-signal detector logic should be applied:

1. **Daily** by `daily-gtm-briefing` — check for account convergence signals from overnight data
2. **Wednesday** by `pipeline-staleness-check` — check for pattern convergence across accounts
3. **Friday** by `weekly-gtm-retro` — full cross-signal analysis for the week
4. **On-demand** during any account research or call prep session

### How to Run (Scheduled Tasks)

For each key account, pull the latest data from each source and check for convergence:

```
For each account in portfolio:
  1. Mixpanel: trend direction (up/down/stable), z-score, notable events
  2. Gong (via Glean): last call date, sentiment, competitor mentions, objections
  3. Gmail: last inbound/outbound date, active threads, reply velocity
  4. SFDC (via Glean): stage, amount changes, new contacts
  5. Notion: health score, sequence status, renewal date

  Cross-reference:
  - Are 3+ sources signaling the SAME direction? → High-confidence signal
  - Are sources contradicting? → Anomaly, investigate
  - Is a pattern appearing across 3+ accounts? → Systemic signal
```

### Output Format (for Slack posts)

```
🔀 Cross-Signal Alerts — YYYY-MM-DD

🔴 CONVERGING RISK:
- [Account]: Usage ↓ (z=-2.1) + No Gong in 28d + Gmail dark 21d
  → All channels going dark. Immediate outreach required.

🟢 CONVERGING OPPORTUNITY:
- [Account]: Usage ↑ (z=+1.8) + New users in [BU] + Gong call next week
  → Expansion momentum. Prep expansion proposal before call.

🟡 CONTRADICTIONS (investigate):
- [Account]: Usage ↓ but Gong sentiment positive last call
  → Ask champion directly about usage shift.

📊 CROSS-ACCOUNT PATTERNS:
- [Competitor] mentioned by 3 accounts this week: [A], [B], [C]
  → Coordinated competitive push. Alert leadership.
```

### Confidence Scoring

| # Sources Agreeing | Confidence | Action Threshold |
|-------------------|-----------|-----------------|
| 2 of 6 | 60% | Note it, monitor |
| 3 of 6 | 80% | Flag in briefing, prepare response |
| 4+ of 6 | 95% | Act immediately, don't wait for next scheduled check |

### Integration with Existing Frameworks

- Account convergence risk signals → trigger sequences from `frameworks/sequences.md` (Churn Intervention, Competitive Defense)
- Pattern convergence → feed into `frameworks/retro.md` weekly pattern recognition
- Contradiction signals → add to call prep agenda via `frameworks/call-debrief.md`
- Cross-account competitor patterns → update `knowledge/domain-strategy.md` competitive section
