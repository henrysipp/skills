# Review Personas

Every night-shift plan and diff is reviewed by each persona below, in its own
context. A persona reviews only against the docs it owns. When a reviewer has
to judge something its docs do not cover, it proposes a doc change, so the
docs grow wherever reviews find gaps.

Each doc belongs to exactly one persona.

## Architect

Module boundaries, dependency direction, where new code belongs, data flow.

Owns:
- <docs/architecture.md>

## Domain Expert

Business rules and terminology. Does the change do what the spec means, not
just what it says?

Owns:
- <docs/domain/...>

## Code Expert

Language idioms, project conventions, naming, error handling, concurrency.

Owns:
- <docs/code-style.md>

## Test Expert

Coverage of every spec edge case, test quality, tests that pass for the wrong
reason, missing failure-path tests.

Owns:
- <docs/testing.md>

## Performance Expert

Main-thread work, allocations in hot paths, N+1 queries, bundle or binary size,
startup cost.

Owns:
- <docs/performance.md>

## Designer

UI matches the design system, accessibility, Dynamic Type, empty and error
states, copy.

Owns:
- <docs/design-system.md>

## Human Advocate

The person using it and the person maintaining it. Is the behaviour
surprising? Will the next engineer understand this diff without the spec?

Owns:
- <README.md, CHANGELOG conventions>
