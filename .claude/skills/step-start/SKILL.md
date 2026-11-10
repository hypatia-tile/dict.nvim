---
name: step-start
description: Start the next step of dict.nvim. Finds the first unchecked step in docs/roadmap.md, drafts its done criteria with the owner, files the step as a GitHub issue, creates the step branch and presents the spec. Use when the owner asks to begin, resume or move on to the next step ("次の step を始めたい", "step 3 に進みます", "続きをやりましょう").
---

# Starting a step

The owner writes this plugin's code and tests by hand, to learn Neovim plugin
development. Starting a step means handing over a clear target, not a
solution.

## Working contract

The same contract is in `step-review`; the two must not disagree.

**Who writes what**

- **The owner writes all code and tests.** The agent never edits `lua/`,
  `plugin/`, `doc/` or `tests/`. Working out the code is the part the owner
  wants to do.
- **Help stops at explanation.** Explain how a Neovim API behaves, point to
  `:help`, give minimal examples unrelated to this plugin, lay out design
  options with a recommendation. Do not write this plugin's functions or
  tests unless the owner explicitly asks, and then only the part asked for.
- **The agent writes the documents**: `docs/roadmap.md`, these skills, issue,
  comment and PR text, and every commit message.

**Review**

- **Reviews look at the uncommitted working tree**, and the findings stay in
  the conversation. Short review rounds are where the learning happens, and
  posting each one to a public issue slows them down without improving the
  record. The issue gets one summary when the step closes (`step-review`).
- **Findings are failure scenarios, not patches.** Say which input or
  sequence produces which wrong result; finding the fix is the owner's part.

**git**

The owner handed every `git` write except the merge to the agent, so that the
work around the code costs them nothing.

- **The agent commits without asking** once a review round leaves nothing the
  owner still wants to fix and `make test` passes. It chooses where to cut
  and writes the message — what the commit adds, why it is done that way,
  what is not covered yet, and `Refs #N` — then reports the hash and subject.
  Anything the owner chose to leave as it is goes in the message as not done
  yet.
- **Documents are committed the same way**, on the current step branch. The
  exception: a change to these two skills, or to the design decisions in
  `docs/roadmap.md`, is shown to the owner as a diff and committed after
  their OK, because those change how the work runs or what is being built.
  A typo fix is not such a change.
- **Local commits may be rewritten before a push** — amended, reworded,
  squashed or split, for example when the owner asks for a different cut.
  Report the old and new hashes each time.
- **Pushed commits are never rewritten.** The summary on the issue points at
  pushed hashes, so later fixes are new commits, and step PRs are merged with
  a merge commit, the only method that keeps every pushed hash in `main`.
- **Push to the step branch only, never to `main`, never with force.** Push
  when the owner says they are stopping ("今日はここまで") or moves on to
  another topic. At the start of a session, right after `vuln-triage`, push
  any commits a previous session left unpushed. Nothing stays local for more
  than one session.
- **One branch per step, off an up-to-date `main`**, created by the agent.
  `main` holds finished steps only, because a fresh clone of the owner's
  Neovim configuration loads the plugin from GitHub's `main`
  (hypatia-tile/dotfiles-mac#287). Only the owner merges into it.

**Public text**

- **The repository is public.** Issues, comments and PRs are posted only
  after the owner has seen them and said go. Pushing commits under the rules
  above needs no such go-ahead.

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
3. Update `main` (`git switch main && git pull --ff-only`) and create
   `step/<N>-<short-name>` from it. It reaches GitHub with its first push.
4. Give the owner the issue number and the branch name.

## When it is done

When the issue exists and the owner is on the step branch. The step itself is
closed by `step-review` and the merge of its PR, not here.
