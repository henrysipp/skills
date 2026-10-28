---
name: spec-check
description: Review a hand-written spec before it goes to the night shift and return a short checklist of gaps, missing edge cases, and contradictions with the docs. Use when the user asks to check, review, or poke holes in a spec.
argument-hint: Path to the spec
disable-model-invocation: true
---

# Spec Check

The human writes the spec; writing it is how they think. Your job is to find
what the night shift would trip on, and hand back a checklist. The human
decides what to do with each item and edits the spec themselves, so leave the
spec file unchanged.

1. Read the spec, then the docs and code its `Pointers` name, then whatever
   else the behaviour touches.
2. Look for:
   - **Gaps**: behaviour the spec implies but never states. Inputs with no
     expected result.
   - **Edge cases** missing from the list: empty, huge, offline, concurrent,
     repeated, interrupted, first run, permission denied, existing data in an
     old shape.
   - **Contradictions** with the docs or with current behaviour the spec
     doesn't mention changing.
   - **Untestable lines**: anything the night shift could not turn into a
     test that goes red then green.
   - **Open decisions** the agent would have to make alone overnight.
3. Return the checklist and nothing else:

```
- [ ] <gap | edge | conflict | untestable | decision>: <one line> (<doc or file:line when relevant>)
```

Aim for the five to fifteen items that matter. A long list of nits buries the
two that would have blocked the night.

If the spec is ready as written, say so in one line.
