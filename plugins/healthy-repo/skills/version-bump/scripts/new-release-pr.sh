#!/usr/bin/env bash
# Open a release PR with `gh pr create`.
# Usage: new-release-pr.sh <version>
# Run from the package root on the pushed release branch.
set -euo pipefail

version="${1:?Usage: new-release-pr.sh <version>}"
version="${version#v}"
gh pr create --title "bump: version v${version}" --body "Release v${version}."
