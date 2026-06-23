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

**No GitHub account at all?** The system is just files — GitHub is for versioning/backup, not for running it. Get the `claudeGTM-starter-kit.zip` from whoever runs it (or `bash tools/build-starter-kit.sh`), unzip, open the folder in Claude Code, and skip to step 2. Optional: `git init` locally (no remote) for history; back the folder up with Time Machine or a cloud drive. A non-GitHub git host (GitLab, Bitbucket, internal SCM) works identically if you want a remote. Truly nothing to copy? Open an empty folder in Claude Code and run **`/recreate-from-scratch`** to regenerate the skeleton from spec, then continue at step 2.

**Terminal-averse?** That's fine — open Claude Code, paste this page, and say "do the quick start for me." Every command in these docs is something Claude can run on your behalf; your job is the judgment, not the typing. (More reassurance: [FAQ](faq.md), first question.)

The SessionStart digest re-checks your remote's visibility every session and warns loudly if working data is sitting in a public repo.

**Joining a team that already runs this?** Stop here and read [Team Adoption](team-adoption.md) first — you'll import your team's knowledge files instead of building your own, and `/bootstrap` becomes a 15-minute localize instead of a 45-minute build.

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

## Your ramp: 30 / 60 / 90, compressed

Sales-onboarding research is consistent: structured ramps with competency gates beat activity quotas, and the "learn" phase is what good knowledge transfer compresses. This system's version — each phase has an *evidence gate* you can check in your own files, not a feeling:

| Phase | Do | Evidence gate (you can verify this) |
|-------|----|--------------------------------------|
| **Day 1** | `/bootstrap` (or [Team Adoption](team-adoption.md) import) + read the example session | Knowledge files exist and pass the "positioning in one sentence" test |
| **Days 2–7: Learn by doing** | Work 1–2 real accounts through the full loop daily; say **"retro"** on day 5 | Every worked account has a dossier with dated Activity Log entries; first retro runs on real analytics |
| **Days 8–30: Apply** | Full account book in; CRM/analytics MCPs connected; objection catalog gets its first real entries | Pipeline table in `active-context.md` matches your CRM; ≥3 objections logged with responses |
| **Days 31–60: Accelerate** | Renewal/expansion frameworks in play; one scheduled task if manual toil appeared | Expansion signals logged; retro shows week-over-week activity you didn't hand-count |
| **Days 61–90: Compound** | The system starts arguing back — stale threads, concentration risk, renewal windows flagged unprompted | You catch yourself saying "right, I forgot about that" to your own tooling |

(Honest arithmetic from the research: if your sales cycle is 6 months, day 90 won't show a closed-won — but it will show a pipeline you can defend line-by-line.)

Two habits make or break all of it: **end every session with "end session"** (unsaved context is deleted context), and **never let a debrief live only in chat**.

---

## What happens next

See [Introduction](introduction.md) for the operating philosophy, [Fork Guide](fork-guide.md) for the full setup detail (role-specific config, scheduled tasks, staying current with upstream), and [Connect Your Stack](connect-your-stack.md) for the MCP slot map.
