# knowledge/

Institutional knowledge about your domain, product, and tools. These files are the single biggest lever for making Claude useful — they're what turn generic output into content that reads like you actually know the industry and the product.

**Key principle:** build once, reuse every session.

## What lives here

Three categories:

### 1. Domain knowledge (your vertical)

- `domain-summary.md` — 1-pager: your industry's pain points, regulatory drivers, buyer personas, positioning. **Read before any outreach or call prep.**
- `domain-strategy.md` (optional deep-dive) — full regulatory detail, competitive vulnerability matrices, proof points. Read for business cases and new-account onboarding.

Start with `domain-summary.template.md` in this directory. Fill it in by interviewing yourself: what do you repeatedly explain to prospects? What regulatory or market drivers do they all face? What objections recur? What proof points consistently land?

### 2. Product knowledge (what you sell)

- `product-capabilities.md` — what your product actually does, by module or tier. Recent feature releases. Competitive relevance of each feature. Known product gaps.

Start with `product-capabilities.template.md`. This file gets updated as your product ships new features — treat it like living documentation.

### 3. Call prep + consolidated bundles

- `call-prep-bundle.md` — consolidated checklist used for external call prep. Combines the domain summary + product capabilities + health briefing + discovery questions into one file Claude loads before any call.

Start with `call-prep-bundle.template.md`.

### 4. Personal voice

- `communication-playbook.md` — your email voice, tone, patterns. **Gitignored per fork.** Built from analyzing ~30 of your own sent emails.

Use `communication-playbook.template.md` to build this.

### 5. Tool-specific references (optional, only if you use these)

If you use these tools, create references. Otherwise skip:

- `glean-reference.md` / `glean-skill.md` — Glean MCP patterns (only if your company uses Glean)
- `mixpanel-reference.md` — Mixpanel account mapping (only if you use Mixpanel for usage telemetry)
- `gemini-delegation.md` — Gemini CLI patterns for Drive/Docs (kept in the kit; generic)
- `chrome-automation-patterns.md` — Chrome MCP patterns (kept in the kit; generic)

## Usage rules

- **Domain summary** is read before every outreach, call prep, objection, or business case.
- **Product capabilities** is read before any call prep, champion doc, or competitive conversation.
- **Communication playbook** is read before drafting any email on your behalf.
- **Lazy-load principle**: not every session needs every file. Load on demand via the routing table in `.claude/CLAUDE.md`.

## Customizing from scratch

See [`docs/start-here/customize-for-your-domain.md`](../docs/start-here/customize-for-your-domain.md) for the step-by-step walkthrough: what to write first, what can wait, how to test that Claude is actually using your knowledge files.
