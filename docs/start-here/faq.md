# FAQ & Glossary

Answers to the questions every new user asks in their first week — especially if you're a seller, not an engineer.

---

## "I'm in sales, not engineering. Is this for me?"

Yes — that's the target user. You never need to write code. The terminal commands in the docs exist so the setup is scriptable, but **Claude can run all of them for you**: open the folder in Claude Code, say "set this up — run the quick start," and let it drive. `/bootstrap` was built exactly so that setup is a conversation, not a config exercise.

What you DO need: your accounts, your sent emails (for the voice file), and opinions about your market. That's the part Claude can't supply.

## "How is this different from just chatting with Claude?"

Two things a fresh chat can never give you:

1. **Memory that compounds.** Every research finding, debrief, and objection lands in files the next session reads. By week three, Claude argues with you from your own evidence ("the claims-ops seats went dormant in January — that's the expansion blocker").
2. **Enforcement.** Plain Claude will happily draft an unresearched cold email full of "seamless solutions." Here, hooks physically block that: research-before-outreach is checked, banned language can't reach a draft, skipped session-ends leave a visible marker.

## "Is my data safe?"

The repo is designed to hold client data — that's its job — so the protections are layered:

- **Your repo must be private** (the quick start creates it private from birth; the session digest re-checks visibility every session and warns loudly if it's public with data inside).
- **The most personal files never enter git:** `.claude/MY-CONFIG.md` and `knowledge/communication-playbook.md` are gitignored.
- **Nothing leaves your machines** beyond what your own MCP connectors do. There's no telemetry, no phone-home; the system is markdown + bash in a git repo you own.
- If you contribute improvements upstream, do it from a clean clone — never from your working repo (see CONTRIBUTING in the upstream repo).

## "Do I need all those MCP connectors?"

No. Email + calendar + built-in web search is a real day-one setup; CRM and analytics earn their place later. See [Connect Your Stack](connect-your-stack.md) for the slot map and what degrades when a slot is empty.

## "What does it cost to run?"

The system itself is free (MIT). You pay for Claude: a normal working session (research + outreach + debrief) is comfortably within a Claude Pro/Max subscription's daily use. Scheduled background tasks add more volume — which is one reason the kit ships with **zero** enabled. Start manual; automate only what hurts.

## "What if I forget to say 'end session'?"

A SessionEnd hook leaves an unclean-termination marker in the handoff log, and the next session's digest confronts you with it ("1 uncommitted path — a prior end-session was missed"). You lose convenience, not data — but make "end session" a habit; unrolled context is the one thing the next session can't reconstruct.

## "Can my whole team share one repo?"

No — one repo per person, by design (your voice, your accounts, your pipeline state). What teams SHOULD share is the expensive part: domain knowledge, product truth, and the objection catalog. That's the [Team Adoption](team-adoption.md) path — a new teammate imports those files during `/bootstrap` and is productive on day one instead of week three.

## "We already have a CRM / enablement stack. Why this?"

This isn't a CRM replacement — it's the working layer on top: the place where research, drafting, debriefs, and discipline actually happen, wired to your CRM through MCP. Your CRM stays the system of record for the pipeline; this is the system of work for the seller.

## "Something's broken."

Run the order of operations: `bash hooks/check-config.sh` → `bash hooks/check-mcp.sh` → the Troubleshooting table in the [Fork Guide](fork-guide.md). If a hook itself misbehaves, `ARCHITECTURE.md` → Infrastructure Postmortems documents the known failure modes and their real fixes.

---

## Glossary

| Term | Meaning |
|------|---------|
| **Session** | One working conversation with Claude in this workspace, from preamble to end-session. The unit of work and of memory. |
| **Preamble** | The startup ritual (`/preamble`): load config, check MCPs, read context + handoff, mint a session ID, announce priorities. |
| **Digest** | The automatic SessionStart hook output — config/MCP/git/staleness status printed before you type anything. |
| **Dossier** | One markdown file per account (`accounts/<name>.md`) accumulating research, stakeholders, debriefs, and objections. Append-only Activity Log. |
| **Framework** | A task playbook in `frameworks/` (outreach, debrief, expansion…). Claude must read the relevant one before producing — enforced. |
| **Knowledge file** | Your domain/product/voice truth in `knowledge/`. Built once (by `/bootstrap`), read every session. |
| **Active context** | `memory/active-context.md` — rolling priorities, pipeline table, and a 3-session lookback. The first thing every session reads. |
| **Handoff log** | `memory/handoff.jsonl` — append-only cross-session journal (summaries, task outputs, unclean-end markers). |
| **Analytics** | `memory/analytics.jsonl` — append-only event log (research done, outreach drafted, objection logged…). The weekly retro mines it. |
| **Hook** | A shell script that enforces a rule. Three run automatically via Claude Code (digest, end-marker, outbound quality gate); the rest run on demand. |
| **MCP** | Model Context Protocol — how Claude connects to your tools (email, CRM, calendar…). A "connector." |
| **Retro** | The weekly review (`"retro"`): pipeline health, activity patterns, what worked, next week's focus — computed from your analytics, not vibes. |
| **Sequence / flow** | A multi-touch outreach cadence (`frameworks/sequences.md`). "Flow" is the same concept inside tools like Gong Engage. |
