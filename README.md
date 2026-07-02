# skills

Shared skills (and, later, subagents) for Claude Code and Codex. One repo, two
consumption modes:

- **This machine:** `install.sh` symlinks skills into each tool. Symlinks — not
  copies — because skills write back to their own `references/` and memory as
  they run; linking keeps those writes here, git-tracked, shared by both tools.
- **Everyone else:** the repo doubles as a plugin marketplace for both tools
  (versioned snapshots, no write-back).

## Marketplace install

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
Local dev: copy/symlink `plugins/swift-skills` into `~/.cursor/plugins/local/`.

## Layout

```
plugins/swift-skills/             the plugin, shared verbatim by all three tools
  .claude-plugin/plugin.json      Claude plugin manifest
  .codex-plugin/plugin.json       Codex plugin manifest
  .cursor-plugin/plugin.json      Cursor plugin manifest
  skills/<name>/
    SKILL.md                      Claude reads this (frontmatter: name, description)
    agents/openai.yaml            Codex reads this (display_name, default_prompt)
    references/                   supporting docs the skill loads on demand
agents/                           subagents (Claude-only; empty for now)
install.sh                        symlinks skills into each tool (local dev mode)

.claude-plugin/marketplace.json   Claude marketplace catalog
.agents/plugins/marketplace.json  Codex marketplace catalog
```

Plugins must live in a subdirectory (`plugins/<name>`), not at the repo root —
Codex refuses root-as-plugin, and its installer copies files (skipping
symlinks), so the plugin dir holds the real skill content.

Each skill is dual-format on purpose. Claude auto-discovers from the SKILL.md
`description`; Codex invokes explicitly via the `$name` trigger in
`agents/openai.yaml`. Same body, two front doors.

## Local install (symlinks)

```sh
./install.sh            # link everything into both tools
./install.sh claude     # Claude only
./install.sh codex      # Codex only
./install.sh --dry-run  # preview, change nothing
./install.sh --unlink   # remove the symlinks it created
```

Targets (override with `$CLAUDE_HOME` / `$CODEX_HOME`):

| Source            | Claude                      | Codex                                             |
|-------------------|-----------------------------|---------------------------------------------------|
| `skills/<name>/`  | `~/.claude/skills/<name>`   | `~/.agents/skills/<name>` (+ legacy `~/.codex/skills`) |
| `agents/<name>.md`| `~/.claude/agents/<name>.md`| — (no subagent concept)                           |

Cursor needs no target of its own: it reads `~/.agents/skills/` (and falls back
to `~/.claude/skills/`), so the Codex symlinks cover it. Same for subagents —
Cursor reads `~/.claude/agents/` as a compatibility path.

Each skill/agent is linked **individually**, so this composes with the skills
you already have globally — it never replaces the whole directory. If a real
(non-symlink) file already sits at a target, the script skips it and tells you.
Files named `example-*`, `README*`, and dotfiles are not installed.

## Portability notes

- **Skills** map cleanly to both tools; the only per-tool difference is the
  small `openai.yaml` shim (derivable from the SKILL.md frontmatter).
- **Subagents** work in Claude and Cursor (Cursor reads `~/.claude/agents/` as
  a compat path). Codex has no subagent primitive, so `agents/` is linked into
  Claude alone.
- **Cursor** reads SKILL.md natively (Cursor 2.4+) from `~/.agents/skills/` and
  `~/.cursor/skills/`, with `~/.claude/skills/` and `~/.codex/skills/` as
  fallbacks — the symlinks above already cover it.
