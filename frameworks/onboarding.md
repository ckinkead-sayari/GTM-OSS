# Onboarding Playbook

For accounts in the **Onboarding** lifecycle stage (< 6 months live). The first 90 days determine the lifetime of the relationship. Low usage during onboarding is expected — the question is whether adoption velocity is trending up.

## Lifecycle-Adjusted Scoring

Onboarding accounts are scored differently in the health model (see `ARCHITECTURE.md`):
- **Leading Score** weighted higher — adoption velocity matters more than absolute volume
- **Lagging Score** not penalized for low absolute numbers — expected during ramp
- **Context Score** still fully weighted — deal mechanics, sponsorship, and competitive landscape matter regardless of stage

## Graph Account Milestones

| Milestone | Target | Metric Source | Alert If Not Met |
|-----------|--------|--------------|-----------------|
| **First login** | Day 1-3 | Mixpanel `login` event | No login by Day 5 → reach out to champion |
| **First high-value event** | Day 7-14 | Mixpanel `add_to_graph`, `resolve`, `export` | None by Day 21 → offer training session |
| **3+ active users** | Day 30 | Mixpanel active user count | Still single-user at Day 30 → multi-threading risk |
| **Feature breadth > 50%** | Day 60 | Mixpanel distinct event types / total | Below 30% at Day 60 → feature adoption workshop |
| **EWMA baseline established** | Day 90 | EWMA stabilizes (z-score variance < 1.0) | Still volatile at Day 90 → investigate workflow fit |
| **Steady-state classification** | Day 90 | Transition from Onboarding → Ramping | If still in Onboarding at Day 120 → escalate |

## Data File Account Milestones

For Data File customers (Account_Q, Account_J), Mixpanel milestones don't apply. Track delivery-based milestones:

| Milestone | Target | Metric Source | Alert If Not Met |
|-----------|--------|--------------|-----------------|
| **First data delivery received** | Day 7-14 | SFDC delivery records (via Glean) | No delivery by Day 14 → check with ops team |
| **First API call** (if applicable) | Day 14-30 | API access logs | No API usage by Day 30 → check if integration is blocked |
| **First support ticket** | Day 30 | Support system | Zero tickets could mean smooth onboarding OR zero engagement — investigate |
| **First QBR scheduled** | Day 60 | GCal MCP | No QBR by Day 60 → schedule proactively |
| **Data quality feedback received** | Day 90 | Gmail/Gong engagement | No feedback = blind spot — send proactive data quality check |

## Onboarding Touchpoint Cadence

| Week | Touch | Purpose |
|------|-------|---------|
| 1 | Welcome email + training offer | "Your team has access. Here's how to get started + I'm available for a walkthrough." |
| 2 | Check-in: first usage review | "I see [Name] has been active — any questions so far?" (If no usage: "Want to schedule a quick setup session?") |
| 4 | 30-day usage review | Pull Mixpanel snapshot. Share: "Here's what your team has done in the first month. Here are features they haven't explored yet." |
| 8 | 60-day adoption review | Feature breadth check. If below 50%: propose feature adoption workshop. If above: celebrate and discuss expansion. |
| 12 | 90-day health assessment | Full three-component scoring begins. Transition from Onboarding → Ramping if baselines are stable. First formal QBR. |

## Intervention Triggers

| Signal | Response | Timeframe |
|--------|----------|-----------|
| Zero logins after Day 5 | Direct outreach to champion + offer hands-on walkthrough | Same day |
| Only 1 user active at Day 30 | Execute `frameworks/multi-threading.md` Step 3 (champion intro request) | Within 1 week |
| Feature breadth < 30% at Day 60 | Propose structured training session focused on unused high-value features | Within 1 week |
| EWMA still volatile at Day 90 | Investigate: is the product a good fit? Are workflows misaligned? Escalate internally if needed. | Within 2 weeks |
| No engagement from buyer/sponsor | Escalate to [YOUR_PRODUCT] leadership for exec-to-exec check-in | Within 1 week |

## Logging

Log onboarding milestone events to `memory/analytics.jsonl`:
```json
{"event":"onboarding_milestone","account":"ACCOUNT","ts":"TIMESTAMP","milestone":"first_high_value_event","day":12,"status":"met"}
{"event":"onboarding_milestone","account":"ACCOUNT","ts":"TIMESTAMP","milestone":"feature_breadth_50pct","day":60,"status":"missed","action":"training_proposed"}
```

## Current Onboarding Accounts

| Account | Product Type | Start Date | Days In | Status |
|---------|-------------|-----------|---------|--------|
| Account_J | Data File | ~Dec 2025 | ~120d | Onboarding & Stabilization. $1.74M. ⚠️ Past 90-day milestone — needs assessment. |

When a new account enters Onboarding, add it to this table and begin tracking milestones.
