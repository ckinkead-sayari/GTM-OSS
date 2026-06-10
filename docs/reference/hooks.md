# Hooks Reference

Enforcement scripts live in `hooks/` at the repo root. This page indexes what each does, its inputs, and its exit codes.

## Content hooks

### `check-config.sh`

Verifies `MY-CONFIG.md` exists and has all required fields. Runs at session start via the preamble.

```bash
bash hooks/check-config.sh
```

Fails with a numbered list of missing fields. No work proceeds until every field is filled.

### `check-research.sh`

Blocks outreach / call prep / business cases until external research exists for the named account.

```bash
bash hooks/check-research.sh "ACME Bank"
```

Scans `memory/analytics.jsonl` for a recent `account_research` event. Fails if none exists.

### `check-framework.sh`

Returns the framework files Claude must read for a given task type.

```bash
bash hooks/check-framework.sh "outreach"
bash hooks/check-framework.sh "mcp-conversation"
bash hooks/check-framework.sh "call-prep"
```

Used before generating framework-scoped content. Pairs with the routing table in `.claude/CLAUDE.md`.

### `check-quality.sh`

Scans prospect-facing content for banned language and fluff.

```bash
echo "your draft email" | bash hooks/check-quality.sh
```

Returns a list of violations (marketing vocabulary, generic CTAs, round-number claims, corporate filler). Zero violations = pass.

## Session lifecycle hooks (wired via `.claude/settings.json`)

These three run automatically through Claude Code's hook system — no protocol discipline required.

### `session-start.sh`

**SessionStart hook.** Prints a preamble digest into Claude's context at every session start: config check, MCP probe staleness, git state, handoff-gap detection (catches scheduled tasks that fire but produce nothing), account-file freshness, P0 count + oldest backlog age.

### `session-end.sh`

**SessionEnd hook.** If a session terminates with uncommitted work, appends an `unclean_session_end` marker (with the stranded file list) to `memory/handoff.jsonl` so the next session's digest surfaces it. Detection only — SessionEnd cannot block termination.

### `check-outbound-quality.sh`

**PreToolUse hook on `*create_draft*` tools.** Extracts draft-like text fields from the tool call, pipes them through `check-quality.sh`, and blocks the call (exit 2) on violations, feeding the specific violations back for a rewrite. Fails open on extraction errors so it never breaks unrelated tools.

### `next-session-id.sh`

Not a wired hook, but part of the session lifecycle: mints the next `S-NNN` session ID as max(existing)+1 across analytics + handoff logs. Counting events instead of taking the max caused a session-ID collision (S-028) — hence the script.

```bash
bash hooks/next-session-id.sh   # → S-037
```

## Infrastructure hooks

### `git-safe.sh`

Portable git wrapper scheduled tasks route all `pull`/`add`/`commit`/`push` through. Detects stale locks via `lsof`, serializes concurrent writers via flock-or-mkdir on `/tmp`, emits actionable errors on virtiofs EPERM.

```bash
bash hooks/git-safe.sh <git-args>
```

Exit codes:

- `0` — git succeeded
- `1` — `.git/index.lock` is held by a live process (do not clobber)
- `2` — serialization timeout on `/tmp/claudeGTM-git.lock`
- `3` — orphan lock detected but `rm` failed (virtiofs EPERM) → auto-resolves via the reaper within 10–15s
- `*` — git's own exit code

### `reap-git-locks.sh`

Host-side launchd reaper. Polls every 10 seconds, removes orphan git lock files the Cowork sandbox couldn't unlink. Hardcoded scope: touches only `$HOME/claudeGTM/.git/{index,HEAD,ORIG_HEAD}.lock` — grown only when a lock type is actually observed stranded. Mid-op + ghost-aware live-holder + age guards.

Audit trail at [`memory/reap-log.jsonl`](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/memory/reap-log.jsonl). Full story: [ARCHITECTURE.md → Infrastructure Postmortems](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/ARCHITECTURE.md#recurring-gitindexlock-stranding-s-020--s-025-resolved).

### `com.claudegtm.git-reaper.plist`

LaunchAgent definition. `StartInterval=10`, `RunAtLoad=true`, no `KeepAlive`. Installed to `~/Library/LaunchAgents/`.

### `install-reaper.sh`

Idempotent installer for the reaper.

```bash
bash hooks/install-reaper.sh            # install + start
bash hooks/install-reaper.sh --uninstall  # stop + remove
```

Uses modern `launchctl bootstrap`/`bootout` idiom (replaces deprecated `load`/`unload`).

## Soft vs. hard enforcement

- **Soft enforcement** is `.claude/CLAUDE.md` telling Claude to run these hooks. Works in any Claude environment.
- **Hard enforcement** is wiring them into Claude Code's hook system. As of v0.6.0 three are wired in `.claude/settings.json`: SessionStart (preamble digest), SessionEnd (unclean-termination marker), and PreToolUse on draft creation (outbound quality gate).

Both layers coexist. Soft alone drifts; hard alone feels punitive. Together they remove the cost of good behavior.

## See also

- [Enforcement Hooks](../concepts/enforcement-hooks.md) — conceptual treatment.
- [ARCHITECTURE.md → Infrastructure Postmortems](https://github.com/YOUR-USERNAME/claudeGTM/blob/main/ARCHITECTURE.md#infrastructure-postmortems) — the five lessons from the git-lock saga.
