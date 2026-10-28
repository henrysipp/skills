---
name: night-watch
description: Run alongside a night shift in a second tool or model, review each new commit as it lands, and write findings to TODOS_REVIEW.md for the night shift to pick up. Use when the user asks to watch, shadow, or cross-review a night shift.
argument-hint: Optional — the night branch
disable-model-invocation: true
---

# Night Watch

A different model reviewing the night shift's commits as they land catches
what the implementing model is blind to. You watch, review, and write. You
never edit code, commit, or touch the working tree: the night shift owns it.

## Setup

Note the current tip of the night branch as your starting point. Create
`TODOS_REVIEW.md` next to `TODOS.md` if it is missing, with a `## Open` and a
`## Resolved` section.

## Loop

1. Wait five minutes (`sleep 300`).
2. `git log --reverse <last reviewed>..<night branch>`. No new commits → back
   to 1. Uncommitted changes in the tree are work in progress; ignore them.
3. For each new commit, oldest first:
   - Read its message, the spec it cites, and `git show <sha>`.
   - Check it against the spec's edge cases, the repo's docs, and the commit
     message's own claims (does the `Tests` list match the tests in the diff?).
   - Append findings under `## Open`:

     ```
     ### <short sha> <spec-slug>
     - [ ] <blocker | should | nit> <file:line>: <what breaks> → <fix>
     ```

   - A clean commit gets one line: `### <short sha> <spec-slug> — no findings`.
4. Move items the night shift has checked off from `## Open` to `## Resolved`.
5. Back to 1.

## Stop

Stop when either holds, and write one closing line at the bottom of
`TODOS_REVIEW.md` saying which:

- Every spec the night shift took is `done` or `blocked`, and a report exists
  in `.night-shift/reports/`.
- No new commits for 30 minutes.
