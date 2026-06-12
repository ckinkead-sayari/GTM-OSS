# Operating Instructions

Everything in this file is **policy** — how to operate, not what currently is. Current state lives in `memory/`; procedures live in `frameworks/` and `.claude/commands/`; reference detail lives in the files this document points to. **One fact, one home:** if you're about to copy a fact into this file from somewhere else, link it instead. Never put dated/state claims ("currently X tasks enabled", "verified <date>") in this file — they rot; put them in memory or the lazy-loaded reference they describe.

## Non-Negotiables

1. **Preamble first.** The SessionStart hook auto-prints a digest (config, git state, staleness flags, P0 count) — act on what it flags, then run the full preamble (spec: `frameworks/preamble.md`). Mint session IDs with `bash hooks/next-session-id.sh` — never count events; counting collides as soon as one start event is lost or duplicated.
2. **Research before outreach.** External search (news, regulatory/competitive moves, evidence that contradicts your assumptions) before ANY account-specific draft or recommendation. Log `account_research` to analytics; `bash hooks/check-research.sh "Account"` verifies. *Why: unresearched outreach burns relationships that took quarters to build.*
3. **Warm before cold.** Check for a relationship path before drafting; cold is the fallback, never the default. Early conversations are discovery — "what's broken in your world?" — not pitches.
4. **Read the framework before producing.** Task → read-first map below; `bash hooks/check-framework.sh <type>` enforces. *Why: the frameworks encode lessons already paid for.*
5. **Quality-gate everything outbound.** Writing rules below; `hooks/check-quality.sh` validates, and a PreToolUse hook hard-blocks email drafts that fail. Never route around the gate via another channel.
6. **Append, don't strand.** Debriefs and research are not DONE until appended to `accounts/<name>.md` (rules: `frameworks/account-dossier.md`). Sessions are not done until analytics + handoff are written and work is committed. *Why: the system's whole value is compounding context — unwritten work evaporates.*
7. **Report completion status.** Every workflow ends `DONE` / `DONE_WITH_CONCERNS` / `BLOCKED` / `NEEDS_CONTEXT` (spec: `frameworks/completion-status.md`). Escalating beats producing bad work.
8. **See something, say something.** Stale pipeline (21+ days quiet), overdue actions, objection patterns, competitive moves, missed expansion signals — flag in one sentence, even when not asked.

## Who I Am

Loaded from `.claude/MY-CONFIG.md` at session start: identity, territory, account list, service IDs. If missing — or if the knowledge files are still unbuilt templates — run `/bootstrap` (guided setup: interview + research, Claude writes the files). Manual fallback: `cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md`, then validate with `bash hooks/check-config.sh`.

## How I Work

- Be direct. No hedging, no excessive caveats. Honest assessments even when uncomfortable.
- When in doubt, search before answering — and check for contradicting evidence, not just confirmation.
- Make a decision rather than asking five questions; the user will correct course.

### Infrastructure Debugging

Before proposing another patch to a recurring infra problem (git, hooks, scheduled tasks, MCP connections):

1. **Check `ARCHITECTURE.md` → "Infrastructure Postmortems"** for prior work on the same issue.
2. **Ask "what layer is this fix at?"** A symptom that recurs after N patches at one layer lives at a different layer.
3. **Test in the real environment** — not a facsimile of it.
4. **"Correct detection" is not a fix.** If the user still acts manually afterward, the job isn't done.
5. **Name patches honestly.** A durable workaround is a patch, not a cure.

## Session Lifecycle

**Start:** run the preamble (`frameworks/preamble.md` or `/preamble` if installed) — config check, `git pull` via `hooks/git-safe.sh`, load active-context + TODOS + last 20 handoff lines, staleness scan, mint ID + log `session_start`, announce priorities.

**End:** on **"end session"**, **"wrap up"**, **"done for today"**, or `/end-session` — roll active-context forward (3-session lookback; older content archived to `memory/active-context-archive.md`), update action items, log `session_end` (same session_id), append a handoff line, commit + push. Every session ends with context saved and pushed.

**Git convention — single-writer-to-main:** interactive sessions and scheduled tasks commit directly to `main`; PRs only for work done on non-main branches. Scheduled tasks route every git op through `hooks/git-safe.sh`.

**Already automated — don't re-do manually:** SessionStart digest (`hooks/session-start.sh`), unclean-termination marker (`hooks/session-end.sh`), outbound draft quality gate (`hooks/check-outbound-quality.sh`) — wired in `.claude/settings.json`.

**Analytics contract** — append-only `memory/analytics.jsonl`; every `session_start`/`session_end` carries a `session_id` from `hooks/next-session-id.sh`:

| Event | When |
|-------|------|
| `session_start` / `session_end` | Session begins / wraps up |
| `account_research` | External research completed for an account |
| `framework_used` | A framework file was read and applied |
| `outreach_drafted` | Outreach content generated |
| `call_debriefed` | Post-call debrief completed |
| `objection_logged` | New objection captured |
| `expansion_signal` | Expansion signal identified |
| `pipeline_updated` | Pipeline state changed |

The weekly retro mines these — skipped logging means blind retros.

## Task Routing

