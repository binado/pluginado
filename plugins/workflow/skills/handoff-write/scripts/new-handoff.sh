#!/usr/bin/env bash
# Print a fresh handoff path: <repo root>/.handoff/<timestamp>[-slug].md.
# Usage: new-handoff.sh [topic words...]
# Falls back to the current directory outside a git repo.
# Warns on stderr when the repo does not gitignore .handoff/.
set -euo pipefail

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
dir="$root/.handoff"
mkdir -p "$dir"

slug=$(printf '%s' "$*" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | cut -c1-40 | sed 's/^-*//; s/-*$//')
name="$(date +%Y%m%dT%H%M%S)"
if [ -n "$slug" ]; then
  name="$name-$slug"
fi
printf '%s\n' "$dir/$name.md"

if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if ! git -C "$root" check-ignore -q "$dir/"; then
    echo "WARN: .handoff/ is not gitignored in $root" >&2
  fi
fi
