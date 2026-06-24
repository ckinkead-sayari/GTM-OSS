---
name: recreate-from-scratch
description: Rebuild the claudeGTM operating system in an empty folder from first principles — when you have no zip and no repo, only Claude Code and this one file. Regenerates the domain-agnostic skeleton (operating contract, enforcement hooks, framework playbooks, memory model, templates), then hands off to /bootstrap for the domain layer. Functionally equivalent to the kit, not byte-identical.
---

# /recreate-from-scratch — rebuild claudeGTM from nothing

## When to use this

- You have **no copy of the kit** — no zip, no template repo — but you have Claude Code and this one file (or its text pasted into a session).
- You want to **understand or audit** how the system is built, or regenerate a corrupted instance.
- **This is the fallback, not the normal path.** If you have the starter-kit zip or the template repo, use those — they are byte-exact. This regenerates *functionally equivalent* files from specification: the discipline is identical, the exact wording will differ.

## What this builds vs. what `/bootstrap` builds

- **This skill** builds the domain-AGNOSTIC skeleton: directory structure, the operating contract, the enforcement hooks, the framework playbooks, the memory model, the templates.
- **`/bootstrap`** (run after) builds the domain-SPECIFIC layer: your knowledge files, your config, your voice, MCP wiring, first dossiers.

## Operating principle

**This is a spec, not a copy.** Generate each file faithfully from the contracts below. Embed the *must-be-exact* bits verbatim (the non-negotiables, the banned-word list, the hook exit codes — they are reproduced in this file so they survive). For everything else, write clean implementations that satisfy the described behavior. Prefer fewer, correct files over a sprawling re-creation.

---

## Phase 0 — Orient & confirm

1. Confirm the target directory is **empty or new**. If it already contains claudeGTM files (`.claude/CLAUDE.md`, `frameworks/`), STOP — use `/bootstrap` or git to repair instead; do not overwrite working state.
2. Tell the user what you will create, and that **domain knowledge comes later** via `/bootstrap`.
3. Pick the target dir (default: current directory).

## Phase 1 — Scaffold the structure

Create: `.claude/commands/`, `frameworks/`, `hooks/`, `knowledge/`, `memory/retros/`, `memory/briefings/`, `accounts/`, `docs/start-here/`, `docs/concepts/`, `docs/reference/`, `deliverables/`, `tools/`.

## Phase 2 — The operating contract

Write **`.claude/CLAUDE.md`** (policy only — how to operate, never dated state). Sections, in order:

- **Non-Negotiables** — reproduce these nine verbatim (they ARE the contract):
  1. **Preamble first.** SessionStart hook prints a digest; act on it, then run the full preamble (`/preamble`). Mint session IDs with `hooks/next-session-id.sh` — never count events.
  2. **Research before outreach.** External search before ANY account-specific draft; log `account_research`; `hooks/check-research.sh` verifies. *Unresearched outreach burns relationships that took quarters to build.*
  3. **Warm before cold.** Check for a relationship path first; cold is the fallback. Early conversations are discovery, not pitches.
  4. **Read the framework before producing.** Task → read-first map; `hooks/check-framework.sh` enforces.
  5. **Quality-gate everything outbound.** A PreToolUse hook hard-blocks drafts that fail `check-quality.sh`. Drafts only — never auto-send. Never route around the gate.
  6. **Append, don't strand.** Debriefs/research aren't DONE until appended to `accounts/<name>.md`; sessions aren't done until analytics + handoff written and work committed.
  7. **Report completion status.** Every workflow ends DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT.
  8. **See something, say something.** Stale pipeline, overdue actions, objection/competitive patterns, missed expansion — flag in one sentence, unprompted.
  9. **This repo stays private.** It accumulates client data by design; if the digest's visibility probe warns the origin is public, fixing that outranks everything.
