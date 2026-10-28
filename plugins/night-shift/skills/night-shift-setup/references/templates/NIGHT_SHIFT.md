# Night Shift

How the overnight agent loop runs in this repo. The `night-shift` skill reads
this file first; keep it accurate.

## Specs

- Folder: `Specs/`
- Ready to build: frontmatter `status: ready`. Files named `draft-*` are ignored.
- Template: `Specs/_template.md`

## Branch

- Night branch: `night-shift/<YYYY-MM-DD>`, cut from the current `HEAD`.
- One commit per task, stacked. Nothing is pushed.

## Checks

Run in this order. All must be green before a task is committed.

| Check | Command |
| --- | --- |
| Format | `<command>` |
| Lint | `<command>` |
| Types / build | `<command>` |
| Targeted tests | `<command, with how to pass a file or filter>` |
| Full suite | `<command>` |

## Review

- Personas: `REVIEW_PERSONAS.md`
- Round cap per gate: 3
- cross_model_reviewer: <none | `codex exec` | `claude -p`> for <persona names>

## Off-limits

The night shift leaves these untouched. A task that needs them is blocked.

- <path or area>

## Notes

<Anything the agent keeps getting wrong in this repo that does not belong in a
system doc: simulator quirks, slow tests to avoid, env setup.>
