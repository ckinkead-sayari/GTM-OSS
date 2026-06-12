# claudeGTM — Project Map

A forkable operating system for deep-account GTM work with Claude. **The operating manual is [`.claude/CLAUDE.md`](.claude/CLAUDE.md) — its Non-Negotiables section is the contract; read it first.** This file is just the map. (Using a non-Claude agent? Start at [`AGENTS.md`](AGENTS.md).)

## Where things live

- `.claude/CLAUDE.md` — operating instructions: non-negotiables, first-run, session lifecycle, task routing, writing rules, infra policy, reference index
- `.claude/commands/` — `/bootstrap` (guided first-run setup), `/preamble` and `/end-session` (the two session rituals)
- `frameworks/` — task playbooks (outreach, sequences, business case, champion doc, objections, debrief, expansion, retro, account dossier, …)
- `knowledge/` — YOUR institutional knowledge (built by `/bootstrap` from templates; read before every relevant task)
- `hooks/` — enforcement scripts; three are wired into Claude Code's hook system via `.claude/settings.json` (SessionStart digest, SessionEnd marker, outbound draft gate)
- `memory/` — rolling state: active-context, analytics.jsonl, handoff.jsonl, mcp-status.json
- `accounts/` — one dossier per key account (append-only Activity Log; fictional worked example included)
- `deliverables/` — client-facing working artifacts. Gitignored. Never at repo root
- `docs/` — the documentation site (auto-deploys to GitHub Pages)

## Repo-level ground rules

- **This repo must stay PRIVATE** — it accumulates client data by design (the session digest verifies this).
- Git: single-writer-to-main; scheduled tasks route git through `hooks/git-safe.sh`.
- Recurring infra problem? Read `ARCHITECTURE.md` → Infrastructure Postmortems before patching.