- **First Run** (run `/bootstrap`), **Who I Am** (`.claude/MY-CONFIG.md`), **How I Work** (be direct; search before answering; decide rather than ask five questions) including the 5-rule **Infrastructure Debugging** block (check postmortems → what layer → test in the real environment → "correct detection" isn't a fix → name patches honestly).
- **Session Lifecycle** — start (preamble) / end (roll active-context 3-session lookback, log `session_end`, append handoff, commit + push); **single-writer-to-main**; the analytics-event contract table.
- **Task Routing** — the task → read-first map with bracketed tool slots (`[your CRM MCP]`, `[your email MCP]`, …) that `/bootstrap` fills.
- **Writing Rules** — banned terms (Phase 3 list), calibration dials (TECHNICAL_DEPTH / DATA_DENSITY / FORMALITY per doc type), the discovery checklist.
- **Infrastructure Policy**, **Reference Index**.

Also write **root `CLAUDE.md`** (a short project map pointing to `.claude/CLAUDE.md` as the contract) and **`AGENTS.md`** (maps the same contract onto non-Claude agents — hooks run manually, slash commands become procedures).

## Phase 3 — Enforcement hooks + wiring

Write each as portable bash (`set -uo pipefail`; resolve `REPO_ROOT` from `${BASH_SOURCE[0]}` so it's fork-portable; `grep -iF` for any user-supplied string). Implement to the contract:

- **`check-quality.sh`** — read text (arg or stdin); fail (non-zero + printed reasons) on any banned term, >2 em-dashes, or outreach length/subject violations. **Banned terms (embed verbatim):** `seamless`, `leverage`, `next-gen`, `cutting-edge`, `comprehensive solution`, `In today's rapidly evolving landscape`, `It's important to note`, generic CTAs (`Schedule a demo!`), round-number claims (`10x`, `99.9%`). Use a single category-scanning helper, `grep -F`.
- **`check-outbound-quality.sh`** — PreToolUse hook on `*create_draft*`; parse the draft text from the tool-call JSON on stdin; run check-quality; **exit 2 to block** on violation (banned language physically cannot reach a draft).
- **`check-research.sh "Account"`** — grep `memory/analytics.jsonl` for an `account_research` event for that account this session; non-zero if absent.
- **`check-framework.sh <type>`** — map task type → required framework file(s); confirm the read happened.
- **`check-config.sh`** — verify `.claude/MY-CONFIG.md` exists and required fields are populated.
- **`check-mcp.sh`** — read `memory/mcp-status.json`; fail on any `BROKEN`, on staleness >24h, or on the `unconfigured` seed (report "setup pending", not "FAILED").
- **`next-session-id.sh`** — read the max `S-NNN` from `analytics.jsonl`, emit the next. Never count events (counting double-mints).
- **`session-start.sh`** — SessionStart hook. Read-only, fast, **`exit 0` always** (never abort a session). Print a digest: config check, MCP state, git branch + uncommitted count, a 5s-bounded fail-silent **public-remote visibility probe** (warn loudly if origin is public and dossiers/analytics exist), staleness flags (active-context age, handoff gap, account-file freshness), P0 count + oldest backlog age, and a fresh-fork `/bootstrap` hint.
- **`session-end.sh`** — SessionEnd hook. If uncommitted paths remain, append an `unclean_session_end` marker to `handoff.jsonl` so the next session confronts stranded work.
- **`git-safe.sh`** — serialize git ops; clear stale `index.lock`/`HEAD.lock`/`ORIG_HEAD.lock` (ghost-aware: ignore read-only VM fds, back off on real holders); exit codes 1 (live holder) / 2 (serialization timeout) / 3 (virtiofs EPERM → host reaper resolves). Scheduled tasks route ALL git through this.
- **`reap-git-locks.sh` + `install-reaper.sh` + the `.plist`** — optional macOS host-side launchd reaper (only needed for git-on-macOS-sandbox; skip on Linux/no-git). Document it as a patch, not a cure.

Then write **`.claude/settings.json`** wiring: `SessionStart` → `session-start.sh`, `SessionEnd` → `session-end.sh`, `PreToolUse` on `*create_draft*` → `check-outbound-quality.sh`. `chmod +x hooks/*.sh`.

## Phase 4 — Framework playbooks

For each, write a playbook with **when-to-use → the method (numbered steps) → anti-patterns → the completion bar**. Generate from these one-line specs (≈19):

- `outreach.md` — hook/pain/credibility/ask; 4–6 sentences; research-first, warm-before-cold.
- `sequences.md` — multi-touch flows, sourcing contacts into flows, launch hygiene, event-registration drive.
- `business-case.md` — make the prospect evaluate their own data; the case *is* the sales process.
- `champion-doc.md` — the 1-pager a champion forwards into the budget meeting.
- `objections.md` — living objection catalog (category, frequency, response framework, evidence); the retro mines it.
- `call-debrief.md` — 7-point post-call debrief; NOT DONE until appended to the dossier.
- `account-dossier.md` — per-account file template + append-only Activity Log rules.
- `expansion.md` — MEDDPICC, "You Said / We Did", renewal/upsell/QBR.
- `multi-threading.md` — the play when one contact is >60% of engagement/usage.
- `onboarding.md` — tracking accounts through onboarding/stabilization.
- `retro.md` — the weekly retro workflow (pipeline health, trends, patterns, next-week focus).
- `preamble.md` — the full session-start protocol (the SessionStart digest is detection; this is the protocol).
- `completion-status.md` — DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT definitions.
- `document-quality.md` — the writing bar that `check-quality.sh` enforces, in prose.
- `task-preamble.md` — shared scheduled-task coordination. **Step 0 heartbeat FIRST** (log `task_start` + a `task_started` handoff line before git pull or any read — a task that dies in setup must still leave a trace), `git-safe pull` (never raw `git pull`), retry/fallback, handoff format, git-sync via git-safe.
- `task-coordination.md` — DAG, retries, idempotency, MCP-fallback for scheduled tasks.
- `scheduled-tasks-reference.md` — the optional task catalog + per-task spec (start with zero tasks).
- `cross-signal-detector.md` / `expert-panel.md` — optional advanced analysis playbooks (generate stubs if unfamiliar).

## Phase 5 — Templates + memory seed

- `knowledge/`: `README.md` (the knowledge model) + `domain-summary.template.md`, `product-capabilities.template.md`, `call-prep-bundle.template.md`, `communication-playbook.template.md`.
- `.claude/MY-CONFIG.template.md` (identity, territory, accounts, service IDs, tool map).
- `accounts/README.md` + a fictional `accounts/EXAMPLE-*.md` worked dossier (shows the layers + Activity Log).
- `memory/`: empty `analytics.jsonl`, `handoff.jsonl`, `task-registry.jsonl`; `mcp-status.json` = the `unconfigured` seed (so day-1 digest says "setup pending"); skeleton `active-context.md` (priorities / pipeline / session index / What-Happened / action items) and a `TODOS.md` skeleton.
- `.gitignore` (ignore `.claude/MY-CONFIG.md`, `knowledge/communication-playbook.md`, `deliverables/`, `.DS_Store`, `claudeGTM-starter-kit.zip`, `site/`), `VERSION`, `LICENSE` (MIT), `README.md`, `ETHOS.md`, `ARCHITECTURE.md` (start its "Infrastructure Postmortems" section).

## Phase 6 — Hand off

- Tell the user: **run `/bootstrap`** to build the domain layer (knowledge, config, voice, MCP wiring, first dossiers).
- Optional, no account required: `git init` locally for version history (no remote needed); back up the folder with Time Machine or a cloud drive; on macOS+git, `bash hooks/install-reaper.sh`.

## Phase 7 — Verify

- `bash -n` every hook; confirm `chmod +x`; run `bash hooks/check-config.sh` (expects MY-CONFIG missing → that's the `/bootstrap` cue) and confirm the SessionStart digest prints without error.
- Report **DONE / DONE_WITH_CONCERNS** with a one-line inventory of what was generated and what `/bootstrap` still needs to fill.

---

## Honest limitation

Regenerated files are **functionally equivalent, not byte-identical** to upstream. For an exact copy, use the starter-kit zip or the template repo. This path exists so the *system survives even if every artifact is lost* — the architecture is the asset, and it fits in this one file.
