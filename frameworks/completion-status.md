# Completion Status Protocol

Every GTM workflow must report its status when complete.

## Status Codes

### DONE
All steps completed successfully. Evidence provided for each claim.

Example: "DONE — Researched Account_A (3 recent news items, 2 regulatory developments, 1 competitive move). Drafted outreach email using warm intro path via [mutual connection]. Updated pipeline: Account_A moved to Outreach stage."

### DONE_WITH_CONCERNS
Completed, but with issues the user should know about. List each concern.

Example: "DONE_WITH_CONCERNS — Drafted Account_D business case, but:
- Could not find recent regulatory actions specific to their jurisdiction
- Champion contact may have changed roles (LinkedIn shows title update 2 weeks ago)
- Competitive positioning vs [competitor] is based on 6-month-old data"

### BLOCKED
Cannot proceed. State what is blocking and what was tried.

Example: "BLOCKED — Cannot draft Account_C outreach:
- No warm path found (checked LinkedIn connections, conference attendees, former colleagues)
- Recent news is all positive — no clear pain point to lead with
- RECOMMENDATION: Wait for their Q1 earnings (April 15) for a natural opening, or find a warm intro through [suggested approach]"

### NEEDS_CONTEXT
Missing information required to continue. State exactly what's needed.

Example: "NEEDS_CONTEXT — To build the Account_B champion doc, I need:
- Which specific use case are we targeting? (Trade surveillance vs. KYC vs. sanctions screening)
- Who is the champion? (Name, title, what they care about)
- What's the budget cycle? (Are we in-cycle or trying to create urgency outside cycle?)"

## When to Use Each

| Workflow | Typical Status | Common Concerns |
|----------|---------------|-----------------|
| Account research | DONE or NEEDS_CONTEXT | Research gaps, contradictory info |
| Outreach draft | DONE_WITH_CONCERNS | Missing warm path, stale intel |
| Business case | NEEDS_CONTEXT | Missing use case specifics |
| Champion doc | DONE_WITH_CONCERNS | Champion role uncertainty |
| Call debrief | DONE | Rarely blocked — just capture what happened |
| Post-call follow-up | DONE_WITH_CONCERNS | Ambiguous next steps from call |
| Expansion play | BLOCKED or NEEDS_CONTEXT | Missing trigger data, unclear timing |

## Escalation Rules

It is always OK to say "I don't have enough information to do this well."

Bad outreach is worse than no outreach. Bad research is worse than no research.

**Escalate when:**
- Research is insufficient after 3 search attempts — flag what's missing
- No warm path exists and cold outreach feels forced — suggest alternatives
- The ask doesn't match the relationship stage — flag the mismatch
- Competitive intel is stale (>6 months) — flag the risk
- Champion status is uncertain — recommend verification before sending

**Escalation format:**
```
STATUS: BLOCKED | NEEDS_CONTEXT
REASON: [1-2 sentences]
ATTEMPTED: [what was tried]
RECOMMENDATION: [what should happen next]
```

**Never do bad work just to produce output.** Stopping with a clear status is always better than shipping something that damages a relationship.
