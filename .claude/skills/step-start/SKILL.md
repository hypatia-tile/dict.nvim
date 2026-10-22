---
name: step-start
description: Start the next step of dict.nvim. Finds the first unchecked step in docs/roadmap.md, drafts its done criteria with the owner, files the step as a GitHub issue and presents the spec. Use when the owner asks to begin, resume or move on to the next step ("次の step を始めたい", "step 3 に進みます", "続きをやりましょう").
---

# Starting a step

The owner writes this plugin's code and tests by hand, to learn Neovim plugin
development. Starting a step means handing over a clear target, not a
solution.

## Working contract

The same contract is in `step-review`; the two must not disagree.

- **The owner writes and commits all code and tests.** Where to cut a commit
  and what its message says is part of the work, and reviews are pinned to
  commit hashes, so the person who wrote the code decides the boundaries.
- **The agent never edits `lua/`, `plugin/`, `doc/` or `tests/`.**
- **Help stops at explanation.** Explain how a Neovim API behaves, point to
  `:help`, give minimal examples unrelated to this plugin, lay out design
  options with a recommendation. Do not write this plugin's functions or
  tests unless the owner explicitly asks, and then only the part asked for.
  Working out the code is the part the owner wants to do.
- **The agent writes documents only** — `docs/roadmap.md`, these skills,
  issue, comment and PR text — commits them only when the owner asks, and
  asks before every push. The one exception is the roadmap tick described in
  `step-review`.
- **One branch per step, off `main`**, which the owner creates and pushes.
  `main` holds finished steps only, because a fresh clone of the owner's
  Neovim configuration loads the plugin from GitHub's `main`
  (hypatia-tile/dotfiles-mac#287).
- **The repository is public**, so nothing is posted to GitHub before the
  owner has seen it and said go.

## Before starting

1. Read `docs/roadmap.md`: the design decisions, "What the server sends", and
   the first step whose checkbox is unchecked.
2. Check that the previous step's issue is closed and its PR merged. If not,
   say so and ask whether to finish it first.
3. Check `gh issue list` for an existing issue for this step; do not file a
   duplicate.
4. Read the code on `main` that the step will touch, so the spec describes the
   real starting point.

## Done criteria

The roadmap gives each step as a paragraph, not as criteria: criteria for
later steps written in advance would be guesses about what the earlier ones
teach. So they are written here, at the start of each step.

- Draft them from the step's paragraph and the design decisions, as a
  checklist of behaviour that can be observed and specs that must exist.
- `make test` passing is always one of them.
- The owner approves them, or changes them, before the issue is posted. The
  issue is where they are recorded; the roadmap is not changed to hold them.

## What to produce

A GitHub issue, in English (see `github-language`), titled `Step N: <name>`,
containing:

- the goal of the step in one or two sentences;
- the approved done criteria as a checklist;
- the design decisions from the roadmap that constrain this step;
- the current state of the code the step starts from;
- `:help` topics worth reading.

It never contains implementation steps, code for this plugin, or test code.

## Order

1. Show the issue body in the conversation, criteria included, and wait for
   the owner's go-ahead.
2. Create the issue with `gh issue create`.
3. Give the owner the issue number, and remind them to branch off `main` for
   the step and to reference the issue in commits with `Refs #N`.

## When it is done

When the issue exists and the owner has its number. The step itself is
closed by `step-review` and the merge of its PR, not here.
