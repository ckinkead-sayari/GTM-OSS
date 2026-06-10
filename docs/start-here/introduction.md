# Introduction

claudeGTM exists because AI assistants lose context the moment a conversation ends. Every new session starts from zero unless something external persists the state. This repo is that something external.

**The bet:** if Claude reads your accounts, your voice, your frameworks, and your pipeline state at the start of every session, and writes back what it learned at the end, the system compounds. Each session leaves Claude smarter than it found it.

---

## Six operating principles

These are non-negotiable. They shape every outreach, every call debrief, every recommendation. Full detail in [ETHOS.md](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/ETHOS.md).

### 1. Research before everything

The GTM equivalent of "measure twice, cut once." Before any outreach or recommendation, research externally — regulatory actions, competitive moves, recent news, evidence that contradicts your assumptions. Cost of researching is near-zero. Cost of sending an uninformed email is a burned relationship.

Three layers of account knowledge:

- **Layer 1** (public) — their website, annual reports, press. Everyone knows this.
- **Layer 2** (industry context) — regulatory trends, peer behavior. Shows you understand their world.
- **Layer 3** (first-principles insight) — original observations about their specific situation. "This person actually understands my problem."

Enforced by `hooks/check-research.sh`.

### 2. Warm before cold

Warm paths convert at 5–10× the rate of cold outreach. Before going cold, exhaust: mutual connections, shared history, warm intros, event encounters, LinkedIn engagement.

Cold outreach is the fallback, not the default.

### 3. Listen before pitching

Early conversations are discovery, not demos. Lead with "what's broken in your world?" not a hypothesis pitch. Goal of the first conversation is to understand, not to sell.

### 4. Consultant tone, not marketing copy

You are a senior consultant advising a peer. Not a marketer writing ad copy. Every piece of content reads like it was written by someone who understands their business, not someone who wants their money.

Banned language: "seamless", "next-gen", "cutting-edge", "leverage", "In today's rapidly evolving landscape", etc. Enforced by `hooks/check-quality.sh`.

Test: would a senior compliance officer at a tier 1 bank read this without cringing? If not, rewrite.

### 5. Complete the work

Don't send a half-researched email. Don't skip the follow-up because the call went well. Don't leave objections unrecorded. Don't defer updating `active-context.md`.

When the complete version costs minutes more than the shortcut, do the complete thing.

### 6. See something, say something

During any workflow, if you notice something off — stale pipeline data, an account with no recent activity, an objection pattern forming, a competitor move affecting multiple accounts — flag it. One sentence: what you noticed and its impact.

Don't let noticed issues silently pass. The whole point of this system is proactive intelligence.

---

## Why enforcement, not just instructions

The principles above could live as polite suggestions in a prompt. They don't, because prompts drift. Under time pressure Claude will skip research to get to the output. The hooks make that skip impossible:

- `check-research.sh` fails if no recent research log exists for the account
- `check-framework.sh` fails if the relevant framework wasn't read in the current session
- `check-quality.sh` fails on banned language
- `check-config.sh` fails at session start if `MY-CONFIG.md` is missing fields

Discipline is enforced, not requested. [More in Enforcement Hooks.](../concepts/enforcement-hooks.md)

---

## What this replaces

- **CRM as source of truth.** Salesforce stays read-only via Glean. Claude reads deal state, doesn't write it. Notion is the editable layer for pipeline tracking.
- **Hand-rolled call prep.** Scheduled tasks pre-stage call briefings every morning. You wake up with the week's prep ready.
- **Tribal knowledge about accounts.** `accounts/*.md` files accumulate every research finding. Layer 3 insights compound.
- **"What did I say last time?"** `memory/active-context.md` holds the last three sessions of work. Every session starts with what happened recently.

---

## Where to go next

- **[Quick Start](quick-start.md)** if you haven't cloned and configured yet.
- **[Fork Guide](fork-guide.md)** for the detailed setup — scheduled tasks, MCP connectors, role-specific workflows.
- **[The Preamble](../concepts/the-preamble.md)** to see exactly what Claude does at the start of a session.
- **[The Frameworks](../concepts/the-frameworks.md)** to understand task-to-file routing.
