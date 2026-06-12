# Northwind Insurance

> **FICTIONAL EXAMPLE — this entire file is invented.** It exists to show what a dossier looks like after a few working sessions: the section structure from `frameworks/account-dossier.md`, the append-only Activity Log discipline, and how the three knowledge layers differ. Keep it as a reference or delete it once your first real dossier exists (`/bootstrap` offers to delete it for you). The fictional seller here is "Acme Analytics," whose product **ClaimSight** does claims-fraud analytics for mid-market insurers.

**Last updated:** 2026-02-12

## Snapshot

- **Industry:** P&C insurance, mid-market (~$2.1B GWP, 3,400 employees, HQ Columbus OH)
- **Relationship:** Customer since 2025-06 — ClaimSight Core, 12 seats, $86K ARR
- **Renewal:** 2026-06-30 (auto-renew clause, 60-day non-renewal window)
- **Health:** YELLOW — usage concentrated in one team (see Usage Signal)

## Stakeholder Map

| Person | Role | Disposition | Notes |
|--------|------|-------------|-------|
| Dana Whitfield | Head of Claims Integrity | Champion | Owns the SIU team; presented our results internally in Jan |
| Priya Raman | VP Claims Operations | Economic buyer | Cares about cycle time, not fraud catch-rate framing |
| Marcus Bell | Director, IT Procurement | Neutral gatekeeper | Runs renewals through a vendor-consolidation review |
| (gap) | Data/Analytics lead | UNKNOWN | Who owns the warehouse ClaimSight would integrate with? |

## Active Deals

| Deal | Stage | ARR | Close | Next step |
|------|-------|-----|-------|-----------|
| Renewal 2026 | Not yet opened | $86K | 2026-06-30 | Open renewal prep at 120 days (2026-03-02) |
| SIU seat expansion (+6) | Discovery | ~$38K | TBD | Dana to confirm headcount approval in March planning |

## Usage Signal

- 30d: 9 of 12 seats active; Dana's SIU team = 71% of all queries (concentration risk — multi-threading play warranted)
- Claims-ops pilot users (Priya's org) went quiet after onboarding — 2 of 4 seats dormant since 2026-01

## Competitive Presence

- Incumbent rules-engine vendor (VeriShield, fictional) still runs first-pass triage; their AE visits quarterly
- Procurement's consolidation review (Marcus) could frame us as "another analytics line item" — needs the cost-per-resolved-case framing, not price-per-seat

## Regulatory Hooks

- State DOI market-conduct exam cycle hits Northwind in Q3 2026 — claims-handling timeliness will be scrutinized; cycle-time story lands here
- NAIC model bulletin on AI in claims decisions: their compliance team will ask about explainability — have the model-governance one-pager ready

## Layer 1 — Public Knowledge

- FY25 combined ratio 101.2% (annual report) — underwriting loss; expense pressure is real and public
- Press release 2026-01-08: new COO hire from a top-10 carrier, mandate "claims modernization"

## Layer 2 — Industry Context

- Mid-market P&C carriers are consolidating SIU vendors; budget shifting from headcount to tooling
- Peer carriers report 15–25% of fraud referrals from analytics (vs. adjuster intuition) within year one — Northwind is at 11%, below peer band

## Layer 3 — First-Principles Insight

- Their real constraint isn't fraud detection, it's adjuster trust: SIU accepts our referrals, claims ops ignores them. The expansion blocker is a *workflow* problem (referrals arrive outside the adjuster's queue), not a model-quality problem. Fix the routing integration and the seat expansion sells itself.

## Activity Log (append-only, newest first)

### 2026-02-12 — research (S-014)

DOI market-conduct exam confirmed for Q3 via state filing calendar. New COO's first town hall (LinkedIn post, 2026-02-10) named "claims cycle time" as metric #1. Implication: re-frame renewal narrative around cycle time for Priya, keep fraud-catch framing for Dana only. Logged `account_research`.

### 2026-01-28 — call debrief (S-011)

Quarterly check-in with Dana (45 min). What changed: March planning will decide SIU headcount → seat expansion window. Objection heard (Priya, relayed): "ClaimSight referrals don't show up in the adjuster workflow" — logged to catalog under Technical. Discovery gap identified: nobody owns the warehouse integration decision. Next actions set (see below). Logged `call_debriefed`, `objection_logged`.

### 2026-01-15 — email thread (S-009)

Dana forwarded our Q4 results one-pager to Priya unprompted (champion behavior — noted in stakeholder map). Priya's reply cc'd Marcus: "fits the consolidation review." Risk and opportunity in the same sentence. Logged `expansion_signal`.

## Objections Heard

- "Referrals don't show up in the adjuster workflow" (Priya via Dana, 2026-01-28) — Technical; response in catalog
- "This costs more than our current data vendor" (Marcus, 2025-11) — Price; resolved via cost-per-resolved-case reframe

## Open Questions / Discovery Agenda

- Who owns the data-warehouse integration decision? (blocking Layer-3 thesis)
- What does Marcus's consolidation review actually score on?
- Has the new COO's mandate changed Priya's 2026 priorities?

## Next Actions

- [ ] 2026-03-02: open Renewal Prep sequence (120-day mark)
- [ ] Before March planning: workflow-integration demo for Priya's team (fixes the real blocker)
- [ ] Identify the analytics lead → multi-threading play (concentration 71%)
