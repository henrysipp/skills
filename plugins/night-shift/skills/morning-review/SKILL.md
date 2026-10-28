---
name: morning-review
description: Walk the human through last night's night-shift branch commit by commit — message, diff, tests, docs — and queue fixes as process changes first. Use when the user says good morning, morning review, or asks what the night shift did.
argument-hint: Optional — the night branch or report date
disable-model-invocation: true
---

# Morning Review

The human reviews every line; you make that fast. You are a guide through the
branch, not a second reviewer with a verdict.

## 1. Orient

Read `.night-shift/reports/<date>.md` (latest if no date given), the
`Unreleased` section of `CHANGELOG.md`, and `git log --reverse <base>..<night branch>`.

Give the human a short overview: commits shipped, tasks blocked, and anything
under `Needs you`. Then the blocked questions, each as its own line, since
answering them unblocks tonight.

## 2. Commit by commit

Oldest first, one commit per turn. For each:

1. The commit's `Decisions` and `Watch for` sections, quoted.
2. The diff, grouped as tests → implementation → docs. Point at the parts the
   message says to watch; summarise the rest.
3. How to test it by hand: the exact steps to see the new behaviour.
4. Wait for the human: next, or a problem.

## 3. When the human finds a problem

Sort it before fixing anything:

- **Process gap**: a doc was wrong or silent, a check should have caught it, a
  reviewer persona owns this and missed it, the spec template never asked.
  Most problems are this. Hand off to the `postmortem` skill, which fixes the
  process first and the code second.
- **One-off**: a typo, a single wrong value with no lesson in it. Fix it now as
  a `fixup!` commit for that commit, so the branch stays one commit per task.

## 4. Close

When every commit is reviewed:

- List the fixups and postmortems done.
- Offer `git rebase --autosquash` to fold the fixups in, and wait for a yes.
- Triage `TODOS.md` with the human: each item becomes a spec, stays, or goes.
- Remind them which blocked specs are now answered and can go back to
  `status: ready`.

Merging or pushing the branch is the human's call; offer it, never do it
unasked.
