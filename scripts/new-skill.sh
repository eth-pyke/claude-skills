#!/usr/bin/env bash
# Scaffold a new skill from the template: ./scripts/new-skill.sh my-skill-name
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:?usage: new-skill.sh <skill-name> (lowercase, hyphens)}"
[[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Name must be lowercase letters, digits, hyphens"; exit 1; }
DEST="$ROOT/skills/$NAME"
[[ -e "$DEST" ]] && { echo "skills/$NAME already exists"; exit 1; }
cp -R "$ROOT/templates/skill" "$DEST"
sed -i '' "s/SKILL_NAME/$NAME/g" "$DEST/SKILL.md"
echo "Created skills/$NAME/SKILL.md — edit it, then run ./scripts/install.sh"
