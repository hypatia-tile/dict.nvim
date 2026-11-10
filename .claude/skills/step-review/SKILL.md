---
name: step-review
description: Review the owner's uncommitted work on a dict.nvim step against the done criteria on its GitHub issue, commit it once a round is clean, and — once the owner declares the step done — post the summary, tick the roadmap, open the step's PR and hand over the merge. Use when the owner asks for a review, says they changed or fixed something, or says a step is finished ("見てください", "修正しました", "review をお願いします", "step 2 が終わりました").
---

# Reviewing a step

The review supplies the evidence; the owner makes the call. Criteria cannot
capture whether a name feels right or the tests feel sufficient, and only the
person who wrote the code can judge that.

## Working contract

The same contract is in `step-start`; the two must not disagree.

**Who writes what**

- **The owner writes all code and tests.** The agent never edits `lua/`,
  `plugin/`, `doc/` or `tests/`, including to fix something a review found.
  Working out the code is the part the owner wants to do.
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
  record. The issue gets one summary when the step closes.
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

## A review round

1. Read the done criteria on the step's issue and the design decisions in
   `docs/roadmap.md`.
2. Read what changed: `git status`, `git diff` against the last commit, and
   new untracked files. Read the files themselves, not only the diff.
3. Run `make test` and report the real output. A spec that needs the dictd
   server is skipped without it; say whether the server was up.
4. Run the behaviour the change is about, headless, in a clean Neovim with
   only this repository on `runtimepath`
   (`nvim --headless --clean --cmd "set rtp^=." …`). An asynchronous lookup
   needs a `vim.wait` before quitting, or it shows nothing. Report what it
   printed. Passing specs are not evidence for what they do not run.
5. Give the findings in the conversation, most serious first, each as a
   failure scenario. Say which done criteria the change moves, and which
   remain.

When the owner has fixed what they want to fix, and `make test` passes,
commit (see the contract) and report the hash and subject.

## When the step is done

The owner declares it. Meeting every criterion does not close the step, and
the owner may also close a step with findings outstanding — the summary
records the reason when they do.

After the declaration, make sure everything is committed and pushed, then:

1. **Draft the summary comment and the PR together**, in English (see
   `github-language`), and show both in the conversation:
   - the comment: the final pushed hash, the `make test` result, each done
     criterion with its verdict and evidence, findings left open and why;
   - the PR: title `Step N: <name>`, base `main`, a body with
     `Closes #<issue>`, the final hash and a line that the summary is on the
     issue.
2. **After one go-ahead for both**, post the comment with `gh issue comment`.
3. **Tick the roadmap on the step branch.** Tick the step's checkbox in
   `docs/roadmap.md`, commit it as `docs: mark Step N as done` with
   `Refs #<issue>`, and push. The tick reaches `main` in the step's own
   merge.
4. **Open the PR** with `gh pr create`, linking the summary comment. The merge
   closes the issue, so it is not closed by hand.
5. **Hand over the merge:** `! gh pr merge <n> --merge`. The owner merges.
6. **After Step 1 is merged**, remind the owner that hypatia-tile/dotfiles-mac#287
   (loading the plugin in their Neovim configuration) is unblocked. That
   configuration lives in another repository; do not edit it from here.
