# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `just validate` runs `claude plugin validate --strict .`. It is the only check in the repo (no tests, no linter). Run it after editing `.claude-plugin/*.json`, `.claude-plugin/marketplace.json`, or any SKILL.md frontmatter.
- `just add <name>` to create a new skill from the repo root

## Architecture

The repo is a personal Claude Code plugin marketplace. `.claude-plugin/marketplace.json` lists the plugins.

- **Skills.** Each `skills/<name>/SKILL.md` is one skill. The frontmatter `description` is the trigger text. Helper `scripts/` and `assets/` sit beside SKILL.md and are referenced by relative path from the skill body.

## Conventions

- When you add or remove a skill, update the skills table in `README.md`.
