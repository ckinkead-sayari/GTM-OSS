# Quick Start

Five steps. Clone, configure, validate, install the host reaper, run your first session. ~15 minutes for the framework; 1–3 hours additional to fill in your domain knowledge (see step 3).

Prerequisites:

- macOS (Linux works but the host-side git-lock reaper is macOS-only — see [fork guide](fork-guide.md))
- Claude Code or Claude Cowork
- Git + bash + `lsof` installed (all default on macOS)
- MCP connectors for whatever tools you use (email, calendar, CRM, analytics)

---

## 1. Clone your fork

```bash
git clone git@github.com:ckinkead-sayari/GTM-OSS.git
cd claudeGTM
```

If you want to pull future framework improvements from an upstream repo:

```bash
git remote add upstream [upstream-repo-url]
```

---

## 2. Create your config

Your personal data (accounts, tool/service IDs) lives in one file that stays in your fork.

```bash
cp .claude/MY-CONFIG.template.md .claude/MY-CONFIG.md
```

Open `.claude/MY-CONFIG.md` and fill in:

- **Who I Am** — name, role, territory, key accounts
- **Tool / Service IDs** — only the tools you actually use; delete the rest

Validate:

```bash
bash hooks/check-config.sh
```

Expected: `CONFIG CHECK PASSED`. If anything is missing, the script tells you which field.

---

## 3. Customize for your domain

This is where the framework becomes your tool. You can start with a basic setup and iterate — don't try to fill everything in on day one.

Minimum viable setup (30–60 minutes):

```bash
cp knowledge/domain-summary.template.md knowledge/domain-summary.md
cp knowledge/product-capabilities.template.md knowledge/product-capabilities.md
cp knowledge/communication-playbook.template.md knowledge/communication-playbook.md
```

Then fill those in. See [Customize for Your Domain](customize-for-your-domain.md) for the full walkthrough and a verification checklist.

Without this step, Claude will produce generic GTM output. With it, Claude sounds like someone who knows your industry, your product, and your voice.

---

## 4. Install the host-side git-lock reaper (macOS)

Cowork sessions write files via virtiofs, and the sandbox can't `unlink` its own `.git/index.lock` after a commit. Without the reaper, session-end commits may need manual cleanup.

```bash
bash hooks/install-reaper.sh
```

Expected output:

```
[install-reaper] Rendering plist (paths -> /path/to/your/clone) -> ~/Library/LaunchAgents/com.claudegtm.git-reaper.plist
[install-reaper] Bootstrapping LaunchAgent...
[install-reaper] Installed and running.
```

Verify:

```bash
launchctl list | grep claudegtm-git-reaper
```

The reaper polls every 10 seconds, touches only `~/claudeGTM/.git/index.lock`, respects live holders and mid-op state (merge/rebase/cherry-pick), and logs every reap to `memory/reap-log.jsonl`.

Uninstall any time with `bash hooks/install-reaper.sh --uninstall`.

---

## 5. First session

Open Claude Code (or Cowork), load this folder as your workspace, and let the preamble run. On session start Claude will:

1. Run `bash hooks/check-config.sh` — should pass.
2. Load your `MY-CONFIG.md` into working memory.
3. Read `memory/active-context.md` — priorities, pipeline state, open actions (empty on a fresh fork).
4. Read `TODOS.md` and the last 20 lines of `memory/handoff.jsonl`.
5. Scan for stale data.
6. Announce your identity, current priorities, and anything flagged.

On a fresh fork, Claude will say there's no session history yet and recommend starting with one account at a time.

---

## What happens next

- **Work an account.** Ask Claude to "research [account name]" — it will run external research, log findings to `accounts/[name].md`, and flag competitive / regulatory signals.
- **Draft outreach.** Ask Claude to "draft a cold email to [contact] at [account]." The framework hook forces reading `frameworks/outreach.md` and `knowledge/domain-summary.md` first; the research hook forces a research log to exist first; the quality hook catches banned language.
- **Debrief calls.** After a call, Claude writes a 7-point debrief to `accounts/[account].md`, logs objections, drafts the follow-up.
- **End the session.** Say "end session." Claude rolls `active-context.md` forward, logs analytics, commits, pushes.

See [Introduction](introduction.md) for the operating philosophy, or jump to [Fork Guide](fork-guide.md) for role-specific setup (AM vs CS), MCP connectors, and optional scheduled tasks.
