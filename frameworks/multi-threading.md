# Multi-Threading Playbook

When concentration risk exceeds 60% for a single user, execute this playbook systematically. Detection without action is wasted alerting.

## Trigger Thresholds

| Concentration % | Risk Level | Response |
|----------------|-----------|----------|
| <40% | Healthy | No action needed |
| 40-60% | Moderate | Monitor — add to weekly retro watchlist |
| 60-70% | High | Execute Steps 1-3 within 2 weeks |
| >70% | Critical | Execute Steps 1-5 within 1 week, escalate to [YOUR_PRODUCT] leadership |

## Step 1: Map the Account's User Base

Pull from Mixpanel MCP (`Run-Query`, project `2118751`):
- All users with `$account` containing the account name
- Break down by `$name`, `$email`, `$last_seen`, `$login_count`
- Filter out `$deprovisioned = true`

**Output:** Full user roster — who's provisioned, who's active, who's gone dark.

Cross-reference against Notion Contacts DB (`collection://[YOUR_UUID]`):
- Which Mixpanel users are already Notion contacts? (matched by email)
- Which Mixpanel users are unknown to us? (no Notion contact = blind spot)
- Which Notion contacts have zero Mixpanel activity? (provisioned but not using)

## Step 2: Identify Multi-Threading Targets

Prioritize contacts for engagement in this order:

1. **Active but unengaged** — Users with >100 events in 30d who we've never spoken to. These are power users we don't know. Highest value.
2. **Provisioned but inactive** — Users in Mixpanel with 0-10 events. They have access but aren't using it. Training opportunity.
3. **Named in SFDC but not in Mixpanel** — Contacts from Salesforce who don't appear in product data. May be decision-makers without product access.
4. **Different business unit users** — Users with a different `$business_unit` or `$use_case` than the primary champion. Cross-BU expansion signal.

## Step 3: Draft Introduction Request to Champion

Email template (to current champion, the concentrated user):

```
Subject: Quick ask — expanding [Product] adoption across your team

Hi [Champion],

I noticed you're the primary power user of [YOUR_PRODUCT] at [Account] — [X events in the last 30 days, covering Y use cases]. That's great engagement.

I wanted to ask: are there colleagues on your team (or adjacent teams) who might benefit from access or training? Specifically:

- [Name 1] — they have access but haven't used it much recently
- [Name 2] — [their role/BU] might find [specific feature] useful for [their use case]

Happy to run a targeted training session or create a workflow guide for their specific needs. Would a 30-minute session work for [date range]?

Best,
YOUR-NAME
```

**Tone rules:** This is a value-add, not a sales pitch. You're helping them get more from what they already pay for. Frame as "help your team" not "we need more users."

## Step 4: Propose Training Session

If champion agrees (or if you have direct relationships with other users):

- **Format:** 30-minute hands-on session, max 5 attendees
- **Content:** Tailored to their use cases (pull from Mixpanel event types they do/don't use)
- **Goal:** Each attendee completes one investigation independently during the session
- **Follow-up:** Check usage 7 days post-training — did new users activate?

## Step 5: Escalation (Critical Only, >70%)

If champion is unresponsive after 7 days, or if the concentrated user has gone dark:

1. **Internal escalation:** Flag to [YOUR_PRODUCT] CS/leadership — "[Account] has >70% concentration risk on [User]. If [User] leaves or disengages, we lose the account."
2. **Executive-to-executive outreach:** [YOUR_PRODUCT] leadership reaches out to account sponsor (not the champion) about adoption and value realization.
3. **Proactive value delivery:** Send an unsolicited analysis or finding to multiple contacts at the account — demonstrate value to people beyond the champion.

## Tracking

When executing this playbook:

1. Log to `memory/analytics.jsonl`:
```json
{"event":"multi_threading_play","account":"ACCOUNT","ts":"TIMESTAMP","concentration_pct":72,"target_user":"Champion Name","action":"step_N_executed"}
```

2. Update the account file (`accounts/{account}.md`) with multi-threading status and targets.

3. Track outcome: Did concentration % decrease within 30 days? Did new users activate?

## Exit Criteria

The play is complete when:
- Concentration risk drops below 60% (at least 2 active users sharing the load)
- OR: 3 outreach attempts to diversify with no response → escalate and document
- OR: Account confirms single-user is intentional (some accounts genuinely have one analyst) → accept risk, document it, ensure renewal conversation accounts for key-person dependency

## Proactive Champion Detection

Don't wait for concentration risk to spike. Use Leading Score data to identify emerging champions before they self-identify.

**Trigger:** `mixpanel-usage-sync` flags a user when:
- Their personal event velocity increases >150% MoM (relative to their own baseline)
- AND they start using high-value event types (`add_to_graph`, `resolve`, `export`) for the first time
- AND they are NOT already in the Notion Contacts DB as a known contact

**Output in daily briefing:**
```
Emerging Champions (new this week):
- [Name] ([email]) at [Account]: events +[X]% MoM, started using [export/resolve].
  Not in Notion Contacts. Action: Add to Contacts, schedule intro via champion.
```

**Action sequence:**
1. Add to Notion Contacts DB with source = "Mixpanel — emerging champion"
2. Research their role via Glean SFDC or LinkedIn
3. Ask existing champion for an introduction: "I noticed [Name] has been doing great work in [YOUR_PRODUCT] — would it be helpful to run a quick optimization session with them?"
4. Track their continued adoption in the next 30d sync

This is the offensive version of multi-threading. Rather than waiting for concentration to become dangerous, you're proactively building relationships with rising users.

## Integration with Health Score

Concentration risk feeds into the **Lagging Score** component:
- <40% concentration: +15 pts (multi-threading depth)
- 40-60%: +8 pts
- 60-70%: +3 pts
- >70%: 0 pts (maximum penalty)

A successful multi-threading play directly improves the Health Score by increasing the multi-threading depth sub-score.
