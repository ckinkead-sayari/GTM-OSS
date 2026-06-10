# claudeGTM

**Stop starting from zero. Persistent context and enforced discipline for GTM work with Claude.**

A forkable operating system for account managers and CS reps running deep-account GTM work with Claude Code (or Cowork). Gives every Claude session your account context, your voice, your frameworks, and your pipeline state — so each conversation picks up where the last one stopped instead of starting over.

---

## The problem

```
Without claudeGTM                        With claudeGTM
───────────────────                      ──────────────
Session 1: Research account              Session 1: Research account
           Draft outreach                          Draft outreach
           Send, done                              Log debrief + update context
                                                   Framework + quality hooks enforce
Session 2: Research account (again)      Session 2: "Continue [account]"
           Guess what you said last time           → Reads active-context
           Draft different email                    → Loads domain knowledge
                                                   → Knows warm path exists
                                                   Drafts on-voice reply in 2 min

Every session starts cold.               System compounds. Each session leaves
                                         Claude smarter than it found it.
```

Without the repo, Claude has no memory of your accounts, your voice, or what you decided yesterday. With it, your pipeline state, framework discipline, and institutional knowledge survive across sessions.

---

## Start Here

- **[Quick Start](start-here/quick-start.md)** — 5 hands-on steps. Clone, configure, validate, install, run first session. ~15 minutes.
- **[Customize for Your Domain](start-here/customize-for-your-domain.md)** — fill in your industry + product + voice so Claude sounds like someone who knows your space.
- **[Introduction](start-here/introduction.md)** — the operating philosophy. Research first, warm first, consultant tone, see something say something.
- **[Fork Guide](start-here/fork-guide.md)** — full setup with role-specific guidance, MCP connectors, optional scheduled tasks.

## Concepts

- **[The Preamble](concepts/the-preamble.md)** — What Claude does in the first 30 seconds of every session.
- **[The Frameworks](concepts/the-frameworks.md)** — Task-to-file routing. Why Claude reads before writing.
- **[Enforcement Hooks](concepts/enforcement-hooks.md)** — How discipline is enforced, not just suggested.
- **[Accretive Knowledge](concepts/accretive-knowledge.md)** — Why the system gets smarter over time.

## Reference

- **[Frameworks Index](reference/frameworks.md)** — All 18 frameworks, what they do, when they fire.
- **[Knowledge Base](reference/knowledge.md)** — Institutional knowledge files.
- **[Hooks](reference/hooks.md)** — Enforcement scripts + the host-side lock reaper.
- **[Scheduled Tasks](reference/scheduled-tasks.md)** — a catalog of background tasks; run a few weekly, the rest on demand.

## Deeper reading

- [ARCHITECTURE.md](../ARCHITECTURE.md) — Full system design, file roles, infrastructure postmortems.
- [ETHOS.md](../ETHOS.md) — The six operating principles in full.
- [README.md](../README.md) — Repo-level overview.

---

## Audience

Built as a forkable single-user GTM operating system. Fork it, fill in your own domain knowledge (industry, product, voice), keep your fork in sync with framework + infrastructure updates from upstream.

Not a multi-tenant product. Single-user operating system, meant to be forked per person.
