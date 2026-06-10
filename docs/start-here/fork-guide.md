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

**What you're NOT getting:** domain knowledge, product knowledge, competitive positioning. Those are specific to your industry and your product. The kit ships templates + a customization guide for filling them in.

---

## Prerequisites

- **Claude Code** (Max plan if you want scheduled tasks) or Claude Cowork
- **GitHub account** (for your fork)
- **macOS** for the host-side git-lock reaper (Linux works with a manual workaround)
- **MCP connectors** for whatever tools you use (email, calendar, CRM, analytics, enterprise search)
- **~30 minutes** for framework setup; **1–3 hours** for domain customization

---

## Setup

### 1. Clone your fork

```bash
git clone git@github.com:ckinkead-sayari/GTM-OSS.git
cd claudeGTM
```

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

### 3. Customize for your domain

This is where the framework becomes your tool. See the full walkthrough:

→ **[Customize for Your Domain](customize-for-your-domain.md)**

Minimum viable setup (30–60 minutes):

```bash
cp knowledge/domain-summary.template.md knowledge/domain-summary.md
cp knowledge/product-capabilities.template.md knowledge/product-capabilities.md
```

Then fill those in with your industry's pain points, regulatory drivers, buyer personas, and what your product actually does.

### 4. Create your communication playbook

```bash
cp knowledge/communication-playbook.template.md knowledge/communication-playbook.md
```

Analyze ~30 of your sent emails to extract your voice — opening/closing patterns, email length by context, tone markers, phrases you never use. This is what makes drafted outreach sound like you.

Gitignored per fork. Stays personal.

### 5. Install the host-side git-lock reaper (macOS)

```bash
bash hooks/install-reaper.sh
```

Registers a launchd LaunchAgent that polls every 10s and reaps orphan `.git/index.lock` files left by Cowork sessions. Without it, session-end commits may need manual `rm -f .git/index.lock` on the host.

Uninstall: `bash hooks/install-reaper.sh --uninstall`.

### 6. Connect your MCP tools

Whichever you use. Edit `.claude/CLAUDE.md`'s Tool Routing table to reflect your actual setup. Typical MCPs:

- Email (Gmail / Outlook / etc.)
- Calendar (GCal / Outlook)
- CRM (Salesforce / HubSpot / etc.)
- Product analytics (Mixpanel / Amplitude / Heap)
- Enterprise search (Glean / Coveo / native)
- Chat (Slack / Teams)
- Docs (Notion / Confluence / Google Docs)
- Call recording / analysis (Gong / Chorus / Fathom)

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

If this kit came from an upstream repo and you want to pull future improvements to frameworks / hooks / docs:

```bash
git remote add upstream [upstream-repo-url]
git fetch upstream
git merge upstream/main --no-edit
```

**Merge conflicts**:
- `memory/*` or `accounts/*` → always keep your version (`git checkout --ours memory/ accounts/`)
- `knowledge/*.md` (your domain files) → always keep your version
- `knowledge/*.template.md` → review upstream changes, they may improve the template structure
- `frameworks/*` → take upstream unless you've customized heavily
- `.claude/CLAUDE.md` → three-way merge usually needed — your routing table vs. upstream structural improvements

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
