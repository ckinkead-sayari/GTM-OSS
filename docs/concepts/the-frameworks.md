# The Frameworks

Frameworks are the "how" files. Each one describes a specific GTM task (drafting outreach, running a call debrief, building a champion doc) with the structure, discipline, and examples Claude should follow.

The idea: **don't generate GTM content without reading the relevant framework first.** Frameworks encode patterns that are hard-won; Claude's default training isn't a substitute.

## Task-to-file routing

`.claude/CLAUDE.md` contains a routing table that maps tasks to the framework files that must be read first:

| Task | Reads |
|------|-------|
| Drafting outreach | `frameworks/outreach.md` + `knowledge/communication-playbook.md` + banking knowledge |
| Building a business case | `frameworks/business-case.md` + `knowledge/domain-summary.md` |
| Creating a champion doc | `frameworks/champion-doc.md` |
| Handling objections | `frameworks/objections.md` |
| Post-call debrief | `frameworks/call-debrief.md` |
| Expansion / upsell | `frameworks/expansion.md` |
| Weekly retro | `frameworks/retro.md` |
| Outbound sequences | `frameworks/sequences.md` |
| Multi-threading (concentration >60%) | `frameworks/multi-threading.md` |
| Onboarding a new account | `frameworks/onboarding.md` |
| Call prep | `knowledge/call-prep-bundle.md` (consolidated bundle) |

Full routing table: [`.claude/CLAUDE.md`](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/.claude/CLAUDE.md).

## Why reading first

Every framework enforces a minimum shape:

- **Outreach:** Hook → Pain → Credibility → Ask. 4-6 sentences. Subject line includes the prospect's company name.
- **Business case:** Problem → Approach → Outcomes. Prospect's data, not product features.
- **Call debrief:** 7 explicit points — attendees, what they said, what they meant, objections heard, expansion signals, next step, follow-up draft.
- **Champion doc:** 1 forwardable page. Internal-sell sheet, not a pitch deck.

Without the framework, Claude's default output drifts toward generic. With it, every artifact starts from a known-good structure.

## Where the content comes from

Frameworks encode:

1. **Patterns you've seen work** — structures that close deals, cadences that get replies, debriefs that surface real objections.
2. **Anti-patterns you've seen fail** — generic pitches, round-number claims, CTAs like "Schedule a demo!", hedging language, marketing fluff.
3. **Forcing functions** — discovery questions you'd forget under pressure, "see something say something" flags, completion status protocols.

When you notice a pattern working (or failing), you update the framework. The framework compounds.

## Logging framework usage

After Claude reads a framework, it logs one line to `memory/analytics.jsonl`:

```json
{"event":"framework_used","framework":"outreach","account":"ACME","ts":"...","action":"drafted cold email"}
```

The weekly retro (`frameworks/retro.md`) mines this log. Patterns that emerge:

- Which frameworks get used most? Least?
- Which accounts get attention? Which are quietly neglected?
- Where are the framework gaps — situations you handled with no file to read?

## See also

- [Enforcement Hooks](enforcement-hooks.md) — how framework reading is verified, not just requested.
- [Reference → Frameworks Index](../reference/frameworks.md) — all 18 frameworks, what they do, when they fire.
- [ETHOS.md](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/ETHOS.md) — the six operating principles that frameworks encode.
