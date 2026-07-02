#!/usr/bin/env bash
#
# Symlink this repo's skills and agents into Claude Code and Codex.
#
# Why symlinks: skills write back to their own references/ and memory as they
# run. Linking (not copying) keeps those writes in this repo — git-tracked and
# shared by both tools at once.
#
# Source of truth:
#   ./plugins/swift-skills/skills/<name>/
#                      -> Claude ~/.claude/skills/<name>
#                      -> Codex  ~/.agents/skills/<name> (current) and
#                                ~/.codex/skills/<name>  (legacy)
#   ./agents/<name>.md -> Claude ~/.claude/agents/<name>.md   (Codex has no subagents; skipped)
#
# Usage:
#   ./install.sh              # link everything into both tools
#   ./install.sh claude       # Claude only
#   ./install.sh codex        # Codex only
#   ./install.sh --dry-run    # print what would happen, change nothing
#   ./install.sh --unlink     # remove the symlinks this script created
#
# Honors $CODEX_HOME (defaults to ~/.codex) and $CLAUDE_HOME (defaults to ~/.claude).
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"

DRY_RUN=false
UNLINK=false
DO_CLAUDE=false
DO_CODEX=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --unlink)  UNLINK=true ;;
    claude)    DO_CLAUDE=true ;;
    codex)     DO_CODEX=true ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $arg" >&2; exit 1 ;;
  esac
done

# no tool named -> both
if ! $DO_CLAUDE && ! $DO_CODEX; then DO_CLAUDE=true; DO_CODEX=true; fi

link_item() {
  local src="$1" dest="$2"
  local parent; parent="$(dirname "$dest")"

  if $UNLINK; then
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "unlink  $dest"
      $DRY_RUN || rm "$dest"
    fi
    return
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok      $dest"; return
  fi
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "SKIP    $dest exists and is not our symlink — leaving it alone" >&2; return
  fi
  if [ -L "$dest" ]; then
    echo "relink  $dest (was -> $(readlink "$dest"))"
    $DRY_RUN || rm "$dest"
  fi
  echo "link    $dest -> $src"
  $DRY_RUN || { mkdir -p "$parent"; ln -s "$src" "$dest"; }
}

# skip dotfiles, README, and example-* placeholders
should_skip() {
  case "$(basename "$1")" in
    .*|README*|example-*) return 0 ;;
    *) return 1 ;;
  esac
}

link_dir() {
  local src_dir="$1" dest_dir="$2" glob="$3"
  [ -d "$src_dir" ] || return 0
  shopt -s nullglob
  for item in "$src_dir"/$glob; do
    should_skip "$item" && continue
    link_item "$item" "$dest_dir/$(basename "$item")"
  done
  shopt -u nullglob
}

if $DO_CLAUDE; then
  echo "== Claude ($CLAUDE_HOME) =="
  link_dir "$REPO_DIR/plugins/swift-skills/skills" "$CLAUDE_HOME/skills" '*/'
  link_dir "$REPO_DIR/agents" "$CLAUDE_HOME/agents" '*.md'
fi

if $DO_CODEX; then
  echo "== Codex ($AGENTS_HOME, legacy $CODEX_HOME) =="
  link_dir "$REPO_DIR/plugins/swift-skills/skills" "$AGENTS_HOME/skills" '*/'   # current documented path
  link_dir "$REPO_DIR/plugins/swift-skills/skills" "$CODEX_HOME/skills" '*/'    # legacy path, harmless to keep
  # Codex has no subagent primitive; agents/ intentionally not linked here.
fi
