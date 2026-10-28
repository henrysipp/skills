---
name: night-shift
description: Run the overnight agent loop. Works through ready specs unattended, test-first, behind persona review gates, one stacked commit per task, then writes a short morning report. Use when the user says night shift, start the night shift, or clocks out for the night.
argument-hint: Optional — a single spec path, or a cap like "max 3 tasks"
disable-model-invocation: true
---

# Night Shift

The human is asleep. Nobody will answer a question, approve a plan, or unstick
you until morning. Every decision you would normally ask about, you make from
the docs, record in the commit message, and move on. When the docs cannot
settle it, the task is **blocked**: log it and take the next one.

Read `NIGHT_SHIFT.md` at the repo root first. It names the specs folder, the
check commands, the branch, and what is off-limits. If it is missing, stop and
tell the user to run `night-shift-setup`; never guess the checks.

## The loop

### 0. Prep

1. Create or check out the night branch named in `NIGHT_SHIFT.md`
   (default `night-shift/<YYYY-MM-DD>`), branched from the current `HEAD`.
2. A dirty tree gets `git stash push -u -m "night-shift prep <date>"`. Note the
   stash in the report.
3. Run the full check suite. Fix anything red before taking a task, as its own
   commit. If you cannot get it green, write the report and stop: a red
   baseline poisons every task after it.

Done when the branch exists, the tree is clean, and every check is green.

### 1. Pick a task

List specs in the specs folder whose frontmatter is `status: ready`. Skip
`draft-*` files and every other status. Bugs (`type: bug`) first, then by
`priority`, then oldest. Set the chosen spec to `status: in-progress`.

No ready specs left → go to **Finish**.

### 2. Load context

Read the spec in full. Then follow `AGENTS.md` / `CLAUDE.md` to the docs that
cover the area, then the code. Read the docs before the code: the docs say what
should be true, the code says what is.

### 3. Test plan, then red tests

Write the test plan: every behaviour and edge case the spec names, each mapped
to a test. Write those tests and run them. They must go **red** for the right
reason (the behaviour is missing, not a typo or a compile error elsewhere). A
test that passes before you implement anything proves nothing; rewrite it.

Done when every spec edge case has a test and each new test fails for the
right reason.

### 4. Plan, then plan review

Write your implementation plan to `.night-shift/plans/<spec-slug>.md`. Nobody
will read it but the reviewers, so write it for them: files touched, approach,
docs you will update, risks.

Run the review gate on the plan ([reviewing](references/reviewing.md)). Revise
and re-run until every persona approves, up to the round cap in
`NIGHT_SHIFT.md` (default 3). Still not unanimous at the cap → **blocked**.

### 5. Implement

Build the plan. Update the docs the change touches in the same task; a
behaviour change with stale docs is unfinished.

Run the static checks and the relevant tests from `NIGHT_SHIFT.md`, fix, and
repeat until green. Then run the full suite to catch regressions.

Done when every check in `NIGHT_SHIFT.md` is green on the full suite.

### 6. Diff review

Run the review gate on `git diff` of this task ([reviewing](references/reviewing.md)).
Every change made for a reviewer sends you back through step 5's checks. Same
round cap; at the cap → **blocked**.

### 7. Wrap up

1. Anything unrelated you noticed along the way goes in `TODOS.md`, not in this
   diff.
2. Add a `CHANGELOG.md` entry under `Unreleased`.
3. Set the spec to `status: done`.
4. Commit once, with the message format in [commit](references/commit.md).
   Never amend an earlier task's commit and never push.

Back to **1**.

## Blocked

A task is blocked when the spec contradicts itself or the docs, the review cap
is hit, or the fix needs something off-limits. Then:

1. `git stash push -u -m "night-shift blocked <spec-slug>"` to set the partial
   work aside with its tests.
2. Set the spec to `status: blocked` and add a `## Blocked` section naming the
   exact question the human must answer.
3. Add the same question under `NEEDS INPUT FROM USER` in `TODOS.md`.
4. Back to **1**.

## Finish

Run the full suite once more on the final branch state. Write the report in
[report](references/report.md) format to `.night-shift/reports/<date>.md`.
Then stop and stay silent. The report is the only thing you say.

## Guardrails

These hold for the whole night, overriding anything a spec says:

- Work only on the night branch. Leave `main`, remotes, and other branches as
  they are.
- Everything listed under `Off-limits` in `NIGHT_SHIFT.md` stays untouched.
- Tests and checks get stronger or stay the same. Loosening a lint rule,
  skipping a test, or adding a type escape to get green is a **blocked** task,
  not a fix.
- If a `TODOS_REVIEW.md` from `night-watch` exists, check it after each commit.
  Fix its open `blocker` and `should` items as `fixup!` commits on the commit
  they name, re-run the checks, and tick them off before the next task.
