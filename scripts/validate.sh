#!/usr/bin/env bash
# Check each skill has a SKILL.md with name + description frontmatter matching its folder.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"; f="$dir/SKILL.md"
  if [[ ! -f "$f" ]]; then echo "✗ $name: missing SKILL.md"; fail=1; continue; fi
  [[ "$(head -1 "$f")" == "---" ]] || { echo "✗ $name: no frontmatter"; fail=1; continue; }
  fm_name="$(awk '/^---$/{n++; next} n==1 && /^name:/{sub(/^name:[ ]*/,""); print; exit}' "$f" | tr -d '"'"'"'"')"
  fm_desc="$(awk '/^---$/{n++; next} n==1 && /^description:/{print; exit}' "$f")"
  [[ "$fm_name" == "$name" ]] || { echo "✗ $name: frontmatter name '$fm_name' != folder name"; fail=1; }
  [[ -n "$fm_desc" ]] || { echo "✗ $name: missing description"; fail=1; }
  grep -q 'SKILL_NAME' "$f" && { echo "✗ $name: template placeholder left in"; fail=1; }
done
[[ $fail -eq 0 ]] && echo "✓ all skills valid"
exit $fail
