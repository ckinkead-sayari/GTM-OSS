# Call Debrief Template

Run this after every prospect or customer call. Captures what happened, what you learned, and what to do next. This is how the objection catalog, active-context, and expansion signals get fed.

## Debrief Structure

After every call, capture these 7 things:

### 1. Outcome (1 sentence)

What happened? Meeting booked, demo scheduled, proposal requested, objection surfaced, deal advanced, deal stalled, deal lost.

### 2. Key Learnings

What did you learn about:
- **Their situation:** Current process, pain points, gaps, priorities
- **Their buying process:** Who decides, what's the timeline, what blocks them
- **Their language:** How they describe the problem (use their words in future outreach)

### 3. Objections Encountered

For each objection:
- What they said (verbatim if possible)
- What you responded
- Did it land? (yes/no/partially)
- Log to `frameworks/objections.md` if it's new or the response evolved

### 4. Champion Status

- Who is the champion? (name, title)
- How bought-in are they? (exploring / interested / committed / advocating)
- What do they need from you to sell internally?

### 5. Competitive Intel

- Did they mention alternatives? Which ones?
- What are they comparing you against?
- What's their perception of the competitor?

### 6. Action Items

- [ ] [Your action — by when]
- [ ] [Their action — by when]
- [ ] [Follow-up content to send — by when]

### 7. Pipeline Update

- Stage change? (update Salesforce + active-context)
- Next meeting scheduled?
- Deal at risk? Why?
- Expansion signal? (log to active-context Expansion Signals section)

## Pre-Call Health Briefing (Pull Before Every Customer Call)

Before any external call, pull the three-component health snapshot. This takes 30 seconds and fundamentally changes how you enter the conversation.

```
[Account] Health Briefing — [Date]
Leading:  [XX] (trend: ±N pts, 30d) — feature breadth, user growth, session depth
Lagging:  [XX] (trend: ±N pts, 30d, z=[X.X]) — weighted events, active users, concentration
Context:  [XX] — renewal in [N]d, MEDDPICC [status], [N] competitor mentions
Composite: [XX-YY band] | Churn Risk: [tier] | Lifecycle: [stage]

Key alert: [any z-score anomaly or tier change in last 7d]
Concentration: [top user %] — if >60%, note multi-threading status
Weakest component: [Leading/Lagging/Context] — steer conversation accordingly
```

**Source:** Notion Accounts DB (fields populated daily by `mixpanel-usage-sync`). For Data File accounts (Account_Q, Account_J, Account_O), Leading and Lagging show "N/A" — use Context Score and engagement history only.

**How this changes the call:**
- Weakest = Leading → Ask about adoption, training needs, which teams aren't using it yet
- Weakest = Lagging → Ask about workflow changes, team changes, whether the tool is still embedded in process
- Weakest = Context → Address competitive landscape, renewal timeline, sponsorship stability
- All healthy → Push expansion, new use cases, peer benchmarking

## Pre-Debrief: Pull Call Context (if available)

Before debriefing, check if a Gong recording exists for this call:
1. Use Glean MCP `search` with `app: "gong"` and query "[Account Name] [Date]"
2. If a recording is found, use `read_document` to get the transcript
3. Pre-populate the debrief sections from the transcript — YOUR-NAME corrects and adds context
4. Also pull current Mixpanel usage for the account (`Run-Query` on project [YOUR_PROJECT_ID]) — usage data adds context to what was discussed

This turns debrief from pure recall into verified-and-augmented recall.

### 8. "You Said / We Did" Log (Existing Customers Only)

For renewal and expansion accounts, maintain a running "You Said / We Did" log:
- **What they said on this call** — goals, frustrations, feature requests, timelines
- **What we committed to** — follow-ups, demos, escalations, deliverables
- **Deadline** — when they expect it

This feeds directly into the expansion framework's value narrative and renewal conversations. Append to the account file under a `## You Said / We Did` section.

## Post-Debrief Workflow

1. Update `memory/active-context.md` pipeline table
2. Draft follow-up email via `gmail_create_draft` (within 24 hours)
3. Log new objections to `frameworks/objections.md`
4. Update champion doc if deal is advancing
5. Log expansion signals if existing customer
6. Update `accounts/{account}.md` with debrief findings
7. Update "You Said / We Did" log in account file (existing customers)
8. Check if QBR Agent has relevant deal context — use Glean `chat` with agent `[YOUR_AGENT_ID]` to pull deal narratives that complement your debrief notes
