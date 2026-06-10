# TODOS

Unified backlog for your claudeGTM instance. Organized by category with P0-P3 priorities.

Structure (keep this — Claude knows it):

- **P0** — This week. Urgent + important.
- **P1** — Next 2 weeks.
- **P2** — Ongoing / background.
- **P3** — Nice to have / deferred.

## Pipeline

### [P0] First account — run full workflow end-to-end

**What:** Pick one priority account. Run external research, draft outreach, debrief when there's a reply. Validates the whole loop with real data.
**Why:** Until you've run the full loop once, you won't trust the system.
**Effort:** M
**Priority:** P0
**Status:** NOT STARTED

### [P0] Populate active-context.md with real pipeline state

**What:** Fill in the pipeline table in `memory/active-context.md` with your real accounts, stages, ARRs, close dates, next actions.
**Why:** The system can't track pipeline health or flag stale deals without this data.
**Effort:** S
**Priority:** P0
**Status:** NOT STARTED

## Framework / Infrastructure

### [P1] Fill in `knowledge/domain-summary.md`

**What:** Copy from `knowledge/domain-summary.template.md` and fill in your industry's pain points, regulatory drivers, buyer personas, proof points.
**Why:** Every outreach, call prep, and objection routes through this file. Without it, Claude produces generic GTM output.
**Effort:** M (30–60 min for first pass; iterate over weeks)
**Priority:** P1
**Status:** NOT STARTED

### [P1] Fill in `knowledge/product-capabilities.md`

**What:** Copy from `knowledge/product-capabilities.template.md`. Document what your product does by module/tier. Include recent features and honest gaps.
**Why:** Call preps, champion docs, and competitive conversations all reference this.
**Effort:** M (1–2 hours; keep updating as product ships)
**Priority:** P1
**Status:** NOT STARTED

### [P1] Build `knowledge/communication-playbook.md`

**What:** Analyze ~30 of your sent emails. Extract patterns: opening/closing, length by context, tone, recurring phrases.
**Why:** Makes drafted outreach sound like you, not a generic LLM.
**Effort:** M (1–2 hours, needs access to your sent folder)
**Priority:** P1
**Status:** NOT STARTED

## Tools / MCPs

### [P2] Connect the MCPs you actually use

**What:** Edit `.claude/CLAUDE.md`'s Tool Routing table to reflect your real setup. Remove rows for tools you don't use.
**Why:** Claude routes workflows through the tools listed there.
**Effort:** S
**Priority:** P2
**Status:** NOT STARTED

## Scheduled Tasks (optional)

### [P3] Evaluate scheduled tasks as manual toil emerges

**What:** See `frameworks/scheduled-tasks-reference.md` for patterns. Start with zero tasks. Add specific ones when you feel the manual-toil pain.
**Why:** Tasks compound value but add operational complexity. Don't set them up speculatively.
**Effort:** Varies per task
**Priority:** P3
**Status:** NOT STARTED
