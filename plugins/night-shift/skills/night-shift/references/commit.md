# Night shift commit message

One commit per task. The message is the detailed record of the night; the
report only points at it. Write it for the human reviewing it tomorrow, who
will read the message before the diff.

```
<spec-slug>: <what changed, imperative, under 72 chars>

Spec: <path to spec>

What
<two to five sentences on the behaviour that now exists>

Decisions
- <each judgment call the spec left open, what you chose, and why>

Tests
- <each test added, one line, mapped to the spec edge case it covers>

Docs
- <each doc updated, one line>

Review
- <rounds per gate, e.g. plan 2, diff 1>
- <reviewer findings you disagreed with, and why>
- <nits left unfixed>

Watch for
- <anything the human should look at closely or test by hand>
```

Drop a section only when it is truly empty. `Decisions` is the section the
human reads first; an empty one on a non-trivial task usually means a decision
was made without noticing.
