# night-shift

Based on Jamon Holmgren's [Night Shift](https://jamon.dev/night-shift)
workflow. The human does the thinking during the day. Agents implement
overnight, test-first, behind persona review gates. The human reviews every
commit in the morning and fixes the process before fixing the code.

## The cycle

| When | Skill | What happens |
| --- | --- | --- |
| Once per repo | `night-shift-setup` | Writes `NIGHT_SHIFT.md` (checks, branch, off-limits), `REVIEW_PERSONAS.md`, a spec template, `TODOS.md`. Lists the gaps that will hurt overnight. |
| Day | `spec-check` | You write a spec by hand; this returns a checklist of gaps. You edit the spec yourself and mark it `status: ready`. |
| Evening | `night-shift` | Prep → pick a spec (bugs first) → red tests → plan → persona review → implement → checks → diff review → one commit → repeat. Writes `.night-shift/reports/<date>.md`. |
| Evening, optional | `night-watch` | Run in a second tool (e.g. Codex while Claude runs the shift). Reviews each commit as it lands into `TODOS_REVIEW.md`; the shift picks findings up as fixups. |
| Morning | `morning-review` | Walks the branch commit by commit: decisions, diff, how to test by hand. |
| When something is wrong | `postmortem` | Finds the doc, check, spec, or reviewer that let it through, fixes that, then the code. |

`agents/night-shift-reviewer.md` is the reviewer subagent the gate dispatches,
one per persona. Codex has no subagents, so there the gate runs personas one at
a time, or shells out to another model's CLI.

## Files it puts in a repo

```
NIGHT_SHIFT.md        how the loop runs here: checks, branch, off-limits
REVIEW_PERSONAS.md    reviewers and the docs each one owns
Specs/                specs; draft-* ignored; status in frontmatter
TODOS.md              out-of-scope findings, NEEDS INPUT FROM USER
TODOS_REVIEW.md       night-watch findings (only when used)
.night-shift/         plans and reports (gitignored)
```

## Running it unattended

The loop never asks for input, but your tool's permission prompts will still
stop it. Before leaving a run overnight, allow the repo's check commands and
git in the project's permission settings, or run inside a sandbox or
container. Keep your machine awake (`caffeinate -i` on macOS).

## Differences from the original

- Adds a Test Expert persona; Jamon's six don't cover test quality separately.
- Review rounds are capped (default 3). At the cap the task is marked blocked
  instead of looping all night.
- Blocked tasks are stashed with a question for the human, and the loop moves
  on to the next spec.
