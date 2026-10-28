---
name: night-shift-setup
description: Prepare a repo for the night-shift loop. Writes NIGHT_SHIFT.md, REVIEW_PERSONAS.md, a specs folder with a template, and TODOS.md, filled in from what the repo already has. Use when setting up night shift in a repo, or when the night-shift skill reports NIGHT_SHIFT.md is missing.
disable-model-invocation: true
---

# Night Shift Setup

The loop is only as good as the repo's checks and docs. Setup's job is to
write down what already exists so the agent never guesses, and to show the
human the gaps that will hurt overnight.

## 1. Survey

Find, by reading the repo rather than asking:

- **Checks**: the commands for the full test suite, a targeted test run, type
  checking, linting, formatting, and build. Look in `package.json` scripts,
  `justfile`, `Makefile`, `mise.toml`, `fastlane/`, CI config, and
  `CLAUDE.md` / `AGENTS.md`. CI config is the best source: it is what has to
  pass.
- **Docs**: the agent router (`AGENTS.md`, `CLAUDE.md`) and every doc folder.
  Note which areas of the system each doc covers.
- **Existing files** that collide with what setup writes: `CHANGELOG.md`,
  `TODOS.md`, a specs or RFC folder.

Done when every check category has a command or is confirmed absent.

## 2. Confirm with the human

Show one short table: each check with its command, plus what is missing. Ask
only what the repo cannot tell you:

- Where specs live (default `Specs/`, or an existing folder).
- What is off-limits overnight (migrations, CI config, release config,
  infrastructure, vendored code — propose a list from what you found).
- Whether to use a second model for some reviews, and which CLI.

Wait for answers before writing.

## 3. Write the files

Copy each template from `references/templates/` and fill it in from the survey
and the answers. Merge into a file that already exists rather than replacing
it.

| File | Template |
| --- | --- |
| `NIGHT_SHIFT.md` | [NIGHT_SHIFT.md](references/templates/NIGHT_SHIFT.md) |
| `REVIEW_PERSONAS.md` | [REVIEW_PERSONAS.md](references/templates/REVIEW_PERSONAS.md) |
| `<specs>/_template.md` | [spec.md](references/templates/spec.md) |
| `TODOS.md` | [TODOS.md](references/templates/TODOS.md) |
| `CHANGELOG.md` | add an `## Unreleased` heading if it has none |

In `REVIEW_PERSONAS.md`, assign every doc you found to exactly one persona. A
doc nobody owns is a rule nobody checks. Drop or rename personas that do not
fit the project (a CLI has no Designer); keep at least three.

Add `.night-shift/` to `.gitignore`: plans and reports are working files.

Add one line to the agent router (`AGENTS.md` or `CLAUDE.md`) pointing at
`NIGHT_SHIFT.md`, so interactive sessions know the convention exists.

## 4. Report the gaps

End with what will make the first night go badly, most damaging first:

- A missing check category (no type checker, no linter, no way to run one test).
- An area of code with no doc covering it.
- Tests that are slow, flaky, or need network or a device the agent cannot reach.

These are the day-shift work that makes the night shift pay off.
