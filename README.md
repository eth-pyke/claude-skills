# claude-skills

My custom [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills).

## Layout

```
skills/<skill-name>/SKILL.md   # one folder per skill (+ any scripts/reference files it needs)
templates/skill/               # starter used by new-skill.sh
scripts/new-skill.sh           # scaffold a new skill
scripts/install.sh             # symlink skills into ~/.claude/skills
scripts/validate.sh            # sanity-check frontmatter
```

## Workflow

```bash
./scripts/new-skill.sh my-skill     # create skills/my-skill/SKILL.md
# edit skills/my-skill/SKILL.md
./scripts/validate.sh
./scripts/install.sh                # link into ~/.claude/skills (once per new skill)
git add . && git commit -m "Add my-skill"
```

Because skills are symlinked, edits in this repo are live in Claude Code right away.
You can also ask Claude to use the `skill-creator` skill to draft and test a skill in `skills/`.

## Setting up on another machine

```bash
git clone <this-repo-url> ~/Documents/Projects/claude-skills
~/Documents/Projects/claude-skills/scripts/install.sh
```

## SKILL.md basics

- `name`: lowercase-with-hyphens, must match the folder name.
- `description`: what it does **and when to use it** — Claude decides whether to load the skill from this line, so make it specific.
- Body: the instructions. Keep it focused; put long reference material in separate files and link to them.
