---
description: Guided first-run setup — interview + research, then Claude writes your knowledge files, wires your tool routing, and creates your first dossiers
---

Execute the Bootstrap Protocol. This replaces the 3–5 hours of "fill in the templates" homework with a guided working session (~30–45 minutes): you answer questions and paste raw material; Claude does the research, the synthesis, and the writing. The knowledge files Claude produces here are the same files every future session reads before outreach, call prep, and objection handling — quality here pays compound interest.

**Ground rules for this protocol:**

- Run ONE phase at a time, in order. Announce each phase before starting it. Ask at most 3–4 questions per turn — batch them; never interrogate one question at a time.
- **Idempotent and resumable.** Before each phase, check whether its output file already exists and differs from its `.template.md`. If it's already built, say so and offer to skip, refresh, or rebuild. NEVER overwrite a non-template file without explicit confirmation.
- Every phase is skippable on request ("skip voice for now") — record skipped phases in the final report so they can be re-run later.
- The Writing Rules in `.claude/CLAUDE.md` apply to the knowledge files themselves: specific over generic, no marketing fluff, honest about gaps. A knowledge file full of brochure language poisons every downstream draft.
- Web-research claims before writing them. If the user's answer and your research disagree, surface the discrepancy — don't silently pick one.

## Phase 0 — Preflight (no questions; ~1 minute)

1. **Privacy check.** Get the origin remote (`git remote get-url origin`). If `gh` is available, check visibility (`gh api repos/<slug> --jq .visibility`). If the repo is **public**: STOP and warn loudly — account dossiers, pipeline state, and analytics will be committed here; the repo must be private (`gh repo edit <slug> --visibility private` or via GitHub Settings). Offer to wait. A public GTM working repo is the one mistake this system cannot undo.
2. Inventory what exists vs. template: `.claude/MY-CONFIG.md`, `knowledge/domain-summary.md`, `knowledge/product-capabilities.md`, `knowledge/communication-playbook.md`, `memory/mcp-status.json` (seed says `"unconfigured"`). Report the inventory in one line each, then start with the first missing piece.

## Phase 1 — Identity → `.claude/MY-CONFIG.md` (~3 minutes)

Ask (one batch): name + role; territory/segment; key accounts (just names — 5–15); which tools they use day-to-day (email, calendar, CRM, product analytics, enterprise search, call recording, chat, docs — names only, IDs come in Phase 5).

Write `.claude/MY-CONFIG.md` from `.claude/MY-CONFIG.template.md`, deleting sections for tools they don't use. Validate with `bash hooks/check-config.sh` and show the result.

## Phase 2 — Domain knowledge → `knowledge/domain-summary.md` (~10 minutes)

The single highest-leverage file in the system. Two inputs, then you write it:

1. **Interview** (two batches max):
   - What do you sell, in one sentence, and to whom? What are the 3–5 problems your buyers actually complain about (their words, not your category's words)?
   - What forces buying — regulation, cost pressure, a competitor's move, an internal deadline? Who are your top 3 competitors and the one-line reason you win against each? 2–3 proof points with real numbers and sources?
   - Buyer personas: who champions, who signs, who blocks — and what does each care about?
2. **Research** to verify and fill gaps: search the vendor's market category, the named competitors' current positioning, and any regulatory/market driver the user cited. Flag anything that contradicts the interview answers.

Write `knowledge/domain-summary.md` (structure from the template, **one printed page maximum** — longer won't get read in-session). Then verify the wiring: answer "what's our positioning in this vertical, in one sentence?" from the file alone, and show the user. If it sounds generic, rewrite before moving on.

## Phase 3 — Product truth → `knowledge/product-capabilities.md` (~8 minutes)

1. **Research first:** the company website, docs site, release notes/changelog if public. Draft the module/capability inventory from evidence.
2. **Interview to correct:** what did research get wrong or miss? Most recent 2–3 releases that matter in deals? And the question that makes this file trustworthy: **what does the product NOT do that prospects assume it does?** (Honest gaps prevent overclaiming in every future draft.)

Write the file from the template. Include the gaps section — it is the most valuable part.

## Phase 4 — Voice → `knowledge/communication-playbook.md` (~8 minutes)

Ask the user to paste 10–30 sent emails across contexts (cold, warm follow-up, post-call, renewal/negotiation, internal) — or, if an email MCP is connected, ask permission to pull recent sent mail and select the spread yourself.

Extract: opening and closing patterns, length by context, tone markers, recurring phrases, and the **never-say list** (things in their writing's negative space). Write the file from the template. Remind them it's gitignored — personal, stays out of the repo.

If they have no corpus to share, write a minimal version from 3 style questions and mark it `DRAFT — refine after 2 weeks of real drafts`.

## Phase 5 — Wire the stack → routing table + `memory/mcp-status.json` (~5 minutes)

1. List the MCP tools actually available in this session and map them to the capability slots (reference: `docs/start-here/connect-your-stack.md`).
2. **Edit `.claude/CLAUDE.md`'s Task Routing table in place:** replace each bracketed placeholder (`[your CRM MCP]`, `[your analytics MCP]`, …) with the real connector name. For slots the user doesn't have, mark the row's tool as `— (manual; see connect-your-stack.md)` rather than deleting the task row.
3. Probe each connected MCP with one cheap read-only call. Write `memory/mcp-status.json`: per-MCP `status` (`OK`/`BROKEN`/`DEGRADED`), the `probe_tool` + `probe_args` used (so future preambles can re-probe), `last_probe_ts` (UTC ISO), and a `probe_session` field of `bootstrap`. This replaces the `"unconfigured"` seed and turns the digest's MCP line live.

## Phase 6 — First dossiers → `accounts/` (~3 minutes)

1. Create a dossier stub from the template in `frameworks/account-dossier.md` for the user's top 3 accounts (from MY-CONFIG): Snapshot and Stakeholder Map headers filled with what the user can state right now, everything else left as headed empty sections. Do NOT pad with researched filler — dossiers earn content through real sessions.
2. Offer to delete `accounts/EXAMPLE-northwind-insurance.md` (the fictional example) or keep it as a reference.

## Phase 7 — Verify, commit, hand off (~3 minutes)

1. Run `bash hooks/check-config.sh` and `bash hooks/check-mcp.sh` — both should pass clean now; show the output.
2. Commit everything created (stage specific files, never `git add -A`; `communication-playbook.md` is gitignored and will be correctly absent): commit message `bootstrap: instance configured — knowledge files, routing, MCP probes, first dossiers`. Push.
3. Report completion status (`DONE` / `DONE_WITH_CONCERNS` / `BLOCKED`) with: files written, phases skipped, discrepancies surfaced during research, and gaps the user should close.
4. Point at what's next: work ONE real account through the full loop (`docs/start-here/example-session.md` shows it end-to-end), and the first-two-weeks arc in `docs/start-here/quick-start.md`.
