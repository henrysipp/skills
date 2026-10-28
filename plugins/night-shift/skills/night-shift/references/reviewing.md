# The review gate

Runs twice per task: on the plan (step 4) and on the diff (step 6). Every
persona in `REVIEW_PERSONAS.md` reviews independently and returns a verdict.
The gate passes only when all of them say `approve`.

## Dispatch

Each persona reviews in its own fresh context, so one reviewer's opinion never
colours another's. Give each reviewer:

- its persona block from `REVIEW_PERSONAS.md`, including the docs it owns
- the spec path
- the artifact: the plan file path, or the exact `git diff` command for this task
- nothing else: not your reasoning, not the other reviewers' verdicts

How to get a fresh context depends on the tool:

- **Claude Code**: one `night-shift-reviewer` subagent per persona, all in a
  single message so they run in parallel.
- **Cross-model** (when `NIGHT_SHIFT.md` sets `cross_model_reviewer`): run that
  CLI non-interactively for the personas it lists, e.g.
  `codex exec "<reviewer prompt>"` or `claude -p "<reviewer prompt>"`. A second
  model catches what the first is blind to.
- **No subagents** (Codex, Cursor without agents): review one persona at a
  time, re-reading only that persona's docs and the artifact before each.

## Verdict shape

Each reviewer returns:

```
persona: <name>
verdict: approve | changes
findings:
  - severity: blocker | should | nit
    where: <file:line, or plan section>
    issue: <what breaks, concretely>
    fix: <smallest change>
doc_suggestions:
  - <doc path>: <what the doc should say so this never comes up again>
```

## Acting on verdicts

- `blocker` and `should` findings get fixed before re-running the gate.
- `nit`s get fixed when cheap; otherwise list them in the commit message.
- A finding you believe is wrong: re-read the cited code and the persona's
  docs. Still wrong → note your reasoning in the plan, and that reviewer sees
  it next round. Two personas disagreeing with each other is decided by the
  docs; if the docs are silent, the task is **blocked**.
- `doc_suggestions` are applied in the same task when they describe what the
  code already does. A suggestion that changes intended behaviour goes to
  `TODOS.md` for the human.

Re-run only the personas that said `changes`, unless your fix touched another
persona's area.
