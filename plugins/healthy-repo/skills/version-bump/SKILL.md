---
name: version-bump
description: Bump a package version, update CHANGELOG.md, open a release PR, and tag the release. Use when the user asks to bump the version, cut a release, open a release PR, or tag a new version.
---

Bump the package version, record the release in `CHANGELOG.md`, open a release PR, and tag it in git once merged.

## Workflow

1. **Determine the bump.** Ask the user for major, minor, or patch unless they already said.
2. **Update CHANGELOG.md (only if the repo has one).** Follow the [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) spec: move entries from `[Unreleased]` to a new `[x.y.z] - YYYY-MM-DD` section, keeping the `Added` / `Changed` / `Fixed` grouping. Create the file only if the user asks.
3. **Bump the version.** For Python packages, run `uv version --bump <major|minor|patch>` from the package root.
4. **Open a release PR.** Commit the version bump and changelog on a branch, push it, then run `scripts/new-release-pr.sh "$(uv version --short)"` (in this skill's directory) to open the PR with `gh pr create`.
5. **Tag the release (after the PR is merged).** Run `git tag "v$(uv version --short)"`. Do not push the tag unless the user asks.
6. **Report back.** State the new version, the PR link, the tag name, and what changed in the changelog.
