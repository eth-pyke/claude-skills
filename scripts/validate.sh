#!/usr/bin/env bash
# Validate the marketplace manifest, every plugin, and SKILL.md frontmatter.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
claude plugin validate "$ROOT" >/dev/null || { claude plugin validate "$ROOT"; fail=1; }
for p in "$ROOT"/plugins/*/; do
  claude plugin validate "$p" >/dev/null || { claude plugin validate "$p"; fail=1; }
done
# Every plugin folder must be listed in marketplace.json, and vice versa
python3 - "$ROOT" <<'PY' || fail=1
import json, pathlib, sys
root = pathlib.Path(sys.argv[1])
listed = {p["name"] for p in json.loads((root / ".claude-plugin/marketplace.json").read_text())["plugins"]}
dirs = {d.name for d in (root / "plugins").iterdir() if d.is_dir()}
bad = False
for n in sorted(dirs - listed): print(f"✗ plugins/{n} is not listed in marketplace.json"); bad = True
for n in sorted(listed - dirs): print(f"✗ marketplace.json lists {n} but plugins/{n} is missing"); bad = True
for f in root.glob("plugins/*/skills/*/SKILL.md"):
    if "SKILL_NAME" in f.read_text(): print(f"✗ {f.relative_to(root)}: template placeholder left in"); bad = True
sys.exit(bad)
PY
[[ $fail -eq 0 ]] && echo "✓ marketplace and all plugins valid"
exit $fail
