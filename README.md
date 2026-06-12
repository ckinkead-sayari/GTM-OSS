# claudeGTM

**Stop starting from zero.** Persistent context and enforced discipline for GTM work with Claude.

A forkable operating system for account managers, sellers, and CS reps doing deep-account work with Claude Code. Every session gets your account context, your voice, your frameworks, and your pipeline state — and a set of hooks makes the discipline mechanical instead of optional.

License: MIT · Contributions welcome ([CONTRIBUTING.md](CONTRIBUTING.md)) · Docs: [`docs/`](docs/index.md) (auto-deploys to GitHub Pages)

---

## The problem

```
Without claudeGTM                        With claudeGTM
─────────────────                        ──────────────
Session 1: Research ACME Bank            Session 1: Research ACME Bank
           Draft outreach                           Draft outreach
           Send, done                               Debrief logged, context updated,
                                                    quality + research hooks enforced

Session 2: Research ACME Bank (again)    Session 2: "Continue ACME"
           Guess what you said last time            → reads active-context
           Draft a different email                  → loads your domain knowledge
                                                    → knows the warm path exists
                                                    → drafts an on-voice reply in minutes

Every session starts cold.               Context compounds. Each session leaves
                                         Claude smarter than it found it.
```

## What's in the box

| Layer | What it gives you |
|-------|-------------------|
| `frameworks/` | 19 task playbooks: outreach, sequences, business case, champion doc, objections, call debrief, expansion/QBR, multi-threading, onboarding, retro, account dossier, … |
| `hooks/` | 13 enforcement scripts. Three are **wired into Claude Code's hook system** and run automatically: a SessionStart digest (config, git state, staleness, P0 age), a SessionEnd marker (catches sessions that die with uncommitted work), and a PreToolUse gate that **blocks email drafts containing banned language** before they reach your drafts folder. |
| `memory/` | The continuity model: rolling active context (3-session lookback), append-only analytics + handoff logs, MCP health probes. |
| `.claude/` | The operating instructions (policy-only, ~15KB) plus three slash commands: `/bootstrap` (guided first-run setup — Claude writes your knowledge files for you), `/preamble` and `/end-session` (the two session rituals). |
| `knowledge/` | Templates for your domain knowledge, product capabilities, and communication voice. You fill these in; the system reads them before every relevant task. |
| `accounts/` | One dossier per key account with append-only Activity Log discipline — research compounds instead of evaporating. |
| Scheduled tasks | An optional catalog (usage sync, briefings, pipeline staleness checks, weekly retro, …) for the Claude Code Desktop app. Start with zero; add when you feel manual-toil pain. |
| Git infrastructure | A lock-safe git wrapper + host-side reaper, hardened by several documented production postmortems (`ARCHITECTURE.md`). |

## Quick start (~15 minutes to running, ~45 with your knowledge built)

> **⚠️ Your copy must be PRIVATE.** Within a week this repo holds your account dossiers, pipeline state, and call debriefs — client data. GitHub cannot make a fork of a public repo private, so **don't use the Fork button**. Create a private repo from the template instead:

```bash
# one command, private from birth (this repo is a GitHub template):
gh repo create my-gtm --private --clone --template https://github.com/ckinkead-sayari/GTM-OSS
cd my-gtm
```

(No `gh`? GitHub UI → **Use this template** → set visibility **Private** → clone yours.)

Then open the folder as a Claude Code workspace and run **`/bootstrap`** — a guided ~30-minute session where Claude interviews you, researches your market and product, writes your knowledge files, wires your tool routing, and creates your first account dossiers. The SessionStart digest and preamble take it from there every session after.

Full walkthrough: [Quick Start](docs/start-here/quick-start.md) · [Fork Guide](docs/start-here/fork-guide.md) · **[An Example Session](docs/start-here/example-session.md)** (watch the whole loop run before you commit to anything).

## What you bring

The kit ships the framework; the value comes from what you encode:

- **Your vertical** — `knowledge/domain-summary.md` (pain points, regulatory drivers, competitive landscape, buyer personas — from the template)
- **Your product** — `knowledge/product-capabilities.md` (what it actually does, so Claude never overclaims)
- **Your voice** — `knowledge/communication-playbook.md` (analyze ~30 of your sent emails; outreach then sounds like you, not like AI)
- **Your accounts** — `accounts/*.md`, built up as you research (a fictional worked example ships at `accounts/EXAMPLE-northwind-insurance.md` so you can see what a dossier looks like after a few sessions)

`/bootstrap` builds the first three with you in one guided session. Manual walkthrough, if you prefer it: [Customize for your domain](docs/start-here/customize-for-your-domain.md).

## The enforcement model

Instructions in a prompt are polite suggestions; under deadline pressure they get skipped. So the rules here exist at two levels:

- **Soft** — `.claude/CLAUDE.md` opens with eight non-negotiables, each with its *why* (research before outreach, warm before cold, read the framework first, append-don't-strand, …). Works in any Claude environment.
- **Hard** — shell scripts validate the work, and three run mechanically via Claude Code's hook system. Banned marketing language physically cannot reach an email draft; a skipped session-end leaves a visible marker the next session must confront.

The design principle throughout: **one fact, one home** — policy lives in instructions, state lives in memory, procedures live in frameworks. Nothing is duplicated, so nothing silently rots.

## Docs

The full documentation site (concepts, per-hook reference, scheduled-task specs) lives in [`docs/`](docs/index.md) and **deploys to GitHub Pages automatically** via `.github/workflows/docs.yml` on every push to `main`. After your first push, enable Pages (Settings → Pages → deploy from `gh-pages` branch) if GitHub hasn't done it for you, then set `site_url` in `mkdocs.yml`.

Local preview:

```bash
python3 -m venv .venv-docs && source .venv-docs/bin/activate
pip install -r requirements-docs.txt && mkdocs serve
```

## Provenance & privacy

This repository is the sanitized, domain-neutral extraction of a production system that runs a real Tier-1 enterprise account book. It is published through an automated pipeline with a hard leak gate (client names, personal identifiers, contact data) and is **born with fresh git history** — there is no commit ancestry to any private data. What you're reading survived several months of daily use, a few infrastructure postmortems, and one full-system audit; the scars are documented in [`ARCHITECTURE.md`](ARCHITECTURE.md).

## Operating principles

Full text in [ETHOS.md](ETHOS.md):

- **Research before outreach** — external research happens before any draft, enforced.
- **Warm before cold** — cold is the fallback, never the default.
- **Listen before pitching** — early conversations are discovery.
- **No marketing fluff** — "seamless", "leverage", "in today's rapidly evolving landscape" are blocked at the tool layer.
- **Complete the work** — no half-researched emails; every workflow reports DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT.
- **See something, say something** — stale data, overdue items, and patterns get flagged unprompted.

## License

MIT — see [LICENSE](LICENSE). Use it, fork it, ship it inside your team. If you improve the framework itself, a PR upstream is appreciated ([CONTRIBUTING.md](CONTRIBUTING.md)).
