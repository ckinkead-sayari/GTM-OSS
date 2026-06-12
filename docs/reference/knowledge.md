# Knowledge Base Reference

The `knowledge/` directory is the single biggest lever in the system: it's what turns generic LLM output into content that reads like someone who knows your industry, your product, and your voice. This page documents the knowledge **model** — which files exist, what each is for, and when Claude reads them.

The kit ships templates; `/bootstrap` builds your versions (or import a teammate's via [Team Adoption](../start-here/team-adoption.md)).

## Core files (build these — `/bootstrap` phases 2–4)

| File | What it holds | Read before |
|------|---------------|-------------|
| `domain-summary.md` | One page: your vertical's pain points, regulatory/market drivers, named competitors + why you win, proof points with sources, buyer personas | Every outreach, call prep, objection, business case |
| `product-capabilities.md` | What your product actually does, by module — recent releases, integration points, and **what it does NOT do** (the honest-gaps section prevents overclaiming) | Call prep, champion docs, competitive conversations |
| `communication-playbook.md` | Your email voice, extracted from your sent mail: openings, closings, length by context, tone markers, never-say list. **Gitignored — personal.** | Any outbound draft |

## Optional deep files (build when you feel the one-pager's limit)

| File | What it holds | When it earns its place |
|------|---------------|------------------------|
| `domain-strategy.md` | The deep-dive behind the one-pager: full regulatory detail, competitive vulnerability matrices, expanded proof points | Full business cases, new-account onboarding at scale, competitive reviews |
| `call-prep-bundle.md` | Consolidated pre-call checklist: domain + product + health signals + discovery questions in one load | If your call prep develops vertical-specific steps (template included) |
| Positioning packs (e.g. `technical-positioning.md`) | A focused pack for one recurring conversation type — a technical/API/agent story, a regulation, a use case. Pattern: framing, verified numbers, objection rows, persona tailoring, what-NOT-to-claim | When the same hard conversation keeps recurring and you're re-deriving the answer each time |

## Tool references (only for tools you actually use)

| File | What it holds |
|------|---------------|
| `chrome-automation-patterns.md` *(ships)* | Browser-automation patterns: setup, zoom-for-extraction, checkpoints, parallel research |
| `gemini-delegation.md` *(ships)* | Delegating huge-context scans and Google Docs creation to a second model |
| Your own additions (e.g. an analytics mapping file) | Account-to-identifier mappings, query patterns, data-quality gates for YOUR analytics stack |

## Rules that keep the knowledge base honest

1. **One page beats ten.** The domain summary is capped at one printed page because that's what reliably gets read in-session. Depth goes in `domain-strategy.md`, loaded only when the task warrants it.
2. **Source of truth, refreshed not contradicted.** Sessions augment knowledge files with fresh research; if research contradicts a file, the file gets corrected — never silently overridden.
3. **Read once per session.** Knowledge files load when their task type starts, then Claude works from memory (see `.claude/CLAUDE.md` → Working Efficiently).
4. **Living documentation.** Product capabilities go stale fastest — update on every release that changes what you can promise. A stale capabilities file produces commitments your product can't keep.
