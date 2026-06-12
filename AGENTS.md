# AGENTS.md — Operating Contract for Any Coding Agent

This repository is a single-user GTM operating system. It was built on Claude Code, but the system is **markdown + bash + git** — any capable agent (Codex/ChatGPT, Cursor, Zed, Amp, …) can run it. This file maps the contract onto tools that don't have Claude Code's hooks or slash commands.

**The canonical operating instructions are [`.claude/CLAUDE.md`](.claude/CLAUDE.md). Read that file FIRST, in full, and follow it. This file only covers what differs outside Claude Code.**

---

## The five rules that are never optional

1. **Research before outreach.** External research (and a logged `account_research` event in `memory/analytics.jsonl`) before ANY account-specific draft. Verify with `bash hooks/check-research.sh "<Account>"`.
2. **Warm before cold.** Check email/calendar/CRM history for a relationship path before drafting cold.
3. **Drafts, never sends.** Create email drafts for human review. No agent in this repo auto-sends anything, ever.
4. **Append, don't strand.** Research and debriefs end with a dated append to `accounts/<name>.md`; sessions end with analytics + handoff written and work committed + pushed.
5. **This repo stays private.** It accumulates client data by design. Check the git remote's visibility; if it's public, stop and fix that first.

## Hook emulation — run these manually at the right moments

Claude Code fires three of these automatically. Your tool probably doesn't, so the agent must run them explicitly:

| Moment | Run | Claude Code equivalent |
|--------|-----|------------------------|
| Session start (before any work) | `bash hooks/session-start.sh` then follow `frameworks/preamble.md` | SessionStart hook + `/preamble` |
| Before any task type | `bash hooks/check-framework.sh <type>` (types listed in the script) | enforced by instruction |
| Before saving/creating ANY outbound draft | `bash hooks/check-quality.sh <draft-file>` — if it fails, rewrite; do not send the failing text through another channel | PreToolUse gate on email drafts (hard block) |
| Session end (user says "end session" / "wrap up") | Follow `.claude/commands/end-session.md` step by step | `/end-session` |

## Command emulation

The `.claude/commands/*.md` files are plain procedures — read the file and execute its steps:

- **First-run setup:** `.claude/commands/bootstrap.md` — interview + research → write `knowledge/` files → fill the tool slots in `.claude/CLAUDE.md`'s routing table with YOUR tool's integrations (the bracketed `[your CRM MCP]` slots are capability slots; MCP is Claude's connector tech, but the slot concept applies to whatever integrations your tool has — substitute or mark `— (manual)`).
- **Session rituals:** `.claude/commands/preamble.md` and `.claude/commands/end-session.md`.

## What doesn't transfer

- **MCP probing** (`memory/mcp-status.json`): specific to Claude's connectors. With another tool, record your own integration checks there in the same JSON shape, or leave the file as shipped and treat data fetches as manual.
- **Scheduled tasks** (`frameworks/scheduled-tasks-reference.md`): designed for Claude Code Desktop. Treat as a catalog of automation patterns to re-implement in your scheduler of choice — keep the git-safety rule (`hooks/git-safe.sh`) if you do.
- **Claude-specific phrasing** in docs ("Claude reads…", "/bootstrap"): read as "the agent".

## Style contract (applies to every agent)

Writing rules in `.claude/CLAUDE.md` → "Writing Rules" are enforced by `hooks/check-quality.sh`, not by vibes: banned marketing vocabulary, 4–6 sentence outreach, prospect-specific first lines, no invented metrics or case studies. The gate script is the arbiter — run it.
