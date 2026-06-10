# Frameworks Reference

All frameworks live in `frameworks/` at the repo root. Each encodes the structure and discipline for a specific GTM task. Full content in the files; this page is an index.

## Content frameworks

| File | When it fires |
|------|---------------|
| [`outreach.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/outreach.md) | Drafting cold emails, warm intros, LinkedIn messages, event follow-ups |
| [`business-case.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/business-case.md) | Building a data-driven case the prospect walks into their budget meeting with |
| [`champion-doc.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/champion-doc.md) | 1-page forwardable doc for internal champions to share |
| [`sequences.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/sequences.md) | Multi-touch cadences: cold outbound, warm reactivation, event follow-up, renewal prep, churn intervention |
| [`call-debrief.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/call-debrief.md) | 7-point post-call structure — attendees, what they said, objections, next step, follow-up |
| [`objections.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/objections.md) | Objection catalog with response frameworks by category |
| [`expansion.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/expansion.md) | Trigger-based upsell, QBR structure, renewal strategy, multi-threading |
| [`multi-threading.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/multi-threading.md) | Concentration-risk playbook — triggered at >60% |
| [`onboarding.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/onboarding.md) | New-account 30/60/90 cadence, Graph + Data File milestones, intervention triggers |
| [`retro.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/retro.md) | Weekly GTM retrospective — pipeline health, activity, patterns, recommendations |
| [`cross-signal-detector.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/cross-signal-detector.md) | Pattern recognition across accounts (regulatory, competitive, objection clusters) |
| [`expert-panel.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/expert-panel.md) | Multi-persona review for high-stakes deliverables |

## Discipline frameworks

| File | Purpose |
|------|---------|
| [`preamble.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/preamble.md) | Session startup sequence |
| [`document-quality.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/document-quality.md) | Anti-slop rules, banned language, formatting standards |
| [`completion-status.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/completion-status.md) | DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT protocol |

## Infrastructure frameworks

| File | Purpose |
|------|---------|
| [`task-preamble.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/task-preamble.md) | Shared boilerplate all scheduled tasks run |
| [`task-coordination.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/task-coordination.md) | Dependency DAG, retry policy, trace events, idempotency |
| [`scheduled-tasks-reference.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/frameworks/scheduled-tasks-reference.md) | Per-task reference — lazy-loaded |

## When to add a new framework

Signals:

- A situation keeps coming up and you handle it differently each time
- Your retro flags "no framework existed for X"
- You find yourself reaching for a framework adjacent to what you actually need and forcing-fitting it

Signals *not* to add one:

- A one-off task that won't recur
- Something that's really a knowledge-base update, not a structural task (those go in `knowledge/`)

Keep frameworks focused: one file = one task type. If you're tempted to add "and also…" to a framework header, you probably need a second framework.

## See also

- [The Frameworks](../concepts/the-frameworks.md) — conceptual overview of task-to-file routing.
- [.claude/CLAUDE.md](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/.claude/CLAUDE.md) — the canonical routing table.
