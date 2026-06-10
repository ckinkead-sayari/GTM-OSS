# claudeGTM

**Stop starting from zero.** Persistent context and enforced discipline for GTM work with Claude.

A forkable operating system for account managers and CS reps doing deep-account GTM work with Claude Code (or Cowork). Gives every Claude session your account context, your voice, your frameworks, and your pipeline state — so each conversation picks up where the last one stopped instead of starting over.

## Get Started

Docs render directly on GitHub:

→ **[docs/index.md](docs/index.md)** — landing page, site map, start here
→ **[docs/start-here/quick-start.md](docs/start-here/quick-start.md)** — 5-step hands-on setup (~15 min)
→ **[docs/start-here/fork-guide.md](docs/start-here/fork-guide.md)** — detailed fork workflow
→ **[docs/start-here/customize-for-your-domain.md](docs/start-here/customize-for-your-domain.md)** — fill in your industry + product knowledge
→ **[docs/start-here/introduction.md](docs/start-here/introduction.md)** — the operating philosophy

**Want a searchable local docs site?** mkdocs-material config is included:

```bash
python3 -m venv .venv-docs && source .venv-docs/bin/activate
pip install -r requirements-docs.txt
mkdocs serve    # http://127.0.0.1:8000 with auto-reload
```

## What This Does

Stores the frameworks, memory, enforcement hooks, and instructions that make Claude sessions persistent and opinionated. When mounted as a workspace folder, Claude reads these files automatically and operates with full context: your accounts, how outreach should be structured, what tone to use, what to avoid, and what happened in prior sessions.

Without this repo, every session starts from zero. With it, Claude picks up where it left off.

## What You Fill In Yourself

The kit gives you the framework. You bring:

- **Your industry knowledge** — `knowledge/domain-summary.md` (start from the template)
- **Your product knowledge** — `knowledge/product-capabilities.md` (start from the template)
- **Your voice** — `knowledge/communication-playbook.md` (analyze ~30 of your sent emails)
- **Your account context** — `accounts/*.md` (one per key account, built as you research)

See [docs/start-here/customize-for-your-domain.md](docs/start-here/customize-for-your-domain.md) for the walkthrough.

## How It Works

1. Start a session. Claude reads `.claude/CLAUDE.md` → triggers the **preamble**: loads active context, checks for stale data, announces priorities.
2. Before generating any prospect-facing content, Claude reads the relevant framework file and logs the usage.
3. **Hooks enforce discipline**: research must exist before outreach, quality checks catch banned language, framework reading is verified.
4. Every workflow reports a **completion status**: DONE, DONE_WITH_CONCERNS, BLOCKED, or NEEDS_CONTEXT.
5. At session end, say "end session" — Claude rolls memory forward, commits, pushes.

## Enforcement Model

- **Soft hooks** (CLAUDE.md instructions): work in every Claude environment. Claude follows rules because they're written.
- **Hard hooks** (shell scripts in `hooks/`): validation steps before producing output. Can be wired into Claude Code's PreToolUse hook system for automated blocking.

Both layers needed. Soft alone drifts; hard alone feels punitive. Together they remove the cost of good behavior.

## Key Principles

Full detail in [ETHOS.md](ETHOS.md).

- **Research before outreach.** External research on the account happens before any draft.
- **Warm before cold.** Default to warm intros. Cold is the fallback, not the default.
- **Listen before pitching.** Early conversations are discovery.
- **No marketing fluff.** Banned: "seamless", "leverage", "in today's rapidly evolving landscape." Enforced by `hooks/check-quality.sh`.
- **Session continuity.** `active-context.md` carries forward what happened, what's open, what's next.
- **Complete the work.** No half-researched emails, no skipped follow-ups.
- **See something, say something.** Flag stale data, overdue items, patterns.
