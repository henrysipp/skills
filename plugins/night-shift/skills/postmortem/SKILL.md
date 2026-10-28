---
name: postmortem
description: When an agent got something wrong, find which doc, skill, spec, or missing check led it there, fix that first, then fix the code. Use when the user says postmortem, asks why the agent did that, or a morning review turns up a process gap.
argument-hint: What went wrong, and the commit or file
disable-model-invocation: true
---

# Postmortem

A wrong line of code is a symptom. The cause is whatever let a capable agent
believe it was right: a doc that said otherwise, a doc that said nothing, a
check that stayed green, a spec that never mentioned the case, a reviewer whose
docs gave it nothing to catch it with. Fix the cause and every future night
benefits; fix only the code and it happens again.

## 1. Reconstruct

Find what the agent was working from when it made the mistake:

- The commit message (`Decisions` especially) and the spec it cites.
- The plan in `.night-shift/plans/` and the review verdicts, if still present.
- If this happened in the current session, your own context: which files you
  read, which you skipped, and which instruction you followed.

Done when you can name the exact sentence, or the exact absence, that made the
wrong choice look right.

## 2. Find the gap

Place it in the first layer that should have stopped it:

| Layer | It failed when… | Fix lives in |
| --- | --- | --- |
| Spec | the case was never written down | spec template prompt, or this spec |
| Docs | the rule was wrong, stale, or missing | the system doc that owns the area |
| Router | the right doc existed but was not reached | `AGENTS.md` / `CLAUDE.md` pointer wording |
| Checks | a lint, type, or test rule could have made it red | config, or a new test |
| Review | a persona should have caught it | that persona's owned docs in `REVIEW_PERSONAS.md` |
| Loop | the workflow itself skipped a step | `NIGHT_SHIFT.md` notes, or the skill |

Prefer the most mechanical fix that works: a check beats a doc, a doc beats a
review note. A rule a machine enforces never drifts.

## 3. Propose, then apply

Show the human the gap and the proposed process fix, as a diff. Wait for a yes:
docs and skills shape every future run, so the human approves them.

Then, in order:

1. Apply the process fix.
2. Fix the original problem, following the fixed process, as a `fixup!` commit
   on the commit that introduced it (or a normal commit outside a night branch).
3. Confirm the new check goes red on the old code and green on the fix, when
   the fix was a check.

## 4. Record

One line under `## Process gaps` in the night's report, or in the commit
message: what failed, which layer, what changed.
