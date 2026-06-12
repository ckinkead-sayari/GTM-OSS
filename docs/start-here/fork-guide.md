# Fork Guide

Detailed setup for forking claudeGTM. Expect ~30 minutes end-to-end for the framework + infrastructure, plus additional time to build your domain knowledge (see [Customize for Your Domain](customize-for-your-domain.md)).

For the short version, start with [Quick Start](quick-start.md). This page is the full workflow.

---

## What you're getting

- Persistent GTM operating system for Claude Code + Claude Cowork
- 18 GTM frameworks — outreach, business cases, champion docs, call debriefs, sequences, expansion, multi-threading, onboarding, retros, objections
- 5 enforcement hooks — quality (anti-slop), research, framework, config, git-lock reaper
- Three-component health scoring pattern (Leading / Lagging / Context)
- Session continuity that picks up where the last conversation ended
- Optional: 10 scheduled-task patterns (usage sync, daily briefing, call prep, lead scanning, sequences, pipeline sync, renewal tracker, staleness checks, retro)

**What you're NOT getting:** domain knowledge, product knowledge, competitive positioning. Those are specific to your industry and your product. `/bootstrap` builds them with you — or, if a teammate already runs this system, [Team Adoption](team-adoption.md) imports theirs. Questions a new user actually asks (data safety, cost, "I'm not technical"): [FAQ & Glossary](faq.md).

---

## Prerequisites

- **Claude Code** (Max plan if you want scheduled tasks) or Claude Cowork
- **GitHub account** — your instance lives in a **private** repo you create from this template
- **macOS** for the host-side git-lock reaper (Linux works with a manual workaround)
- **MCP connectors** for whatever tools you use (start small — see [Connect Your Stack](connect-your-stack.md))
- **~30 minutes** for framework setup; `/bootstrap` builds the domain knowledge with you in another ~30–45

---

## Setup

### 1. Create your private repo from the template

Your instance accumulates client data from the first session — dossiers, pipeline, debriefs, analytics. **It must be private, and GitHub cannot make a fork of a public repo private — don't use the Fork button.**

```bash
gh repo create my-gtm --private --clone --template https://github.com/ckinkead-sayari/GTM-OSS
cd my-gtm
```

Without `gh`: GitHub UI → **Use this template** → visibility **Private** → clone the repo you created. The SessionStart digest re-verifies your remote's visibility every session as a backstop.

### 2. Create your instance config

```bash
cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md
```

Fill in:

- **Who I Am** — name, role, territory, account list
- **Tool / service IDs** — your email, calendar, CRM, analytics MCPs. Delete sections for tools you don't use.

Validate:

```bash
bash hooks/check-config.sh
```

The script tells you which fields are still missing. Fix and re-run until green.

### 3. Build your knowledge files — run `/bootstrap`

This is where the framework becomes your tool, and you shouldn't do it as homework. Open the workspace in Claude Code and run **`/bootstrap`**: Claude interviews you, researches your market and product, and writes `knowledge/domain-summary.md`, `knowledge/product-capabilities.md`, and `knowledge/communication-playbook.md` for you — then wires your tool routing and creates your first dossier stubs. Phases are skippable and resumable.

Prefer the manual path, or want to understand what good looks like before generating it?

→ **[Customize for Your Domain](customize-for-your-domain.md)**

### 4. Your communication playbook (the part worth your attention)

Whichever path you took, the voice file deserves real input: ~10–30 sent emails across contexts (cold, warm, post-call, negotiation). Claude extracts opening/closing patterns, length by context, tone markers, and the phrases you never use. This is what makes drafted outreach sound like you instead of like a model.

Gitignored per fork. Stays personal.

### 5. Install the host-side git-lock reaper (macOS)

```bash
bash hooks/install-reaper.sh
```

Registers a launchd LaunchAgent that polls every 10s and reaps orphan `.git/index.lock` files left by Cowork sessions. Without it, session-end commits may need manual `rm -f .git/index.lock` on the host.

Uninstall: `bash hooks/install-reaper.sh --uninstall`.

### 6. Connect your MCP tools

The routing table in `.claude/CLAUDE.md` works in capability *slots* (email, calendar, CRM, analytics, enterprise search, …). `/bootstrap` phase 5 maps your connectors into it and probes each one; the slot-by-slot reference — including the **minimum viable stack** (email + calendar + web search is a real day-one setup) and what degrades when a slot is empty — lives here:

→ **[Connect Your Stack](connect-your-stack.md)**

For scheduled tasks, MCPs need to be **Local** (not cloud / project-scoped) — cloud-scoped MCPs may not resolve reliably at task runtime.

### 7. (Optional) Set up scheduled tasks

See [`frameworks/scheduled-tasks-reference.md`](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/frameworks/scheduled-tasks-reference.md) for patterns. Start with zero tasks — add them as you feel the manual-toil pain. Common starting points:

- `daily-briefing` — morning priorities digest
- `external-call-prep` — pre-stage call briefs for the day's meetings
- `pipeline-sync` — refresh opportunity state nightly

Your Mac must be awake + Claude Code Desktop open for tasks to fire. Tasks route all git ops through `hooks/git-safe.sh`.

### 8. First session

Open Claude Code, load your fork as workspace. The preamble should:

1. Run `hooks/check-config.sh` → PASS
2. Load `MY-CONFIG.md` into working memory
3. Read `active-context.md`, `TODOS.md`, `handoff.jsonl`
4. Announce your identity and priorities

If it doesn't, the preamble will tell you what's missing.

---

## What's shared vs. personal

| Layer | Shared with the template | Personal to your fork |
|-------|--------------------------|-----------------------|
| Architecture | `ARCHITECTURE.md`, `ETHOS.md`, `.claude/CLAUDE.md` | `.claude/MY-CONFIG.md` |
| Frameworks | `frameworks/*.md` | — |
| Knowledge | `knowledge/*.template.md` (structure) | `knowledge/*.md` (your domain content) |
| Hooks | `hooks/*.sh`, `hooks/*.plist` | — |
| Templates | `MY-CONFIG.template.md`, `communication-playbook.template.md` | — |
| Accounts | — | `accounts/*.md` |
| Memory | — | `memory/active-context.md`, `analytics.jsonl`, `handoff.jsonl`, `task-registry.jsonl`, `reap-log.jsonl` |

Your domain knowledge files (`knowledge/domain-summary.md`, `knowledge/product-capabilities.md`) stay in your fork. Only the `.template.md` files and frameworks are shared.

---

## Staying current with framework improvements

The upstream template keeps improving (frameworks, hooks, docs). Because you created your repo from the template, there's no fork relationship — add upstream as a remote once:

```bash
git remote add upstream https://github.com/ckinkead-sayari/GTM-OSS.git
git fetch upstream
git merge upstream/main --allow-unrelated-histories --no-edit   # first time only; afterwards plain `git merge upstream/main`
```

**Ownership zones — what's yours vs. shared:**

| Zone | Files | On conflict |
|------|-------|-------------|
| Yours, always | `memory/*`, `accounts/*`, `.claude/MY-CONFIG.md`, `knowledge/*.md` (your built files) | Keep yours: `git checkout --ours <path>` |
| Shared, take upstream | `frameworks/*`, `hooks/*`, `docs/*`, `knowledge/*.template.md` | Take upstream unless you customized deliberately — then re-apply your delta |
| Merge by hand | `.claude/CLAUDE.md` | Your routing-table fills vs. upstream structural improvements — three-way merge, keep your tool names |

Check the upstream changelog/commits before merging so you know what you're taking. If you've improved something shared, consider contributing it back — **from a clean clone, never from this working repo** (your git history contains client data; see CONTRIBUTING.md in the upstream repo).

---

## Troubleshooting

- **`CONFIG CHECK FAILED`** — run `bash hooks/check-config.sh`; it names missing fields.
- **MCP tools unavailable in scheduled tasks** — verify MCPs in Claude Code settings. Tasks need Local, not Cloud, MCPs.
- **Scheduled tasks not firing** — Mac must be awake with Desktop app open at scheduled time.
- **`fatal: Unable to create '.git/index.lock'`** — if the reaper is running, wait 15s and retry. If not, `rm -f .git/index.lock` manually and install the reaper.
- **Claude sounds generic despite domain-summary.md existing** — check `.claude/CLAUDE.md`'s routing table. `knowledge/domain-summary.md` should be listed under outreach / business case / objections / expansion tasks.

---

## Questions

Open an issue on this repo.
