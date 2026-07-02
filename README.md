# skills

Swift/SwiftUI skills packaged as one plugin, installable in Claude Code,
Codex, and Cursor from this repo.

## Install

Claude Code:

```
/plugin marketplace add henrysipp/skills
/plugin install swift-skills@henry-skills
```

Codex:

```
codex plugin marketplace add henrysipp/skills
codex plugin add swift-skills@henry-skills
```

Cursor: no third-party marketplace registration. Install from GitHub via
Customize → Rules → Remote Rule (repo URL), or publish to cursor.com/marketplace.
Local dev: copy `plugins/swift-skills` into `~/.cursor/plugins/local/`.

Local checkout works too — point `marketplace add` at the repo path instead of
`owner/repo`. Installs are cached copies either way; pull updates with
`/plugin marketplace update` (Claude) or `codex plugin marketplace upgrade`.

## Layout

```
plugins/swift-skills/             the plugin, shared verbatim by all three tools
  .claude-plugin/plugin.json      Claude plugin manifest
  .codex-plugin/plugin.json       Codex plugin manifest
  .cursor-plugin/plugin.json      Cursor plugin manifest
  skills/<name>/
    SKILL.md                      Claude/Cursor read this (frontmatter: name, description)
    agents/openai.yaml            Codex reads this (display_name, default_prompt)
    references/                   supporting docs the skill loads on demand
agents/                           subagents (Claude/Cursor; empty for now)

.claude-plugin/marketplace.json   Claude marketplace catalog
.agents/plugins/marketplace.json  Codex marketplace catalog
```

Plugins must live in a subdirectory (`plugins/<name>`), not at the repo root —
Codex refuses root-as-plugin, and its installer copies files (skipping
symlinks), so the plugin dir holds the real skill content.

## Updating skills

Edit under `plugins/swift-skills/skills/`, bump `version` in all three
plugin.json manifests, commit. Consumers pick it up on their next marketplace
update. Installed copies live in each tool's plugin cache — edits there are
lost on update, so always change the repo, not the cache.

## Portability notes

- **Skills** map cleanly to all three tools; the only per-tool difference is
  the small `openai.yaml` shim (derivable from the SKILL.md frontmatter).
- **Subagents** work in Claude and Cursor. Codex has no subagent primitive.
- **Cursor** reads SKILL.md natively (Cursor 2.4+); plugin manifest support
  landed in 2.5.
