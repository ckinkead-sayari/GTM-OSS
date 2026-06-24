# claudegtm-os

The operating-system layer of claudeGTM, packaged as a Claude Code plugin: the lifecycle rituals and scaffolding you invoke, so they drop into any Claude Code setup.

| Skill | What it does |
|-------|--------------|
| `recreate-from-scratch` | Rebuild a full claudeGTM working instance (operating contract, enforcement hooks, frameworks, memory model) from spec in an empty folder — then hands off to `bootstrap`. The no-artifact fallback. |
| `bootstrap` | Guided first-run: interview + research, then writes your knowledge files, wires tool routing, probes MCPs, creates first dossiers. |
| `preamble` | Full session start: config + MCP probe, context load, staleness scan, session ID. |
| `end-session` | Full session close: roll context forward, log analytics + handoff, commit + push. |

## A note on the hooks

claudeGTM's automatic enforcement (SessionStart digest, SessionEnd marker, the draft quality gate) lives in a working directory's `hooks/` + `.claude/settings.json` because it reads instance state. This plugin does not ship those as plugin-hooks; `recreate-from-scratch` writes them into your instance instead. Run it in an empty folder for a complete, hook-wired claudeGTM, then `bootstrap` fills in your domain.
