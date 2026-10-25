# eth-pyke-skills

A [Claude Code plugin marketplace](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
of my custom skills. Each plugin wraps one skill and can be installed on its own.

## Install

```
/plugin marketplace add eth-pyke/claude-skills
/plugin install weekly-job-digest@eth-pyke-skills
```

Or from a shell: `claude plugin marketplace add eth-pyke/claude-skills`.
Get new versions with `/plugin marketplace update eth-pyke-skills`.

## Plugins

| Plugin | What it does |
| --- | --- |
| [weekly-job-digest](plugins/weekly-job-digest) | Weekly job-search digest that emails new, well-fitting postings |
| [hello-world](plugins/hello-world) | Example plugin to check the marketplace is working |

## Layout

```
.claude-plugin/marketplace.json            # marketplace catalog (lists every plugin)
plugins/<name>/.claude-plugin/plugin.json  # plugin manifest (name, version, description)
plugins/<name>/skills/<name>/SKILL.md      # the skill itself (+ any scripts/reference files)
plugins/<name>/README.md
templates/plugin/                          # starter used by new-plugin.sh
scripts/new-plugin.sh                      # scaffold a plugin and register it
scripts/validate.sh                        # validate marketplace + all plugins
```

## Adding a plugin

```bash
./scripts/new-plugin.sh my-skill "One-line description" [category]
# edit plugins/my-skill/skills/my-skill/SKILL.md and README.md
./scripts/validate.sh
git add -A && git commit -m "Add my-skill" && git push
```

To try a plugin before pushing: `claude --plugin-dir plugins/my-skill`.

When you change an existing plugin, bump `version` in its `plugin.json` so installed copies
pick up the update. You can tag a release with `claude plugin tag plugins/<name>`.

## Writing a good SKILL.md

- `name`: lowercase-with-hyphens, matching the folder name.
- `description`: what it does **and when to use it**. Claude decides whether to load the skill from this line, so make it specific.
- Body: the instructions. Keep it focused, and put long reference material in separate files that the skill links to.
