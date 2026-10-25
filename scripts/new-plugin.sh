#!/usr/bin/env bash
# Scaffold a new single-skill plugin and register it in the marketplace.
#   ./scripts/new-plugin.sh my-plugin "One-line description" [category]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:?usage: new-plugin.sh <name> \"<description>\" [category]}"
DESC="${2:?description required}"
CATEGORY="${3:-productivity}"
[[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Name must be lowercase letters, digits, hyphens"; exit 1; }
DEST="$ROOT/plugins/$NAME"
[[ -e "$DEST" ]] && { echo "plugins/$NAME already exists"; exit 1; }
cp -R "$ROOT/templates/plugin" "$DEST"
mv "$DEST/skills/SKILL_NAME" "$DEST/skills/$NAME"
NAME="$NAME" DESC="$DESC" CATEGORY="$CATEGORY" DEST="$DEST" ROOT="$ROOT" python3 - <<'PY'
import json, os, pathlib
n, d, c, dest, root = (os.environ[k] for k in ("NAME", "DESC", "CATEGORY", "DEST", "ROOT"))
for f in pathlib.Path(dest).rglob("*"):
    if f.is_file():
        f.write_text(f.read_text().replace("SKILL_NAME", n).replace("SKILL_DESCRIPTION", d))
mp = pathlib.Path(root, ".claude-plugin/marketplace.json")
m = json.loads(mp.read_text())
m["plugins"].append({"name": n, "source": f"./plugins/{n}", "description": d, "category": c})
mp.write_text(json.dumps(m, indent=2) + "\n")
PY
echo "Created plugins/$NAME and added it to the marketplace."
echo "Edit plugins/$NAME/skills/$NAME/SKILL.md, then run ./scripts/validate.sh"
