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

## Ground rules

1. One concern per PR, with a clear description of the failure mode it fixes or the workflow it improves.
2. Shell scripts: `bash -n` clean, tested in a real environment (not just your shell — see ARCHITECTURE.md → Infrastructure Postmortems for why we're strict about this).
3. No personal data, client names, service IDs, or credentials in code, docs, examples, or commit messages. CI of one: run a `grep -ri` for your own name before pushing.
4. Match the existing style: plain bash, fail-closed guards, append-only logs, one fact one home.

## License

By contributing, you agree your contributions are licensed under the MIT License (see LICENSE).
