# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

## Commands

- `just validate` runs `claude plugin validate --strict` on the marketplace root and each `plugins/*/`. It is the only check in the repo (no tests, no linter). Run it after editing `.claude-plugin/*.json`, `.claude-plugin/marketplace.json`, `plugins/*/plugin.json`, or any SKILL.md frontmatter.
- `just add <name>` to create a new skill from the repo root
- `just create-plugin <name> <description>` to scaffold a new plugin under `plugins/` (both manifests, README, marketplace entry)

## Architecture

The repo is a personal Claude Code plugin marketplace. `.claude-plugin/marketplace.json` lists the plugins in `plugins/`.

- **Plugins.** Each `plugins/<name>` is its own plugin with its own `.claude-plugin/plugin.json` manifest (Claude Code) and `plugin.json` manifest (agent-plugins.org schema).
- **Skills.** Each `plugins/<name>/skills/<skill>/SKILL.md` is one skill. The frontmatter `description` is the trigger text. Helper `scripts/` and `assets/` sit beside SKILL.md and are referenced by relative path from the skill body.

## Conventions

- When you add or remove a plugin, update `.claude-plugin/marketplace.json` and the plugins table in `README.md`.
- When you add or remove a skill, update the skills tables in `README.md` and in that plugin's `README.md`.
