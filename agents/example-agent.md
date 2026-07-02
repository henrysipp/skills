---
name: example-agent
description: Delete this file. It shows the frontmatter shape a Claude Code subagent expects.
tools: Read, Grep, Glob
model: sonnet
---

You are an example subagent. Replace this file with a real one.

Claude Code reads `name`, `description`, `tools`, and `model` from the frontmatter.
Codex ignores the frontmatter and treats the whole file as instruction text, so
write the body so it still makes sense on its own.
