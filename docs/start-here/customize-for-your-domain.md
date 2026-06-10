# Customize for Your Domain

This starter kit gives you the claudeGTM framework + enforcement + infrastructure. It does NOT give you domain knowledge, product knowledge, or competitive positioning — those are your job to build because they're specific to what you sell and who you sell it to.

This guide walks through what to build first, what can wait, and how to tell that Claude is actually using your knowledge files.

---

## What the kit includes (no customization needed)

- **All frameworks** — outreach, business cases, champion docs, call debriefs, objections, expansion, retros, sequences, onboarding, multi-threading. These are structural and work for any vertical.
- **All enforcement hooks** — quality, research, framework, config checks. Anti-slop rules are universal. The git-lock reaper is macOS-specific but infrastructure, not content.
- **Session system** — preamble, active-context, analytics logging, handoff log, rolling lookback. Generic.
- **Docs + architecture** — ETHOS, ARCHITECTURE, the docs/ tree. Generic.

## What you need to build (customization required)

Three files, in priority order. Each has a `.template.md` starting point in `knowledge/`.

### Priority 1: `knowledge/domain-summary.md` (30–60 minutes)

The single highest-leverage file in the kit. Every outreach, call prep, and objection routes through it. If nothing else is filled in, fill this in.

1. Copy the template: `cp knowledge/domain-summary.template.md knowledge/domain-summary.md`
2. Fill in the sections. Target: one printed page. Anything longer won't get used.
3. Verify Claude reads it: start a session, ask "what's our positioning in [your vertical] in one sentence?" If the answer references your fill-in, the file is wired. If it sounds generic, either the file isn't being loaded or your framing is still too close to marketing copy.

Sections to nail:
- **What they actually care about** (3–5 pain points, specific not generic)
- **Regulatory / market drivers** (what forces buying)
- **Positioning in one sentence**
- **Proof points** (numbers with sources)
- **Buyer persona framing** (what each persona cares about, what they're skeptical of, opening hooks that work)

### Priority 2: `knowledge/product-capabilities.md` (1–2 hours)

What your product actually does, by module. Read before every call prep, champion doc, or competitive conversation.

1. Copy the template: `cp knowledge/product-capabilities.template.md knowledge/product-capabilities.md`
2. Fill in one section per module / tier / SKU.
3. Include recent feature releases — this file is living documentation. A stale capabilities file leads to promises you can't deliver.
4. Be honest about gaps. Buyers respect vendors who know their own weaknesses.

### Priority 3: `knowledge/communication-playbook.md` (1–2 hours, requires ~30 of your sent emails)

Your email voice. Without this, drafted outreach sounds like a generic LLM. With it, it sounds like you.

1. Copy the template: `cp knowledge/communication-playbook.template.md knowledge/communication-playbook.md`
2. Go to your Sent folder. Pull ~30 emails across different contexts — cold outreach, warm intro, call follow-up, renewal nudge, objection response.
3. Have Claude extract your patterns: opening styles, closing styles, email length by context, tone markers, recurring phrases, and things you NEVER say.
4. The file is gitignored per fork — it's personal.

## What's optional

Build these only if you need them:

- `knowledge/domain-strategy.md` (deep-dive) — only needed for full business cases and new-account onboarding at scale. The 1-pager covers ~90% of work. Skip until you feel the 1-pager limit.
- `knowledge/call-prep-bundle.md` — the template in the kit is a good default. Customize only if your call prep has vertical-specific steps.
- Tool-specific references (e.g., `knowledge/mixpanel-reference.md`) — only if you use those tools and need account-to-property mapping.

## What to skip until you actually need it

- Scheduled tasks — 10 tasks exist in `frameworks/scheduled-tasks-reference.md` but you don't need all of them. Start with zero, add as you feel manual-toil pain.
- Competitive positioning docs — build as competitive threads with prospects emerge, not upfront.
- Notion / CRM database sync — start with the kit's file-based memory (active-context, accounts/*.md), add CRM sync later when file-based gets painful.

## Verify the customization worked

After filling in `domain-summary.md`, test with each of these prompts in a fresh session. If Claude sounds generic, the file isn't being loaded; if it sounds like you know the domain, it's wired.

1. **"What's our positioning in [your vertical] in one sentence?"**
   - Should cite your exact positioning statement. If it paraphrases or generates something new, the file isn't being read.

2. **"Draft a cold email to [buyer persona] at a [sub-segment] company."**
   - Should use one of your persona-specific opening hooks. Should reference a real pain point from the file, not a generic "I noticed your company is growing."

3. **"What objection should I expect from [persona] on this pitch?"**
   - Should come from your objection library (after you build it via `frameworks/objections.md`). Initially will come from `knowledge/domain-summary.md` persona framing.

4. **"What proof points land with [persona]?"**
   - Should cite specific numbers with source attribution. Generic claims = file isn't loaded or file is too marketing-y.

If any of these fails: check `.claude/CLAUDE.md` — the routing table should reference `knowledge/domain-summary.md` under "Drafting outreach", "Building a business case", "Handling objections". If it doesn't, fix the routing.

## Iteration cadence

- **Week 1:** fill in `domain-summary.md` and `product-capabilities.md`. Nothing else.
- **Week 2:** analyze your sent emails, build `communication-playbook.md`.
- **Weeks 3–4:** refine as you hit real conversations. Every objection that surprises you goes into the catalog. Every claim that lands gets promoted to a proof point.
- **Week 6+:** consider scheduled tasks, deep-dive strategy doc, domain-specific frameworks.

Don't try to build it all upfront. The system compounds — knowledge captured once is reused every session. Start small, let it grow.

## See also

- [`knowledge/README.md`](../../knowledge/README.md) — what lives in the knowledge directory and why
- [`docs/concepts/accretive-knowledge.md`](../concepts/accretive-knowledge.md) — why the knowledge base compounds session-over-session
- [`frameworks/outreach.md`](../../frameworks/outreach.md) — the framework that reads `domain-summary.md` + `communication-playbook.md`
