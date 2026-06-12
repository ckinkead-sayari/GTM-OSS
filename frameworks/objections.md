# Objection Catalog

Log every objection you encounter. Over time this becomes your most valuable GTM asset.

## Objection Record Template

For each new objection, log it in this format under the right category:

### "[Exact objection as stated]"

**Category:** [Competitive / Trust / Price / Need / Technical / Process / Data]
**Frequency:** [High / Medium / Low — update as you hear it again]
**Who says it:** [Buyer persona — CFO, compliance officer, procurement, etc.]
**Kill potential:** [Can this kill the deal? High / Medium / Low]

**Response framework:**
[2-3 sentence response. Lead with data or reframing, not defensive explanation.]

**Supporting evidence:**
- [Data point, case study, or proof point that backs the response]

**What NOT to say:**
[Common mistake or defensive response to avoid]

**Source:** [First encounter — date, prospect, context]
**Last updated:** [Date — update when the response evolves]

## Categories

### Competitive

*"Can't [competitor] do this?"* — Differentiate on structural capability, not features.

### Trust / Risk

*"You're too small" / "Can you scale?"* — Reframe size as speed advantage. Domain expertise > headcount.

### Price

*"Too expensive"* — Never defend price. Reframe to ROI. Use their own data from the business case.

### Need / Fit

*"We handle this internally"* — Don't argue. Ask questions. "What % of [scope] does your team cover?" The gap reveals itself.

### Technical

*"Is this just an AI wrapper?"* — Explain the architecture. Domain knowledge, tiered models, compounding data advantage.

**MCP / agentic architecture objections** (e.g., "why MCP over a traditional API?", "we're not comfortable with non-deterministic retrieval in AML", "the spec is immature", "token costs will blow up", "our Second Line won't accept black-box retrieval") → load `knowledge/technical-positioning.md (build it when your product has a technical/API/agent story — see knowledge/README.md)` which contains a seven-row MCP-specific objection library with vetted responses and the verified trade-off table.

### Process / Authority

*"How do I justify this internally?"* — Hand them the champion document. The business case IS the internal justification.

### Data / Privacy

*"What about our data?"* — Lead with defaults: minimal retention, client controls, work under their MSA.

## Catalog

*Add objections below under the right category as you encounter them. Use the record template above. One fictional worked example shows the format — replace it with your first real entry:*

### "This costs more than our current data vendor" (FICTIONAL EXAMPLE — delete after your first real entry)

**Category:** Price
**Frequency:** Medium
**Who says it:** IT Procurement (renewal/consolidation reviews)
**Kill potential:** Medium — kills expansions more often than renewals

**Response framework:**
Never defend the line item. Reframe from price-per-seat to cost-per-outcome using THEIR volume: "At your January case volume, the question isn't the seat price — it's what a resolved case costs you each way." Then offer a measured comparison on their own closed cases.

**Supporting evidence:**
- Their own usage data (cases touched, hours per case) — the business case framework turns this into their numbers, not yours

**What NOT to say:**
Anything that accepts the commodity framing ("we're actually priced competitively...") — you've lost the moment you compare per-seat prices.

**Source:** 2025-11, Northwind Insurance (fictional), consolidation review
**Last updated:** 2026-01

## Patterns to Watch

Review monthly:
- Same objection from 3+ prospects = systemic (fix messaging or product)
- Objections clustering at a specific stage = process problem
- New objection category emerging = market shift
- Track win/loss by primary objection — which objections are you beating vs. losing to?
