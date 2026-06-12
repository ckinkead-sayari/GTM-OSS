# Quick Start

Create a private repo, run one guided setup command, work your first account. ~15 minutes to a running system; ~45 minutes total once `/bootstrap` has built your knowledge files with you.

Prerequisites:

- macOS (Linux works but the host-side git-lock reaper is macOS-only — see [fork guide](fork-guide.md))
- Claude Code or Claude Cowork
- Git + bash + `lsof` installed (all default on macOS)
- MCP connectors for whatever tools you use — start with just email + calendar; see [Connect Your Stack](connect-your-stack.md)

---

## 1. Create your PRIVATE repo from the template

Your working repo will contain client data within a week — dossiers, pipeline state, debriefs. It must be **private from birth**. GitHub cannot make a fork of a public repo private, so **do not use the Fork button**.

```bash
gh repo create my-gtm --private --clone --template https://github.com/ckinkead-sayari/GTM-OSS
cd my-gtm
```

No `gh` CLI? On GitHub: **Use this template** → name it → visibility **Private** → clone yours.

The SessionStart digest re-checks your remote's visibility every session and warns loudly if working data is sitting in a public repo.

---

## 2. Run `/bootstrap`

Open the folder as a Claude Code workspace, start a session, and run:

```
/bootstrap
```

A guided ~30–45 minute working session. You answer questions and paste raw material; Claude does the research and the writing:

1. **Identity** → `.claude/MY-CONFIG.md` (who you are, accounts, tools)
2. **Domain knowledge** → `knowledge/domain-summary.md` (interview + market research, one page)
3. **Product truth** → `knowledge/product-capabilities.md` (researched from your site, corrected by you — including what the product does NOT do)
4. **Your voice** → `knowledge/communication-playbook.md` (extracted from ~10–30 of your sent emails; gitignored, stays personal)
5. **Stack wiring** → routing table rewritten for your actual MCPs, connections probed
6. **First dossiers** → stubs for your top 3 accounts

Every phase is skippable and resumable — `/bootstrap` again later picks up what's missing. Prefer doing it by hand? [Customize for Your Domain](customize-for-your-domain.md) is the manual path.

---

## 3. Install the host-side git-lock reaper (macOS)

Cowork sessions write files via virtiofs, and the sandbox can't `unlink` its own `.git/index.lock` after a commit. Without the reaper, session-end commits may need manual cleanup.

```bash
bash hooks/install-reaper.sh
```

Verify:

```bash
launchctl list | grep claudegtm-git-reaper
```

The reaper polls every 10 seconds, touches only your repo's `.git/index.lock`, respects live holders and mid-op state (merge/rebase/cherry-pick), and logs every reap to `memory/reap-log.jsonl`. Uninstall any time with `bash hooks/install-reaper.sh --uninstall`.

---

## 4. Watch one session, then run one

Read [An Example Session](example-session.md) — five minutes, shows the whole loop: the digest, the research gate refusing to draft cold, the quality hook blocking banned language, the debrief that persists, the end-session commit.

Then run the real thing on ONE account:

- **"Research [account]."** External research lands in `accounts/[account].md`, not in chat history.
- **"Draft outreach to [contact] at [account]."** The hooks force research first, warm-path check, your voice, the quality gate.
- **After a call: "debrief the [account] call."** Seven points, appended to the dossier, objections logged.
- **"End session."** Context rolls forward, analytics written, committed, pushed.

---

## Your first two weeks

The system pays off through accumulation, not on day one. The arc that works:

| When | Do | Why |
|------|----|----|
| Day 1 | `/bootstrap` + read the example session | System configured, loop understood |
| Days 2–5 | Work 1–2 real accounts through the full loop daily | Dossiers start compounding; your voice file gets corrected by use |
| Day 5 | Say **"retro"** | First weekly retro — runs on your real analytics, shows what the logging was for |
| Week 2 | Add CRM/analytics MCPs if you skipped them; open renewals/expansion work | Pipeline sync + health signals come alive |
| When manual toil appears | Add ONE scheduled task (e.g. daily briefing) | Automation earns its place; don't start with ten |

Two habits make or break it: **end every session with "end session"** (unsaved context is deleted context), and **never let a debrief live only in chat**.

---

## What happens next

See [Introduction](introduction.md) for the operating philosophy, [Fork Guide](fork-guide.md) for the full setup detail (role-specific config, scheduled tasks, staying current with upstream), and [Connect Your Stack](connect-your-stack.md) for the MCP slot map.
