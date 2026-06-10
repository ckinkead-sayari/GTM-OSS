# [Your Product] — Capabilities

**Purpose:** current state of what your product actually does. Read before any call prep, champion doc, or competitive conversation. Source of truth for product references in drafted content.

**Update cadence:** after every product release. Treat as living documentation. A stale capabilities file leads to promises you can't deliver.

---

## Product Surface Area

List your modules / tiers / SKUs. One line each.

| Module | What it does | Who uses it |
|--------|--------------|-------------|
| [Module 1] | [one-line description] | [e.g., investigators, analysts, engineers] |
| [Module 2] | ... | ... |
| [Module 3] | ... | ... |

## Deep Detail: Module 1

### What it is

[2-3 sentence description of the module's purpose and mental model]

### Core capabilities

- **[Capability 1]** — [description, who benefits, notable constraints]
- **[Capability 2]** — ...
- **[Capability 3]** — ...

### Recent feature releases

Keep chronological. Most recent first. Include what shipped, who benefits, competitive relevance.

- **YYYY-MM — [Feature name]** — [description]. Matters because [competitive / regulatory / customer-driver context].
- **YYYY-MM — [Feature name]** — ...

### Known gaps

Be honest. Buyers respect vendors who know their own weaknesses.

- **[Gap 1]** — [what's missing, what we tell buyers, workaround if any, roadmap status]
- **[Gap 2]** — ...

### Integration points

- **[Integration 1]** — [what it integrates with, what data flows which way]
- **[Integration 2]** — ...

---

## Deep Detail: Module 2

[Repeat the structure above for each module.]

---

## Cross-Module Stories

Scenarios that span multiple modules. Useful for champion docs and exec-level pitches.

### Story 1: [Scenario name]

**Who:** [persona] at [sub-segment]
**Problem:** [one sentence]
**How the product solves it:** [2-3 sentences naming which modules play together]
**Proof:** [customer result or case study reference]

### Story 2: [Scenario name]

[Repeat]

---

## Pricing & Packaging

How the product is sold. Keep high-level — pricing changes often.

- **[Tier 1]** — [who it's for, rough range]
- **[Tier 2]** — ...
- **Add-ons:** [list]

## Competitive Positioning by Capability

For each major capability, where do you win / lose?

| Capability | You win against… | You lose against… |
|------------|-------------------|--------------------|
| [Cap 1] | [competitors] | [competitors] |
| [Cap 2] | ... | ... |

## Banned Claims

Things marketing says that Engineering will disown. Don't put these in customer-facing content.

- Don't claim: [e.g., "real-time" if actual latency is minutes, not milliseconds]
- Don't claim: [e.g., "100% coverage" if coverage varies by jurisdiction]
- Always qualify: [e.g., performance numbers with the data volume they were measured at]

## See also

- `knowledge/domain-summary.md` — how these capabilities map to buyer pain
- `frameworks/champion-doc.md` — where product capabilities get paired with account data
- `frameworks/business-case.md` — pattern for proving ROI of specific capabilities
