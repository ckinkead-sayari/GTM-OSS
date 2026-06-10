# Knowledge Base Reference

Institutional knowledge lives in `knowledge/` at the repo root. Content is captured once, reused every session. This page indexes what's there.

## Banking (core domain)

| File | Purpose | When to read |
|------|---------|--------------|
| [`domain-summary.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/domain-summary.md) | 1-page default: value prop, positioning, regulatory drivers, buyer personas | Before any outreach, call prep, objection handling |
| [`domain-strategy.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/domain-strategy.md) | Deep-dive: full regulatory detail, competitive vulnerability matrices, proof-point sources | Business cases, full competitive review, new-account onboarding |
| [`call-prep-bundle.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/call-prep-bundle.md) | Consolidated call-prep checklist (banking + products + health briefing + discovery questions) | Any external call prep |
| [`product-capabilities.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/product-capabilities.md) | Current [YOUR_PRODUCT] capabilities across Graph/Map/API/Bulk/Data + recent feature releases | Call prep, champion docs, competitive discussions |
| [`mcp-banking-positioning.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/mcp-banking-positioning.md) | MCP framing for banks, persona tailoring, objection library, drop-in snippets | MCP / agentic-architecture conversations with technical banking buyers |

## Personal (your voice)

| File | Purpose |
|------|---------|
| [`communication-playbook.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/communication-playbook.md) | **Gitignored per fork.** Your email voice, tone, patterns extracted from your own sent emails |
| [`communication-playbook.template.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/communication-playbook.template.md) | Template to build `communication-playbook.md` from scratch |

Every fork builds its own `communication-playbook.md`. That's what makes drafted outreach sound like you, not a generic LLM.

## Tool usage patterns

| File | Purpose |
|------|---------|
| [`glean-skill.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/glean-skill.md) | Glean MCP best practices — agent routing, query optimization, Claude-Glean pairing |
| [`glean-reference.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/glean-reference.md) | Glean app filters, agent IDs, status |
| [`mixpanel-reference.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/mixpanel-reference.md) | Mixpanel account mapping, event weights, product type matrix, user properties |
| [`gemini-delegation.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/gemini-delegation.md) | Gemini CLI patterns for Drive/Docs + large-context repo scans |
| [`chrome-automation-patterns.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/chrome-automation-patterns.md) | Browser automation patterns for Chrome MCP |

## Internal context

| File | Purpose |
|------|---------|
| [`internal-tooling.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/internal-tooling.md) | Map of [YOUR_PRODUCT] agents, hackathon projects, engineering tools, key contacts |
| [`claudegtm-vs-market.md`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/knowledge/claudegtm-vs-market.md) | Differentiation vs. off-the-shelf GTM tooling |

## Usage rules

- **Banking files** are the source of truth for outreach, calls, and business cases. Augment with fresh research, never contradict.
- **Communication playbook** is read before drafting any email on your behalf.
- **Glean skill** is read before Glean-heavy workflows or when designing new agents.
- The **lazy-load principle** applies: not every session needs every file. Load on demand via the routing table in `.claude/CLAUDE.md`.

## See also

- [Accretive Knowledge](../concepts/accretive-knowledge.md) — why the knowledge base compounds session-over-session.
- [.claude/CLAUDE.md → Knowledge Base section](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/.claude/CLAUDE.md) — the canonical summary inside Claude's instructions.
