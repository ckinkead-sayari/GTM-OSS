# The Preamble

Every session starts with the same opening sequence. Claude reads a fixed set of files, scans for staleness, and announces the day's state before doing anything else. This makes the first 30 seconds of every conversation productive instead of a context-reload scramble.

## The sequence

On session start, before responding to the first message:

1. **`bash hooks/check-config.sh`** — fail loudly if `MY-CONFIG.md` is missing or incomplete. No work happens until config is valid.
2. **`git pull`** — pick up any changes pushed by scheduled tasks since the last interactive session.
3. **Read `memory/active-context.md`** — priorities, pipeline state, open actions, last three sessions of work.
4. **Read `TODOS.md`** — P0 items that need attention today.
5. **Read last 20 lines of `memory/handoff.jsonl`** — what scheduled tasks + other sessions did since last time.
6. **Check the Slack DM channel** (per `MY-CONFIG.md`) for scheduled-task outputs from the last 24 hours — pipeline updates, usage changes, call preps that may not be in the repo yet.
7. **Staleness scan**:
   - Pipeline entries with past-due actions → flag.
   - Open action items unchanged across 3+ sessions → flag.
   - Active context not updated in 14+ days → flag.
8. **Log `session_start` to `memory/analytics.jsonl`** with a new `session_id`.
9. **Announce**: current priorities, overdue items, P0 TODOs, anything notable from scheduled-task handoffs.
10. If no specific task requested, **recommend the highest-priority open item**.

Full spec: [`frameworks/preamble.md`](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/frameworks/preamble.md).

## Why this matters

Without the preamble, Claude walks into a session blind. It might:

- Draft outreach to an account you already emailed yesterday
- Propose a meeting you already scheduled
- Ignore a P0 item because nobody told it to look at TODOS.md
- Re-research an account whose file is already rich with Layer 2 / Layer 3 findings

With the preamble, Claude opens every session with the same situational awareness a good AM has on a Monday morning: what's urgent, what's stalled, what changed while I was away.

## What the preamble won't catch

The preamble gives Claude state, not judgment. It won't:

- Know whether a stale pipeline entry is actually stale vs. quietly moving offline
- Decide whether a P0 item is still P0 or got superseded
- Infer that a missing contact reply means "no" vs. "holiday"

That's still your call. The preamble just ensures Claude is asking the right questions, not starting from scratch.

## See also

- [The Frameworks](the-frameworks.md) — what Claude reads after the preamble, depending on your task.
- [Accretive Knowledge](accretive-knowledge.md) — why `active-context.md`, `handoff.jsonl`, and `accounts/*.md` compound over time.
- [ARCHITECTURE.md → Session Flow](https://github.com/ckinkead-sayari/GTM-OSS/blob/main/ARCHITECTURE.md) for the full lifecycle (preamble → work → end session).
