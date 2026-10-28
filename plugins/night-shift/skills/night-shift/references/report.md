# Morning report

Concise. The commits hold the detail; the report is the index into them. Aim to
fit on one screen.

```markdown
# Night shift <YYYY-MM-DD>

Branch: `night-shift/<date>` · <n> commits · full suite <green|red>

## Shipped
- `<short sha>` <spec-slug>: <one line>

## Blocked
- <spec-slug>: <the question that needs answering> (stash: `<stash message>`)

## Needs you
- <anything from TODOS.md NEEDS INPUT FROM USER added tonight>
- <prep stash, if the tree was dirty>

## Process gaps
- <places the docs, specs, or checks let you down tonight: a doc that was
  wrong, a check that missed something a reviewer caught, an edge case the
  spec forgot>
```

`Process gaps` feeds the morning postmortem. A night with zero gaps and zero
blocked tasks is rare; when it happens, say what made it go smoothly instead.
