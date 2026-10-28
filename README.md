# skills

Skills packaged as plugins, installable in Claude Code, Codex, and Cursor from
this repo. `swift-skills` holds the Swift/SwiftUI work; `general-skills` holds
language-agnostic ones; `night-shift` is the spec-by-day, agents-by-night
workflow (see [its README](plugins/night-shift/README.md)).

## Install

Claude Code:

```
/plugin marketplace add henrysipp/skills
/plugin install swift-skills@henry-skills
/plugin install general-skills@henry-skills
/plugin install night-shift@henry-skills
```

Codex:

```
codex plugin marketplace add henrysipp/skills
codex plugin add swift-skills@henry-skills
codex plugin add general-skills@henry-skills
codex plugin add night-shift@henry-skills
```

Cursor: no third-party marketplace registration. Install from GitHub via
Customize → Rules → Remote Rule (repo URL), or publish to cursor.com/marketplace.
Local dev: copy the plugin dir into `~/.cursor/plugins/local/`.

Local checkout works too — point `marketplace add` at the repo path instead of
`owner/repo`. Installs are cached copies either way; pull updates with
`/plugin marketplace update` (Claude) or `codex plugin marketplace upgrade`.

## Layout

```
plugins/<plugin>/                 a plugin, shared verbatim by all three tools
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

Edit under `plugins/<plugin>/skills/`, bump `version` in that plugin's three
plugin.json manifests, commit. Consumers pick it up on their next marketplace
update. Installed copies live in each tool's plugin cache — edits there are
lost on update, so always change the repo, not the cache.

## Portability notes

- **Skills** map cleanly to all three tools; the only per-tool difference is
  the small `openai.yaml` shim (derivable from the SKILL.md frontmatter).
- **Subagents** work in Claude and Cursor. Codex has no subagent primitive.
- **Cursor** reads SKILL.md natively (Cursor 2.4+); plugin manifest support
  landed in 2.5.
