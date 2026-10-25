#!/usr/bin/env bash
# Symlink every skill in skills/ into ~/.claude/skills so Claude Code picks it up.
# Edits in the repo take effect immediately; re-run after adding a new skill.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$TARGET"
for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || { echo "skip $name (no SKILL.md)"; continue; }
  link="$TARGET/$name"
  if [[ -L "$link" ]]; then
    ln -sfn "${dir%/}" "$link"; echo "updated $name"
  elif [[ -e "$link" ]]; then
    echo "skip $name ($link exists and is not a symlink)"
  else
    ln -s "${dir%/}" "$link"; echo "linked  $name"
  fi
done
# Remove dangling links that point back into this repo (deleted/renamed skills)
for link in "$TARGET"/*; do
  [[ -L "$link" && ! -e "$link" && "$(readlink "$link")" == "$ROOT"/* ]] && { rm "$link"; echo "removed stale $(basename "$link")"; }
done
