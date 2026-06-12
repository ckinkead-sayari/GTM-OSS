# Connect Your Stack

The frameworks route tasks to capability *slots*, not to specific vendors. This page maps each slot to common MCP connectors, tells you which slots you can skip, and what degrades when you do.

`/bootstrap` (phase 5) walks this with you and rewrites the routing table in `.claude/CLAUDE.md` to match what you actually connected. This page is the reference behind that step.

---

## The capability slots

| Slot (as it appears in the routing table) | What the system uses it for | Common connectors |
|---|---|---|
| `[your email MCP]` | Searching threads for prior context, creating drafts (never auto-send) | Gmail, Outlook |
| `[your calendar MCP]` | Call prep (today's external meetings), scheduling context | Google Calendar, Outlook Calendar |
| `[your CRM MCP]` | Pipeline sync, opportunity state, contact/account lookups | Salesforce, HubSpot, Attio, Close |
| `[your analytics MCP]` | Product usage for health scoring and expansion signals | Mixpanel, Amplitude, Heap, Pendo |
| `[your enterprise-search MCP]` | Internal context: past decks, tickets, call notes, wiki | Glean, Notion search, Google Drive search |
| Call recording | Transcripts for debriefs, competitor mentions, objection mining | Gong, Fireflies, Granola, Fathom |
| Chat | Scheduled-task output channel, team signal mining | Slack, Teams |
| Docs | Knowledge-base sync, shared artifacts | Notion, Confluence, Google Docs |

Where to find connectors: Claude Code's `/mcp` command lists what's configured; the Anthropic MCP connector directory and your vendor's docs cover setup. Most of the tools above ship official or well-maintained MCP servers.

---

## Minimum viable stack

You do not need all eight slots to get value on day one:

- **Day 1:** web search (built in) + email + calendar. That covers research-before-outreach, warm-path checks, drafting, and call prep — the core loop.
- **Week 2:** CRM. Pipeline sync stops being manual; the retro gets real data.
- **When expansion work starts:** product analytics. Health scoring and expansion signals need usage data.
- **Nice to have:** enterprise search, call recording, chat, docs. Each one removes a manual step; none blocks the core loop.

---

## What degrades without each slot

| Missing slot | What still works | What you do instead |
|---|---|---|
| CRM | Everything except automated pipeline sync | Maintain the pipeline table in `memory/active-context.md` by hand at session end |
| Analytics | All outreach/debrief/expansion workflows | Health scoring is N/A — use call/email recency as your staleness proxy |
| Enterprise search | External research, email-thread context | Web search + email search carry internal context |
| Call recording | Debriefs still happen | Debrief from your own notes within 24h of the call (the framework prompts you) |
| Email | Research, prep, dossiers | Draft in chat, copy out manually — the quality gate still validates content |

When a slot is empty, delete or mark its routing-table rows so the preamble doesn't keep flagging a tool that was never going to be there.

---

## Two rules that don't depend on your stack

1. **Drafts, never sends.** Whatever email connector you use, the system creates drafts for your review. Auto-send defeats the quality gate and your own judgment.
2. **Scheduled tasks need Local MCPs.** If you later enable scheduled tasks (Claude Code Desktop), connectors must be configured at Local scope — cloud/project-scoped MCPs may not resolve at task runtime. Interactive sessions don't care.
