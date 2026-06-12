# Contributing

claudeGTM is a forkable operating system for GTM work with Claude. The expected usage pattern is: **fork it, fill in your own domain knowledge, keep your data private.** Contributions to the shared framework are welcome.

## What makes a good contribution

- **Frameworks** — improvements to the task playbooks (outreach, debrief, expansion, sequences, …) that are domain-neutral
- **Hooks** — enforcement scripts, portability fixes, new wired hooks (SessionStart/SessionEnd/PreToolUse patterns)
- **Docs** — clearer setup, better fork guidance
- **Templates** — better scaffolding for domain knowledge files

## What we won't merge

- **Domain- or company-specific content** — your vertical knowledge, account data, objection catalogs, proof points. Those live in your fork (`knowledge/`, `accounts/`, `memory/` are yours).
- **Anything that weakens an enforcement gate** without a strong argument — the hooks exist because soft discipline erodes.

## Contribute from a clean clone — NEVER from your working repo

Your working copy accumulates client data from session one: dossiers, pipeline state, analytics, debriefs — and **your git history keeps all of it forever**, even if you delete the files before opening a PR. So:

1. Clone this repo fresh, separate from your working instance.
2. Re-apply your improvement to the clean clone by hand (don't cherry-pick from your working repo's history).
3. PR from the clean clone.

If a branch from a working instance ever reaches a PR here, we'll close it unmerged and ask for a clean resubmission — for your protection, not ours.

## Ground rules

1. One concern per PR, with a clear description of the failure mode it fixes or the workflow it improves.
2. Shell scripts: `bash -n` clean and `shellcheck --severity=error` clean (CI enforces both), tested in a real environment (not just your shell — see ARCHITECTURE.md → Infrastructure Postmortems for why we're strict about this).
3. No personal data, client names, service IDs, or credentials in code, docs, examples, or commit messages. CI of one: run a `grep -ri` for your own name and your accounts' names before pushing.
4. Match the existing style: plain bash, fail-closed guards, append-only logs, one fact one home.
5. Worked examples in docs use **obviously fictional** companies and people (see `accounts/EXAMPLE-northwind-insurance.md`) — never thinly disguised real ones.

## License

By contributing, you agree your contributions are licensed under the MIT License (see LICENSE).