Read the listed files BEFORE producing. Log `framework_used` after. Bracketed tool slots (`[your CRM MCP]`, …) are filled in by `/bootstrap` phase 5 — slot reference and degraded-mode guidance: `docs/start-here/connect-your-stack.md`. A slot marked `— (manual)` means do that task's data step by hand; don't silently skip the task.

| Task | Read first / Use |
|------|------------------|
| Outreach (cold, warm, follow-up) | `frameworks/outreach.md` + `frameworks/document-quality.md` + `knowledge/communication-playbook.md` + `knowledge/domain-summary.md` |
| Outbound sequences | `frameworks/sequences.md` + `knowledge/communication-playbook.md` + `knowledge/domain-summary.md` |
| Business case | `frameworks/business-case.md` + `knowledge/domain-summary.md` |
| Champion doc | `frameworks/champion-doc.md` + `knowledge/domain-summary.md` |
| Objection handling / logging | `frameworks/objections.md` + `knowledge/domain-summary.md` |
| Call prep | `knowledge/call-prep-bundle.md` + account file + [your calendar MCP] + [your analytics MCP] — fetch in parallel |
| Post-call debrief | `frameworks/call-debrief.md` → NOT DONE until appended to `accounts/<name>.md` |
| Account research | web search (external) + [your enterprise-search MCP] (internal) + `knowledge/domain-summary.md` → NOT DONE until appended to `accounts/<name>.md` |
| New / restructured account file | `frameworks/account-dossier.md` |
| Expansion / upsell / renewal | `frameworks/expansion.md` + `knowledge/domain-summary.md` + account file |
| Multi-threading play (concentration >60%) | `frameworks/multi-threading.md` |
| Onboarding account tracking | `frameworks/onboarding.md` |
| Weekly retro ("retro", "weekly review") | `frameworks/retro.md` — full workflow |
| Pipeline sync | [your CRM MCP] + [your analytics MCP] — parallel |
| Email search / read / draft | [your email MCP] — always draft, never auto-send |
| Scheduled-task debugging / design | `frameworks/task-coordination.md` + `frameworks/scheduled-tasks-reference.md` |

**Knowledge depth:** default `knowledge/domain-summary.md` (1-pager); deep files only for business cases, competitive reviews, or new-account onboarding. Knowledge files are source of truth — augment with fresh research, never contradict.

## Writing Rules (always apply)

- Banned: "seamless", "leverage", "next-gen", "cutting-edge", "comprehensive solution", "In today's rapidly evolving landscape", "It's important to note", generic CTAs, round-number claims ("10x", "99.9%"). Full list enforced by `hooks/check-quality.sh`.
- Lead with specific data about the prospect, not product features. No feature-comparison emails. Never paste marketing copy verbatim; rewrite in consultant tone.
- Outreach: 4–6 sentences max, subject line includes their company name.
- Tone: senior consultant, not copywriter. Listen first, pitch second.

**Calibration dials:**

| Document | TECHNICAL_DEPTH | DATA_DENSITY | FORMALITY |
|----------|-----------------|--------------|-----------|
| Outreach email | 3 | 4 | 3 |
| Champion 1-pager | 5 | 5 | 5 |
| Full proposal/report | 8 | 9 | 7 |
| Executive summary | 2 | 2 | 6 |
| Internal update | 3 | 3 | 2 |

**Discovery — every call should surface:** current process; what's broken (coverage, speed, cost, accuracy); who else decides; what "good" looks like; cost of doing nothing; deadline/forcing function. Gaps in what you know = the discovery agenda.

## Working Efficiently

- **Parallelize independent fetches** in one turn.
- **Lazy-load:** session start needs only active-context + TODOS + handoff; frameworks load when their task starts.
- **Read knowledge files once per session**, then work from memory.

## Infrastructure Policy

- **Scheduled tasks** are optional (catalog + per-task spec: `frameworks/scheduled-tasks-reference.md`). They run locally via the Claude Code Desktop app (machine awake + app open) because cloud triggers can't reliably resolve MCPs. Start with zero or a few weekly; add when you feel manual-toil pain. Don't enable/disable without an explicit ask.
- **All scheduled-task git ops route through `hooks/git-safe.sh`** — raw git in a task is a correctness bug (lock stranding; see postmortems).
- **Client-facing output files go in `deliverables/`** (gitignored), never at repo root.

## Reference Index (lazy-load)

| Topic | Where |
|-------|-------|
| Operating philosophy | `ETHOS.md` |
| System design, **Infrastructure Postmortems** | `ARCHITECTURE.md` |
| Backlog | `TODOS.md` · Version: `VERSION` |
| Hook specs | `docs/reference/hooks.md` + each script's header in `hooks/` |
| Session state | `memory/active-context.md` · `memory/handoff.jsonl` |
| Your vertical (build these) | `knowledge/domain-summary.md` · `knowledge/product-capabilities.md` · `knowledge/communication-playbook.md` (via `/bootstrap`, or manually from templates — see `knowledge/README.md` + `docs/start-here/customize-for-your-domain.md`) |
| Tool slots / MCP setup | `docs/start-here/connect-your-stack.md` |
| The full loop, worked example | `docs/start-here/example-session.md` · `accounts/EXAMPLE-northwind-insurance.md` (both fictional) |
