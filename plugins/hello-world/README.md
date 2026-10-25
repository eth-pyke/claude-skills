# hello-world

A minimal example plugin for the `eth-pyke-skills` marketplace. It ships one skill,
`hello-world`, that replies with a short greeting and confirms the marketplace and its
plugins are loading correctly in Claude Code.

## Install

```
/plugin marketplace add eth-pyke/claude-skills
/plugin install hello-world@eth-pyke-skills
```

## Usage

Start a new session and say "test my skills repo". Claude should load the skill and greet
you. No setup or connectors are required. Use this plugin as a reference when you build
new ones.
