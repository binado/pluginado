#!/usr/bin/env bash
# Create an empty scratch script and print its path: <repo root>/.scratchpad/<timestamp>-<name>[.ext].
# Usage: new-scratch-script.sh <name>[.ext]   e.g. new-scratch-script.sh sum-monthly-invoice-totals.py
# Falls back to the current directory outside a git repo.
# Warns on stderr when the name is not 3-5 words or the repo does not gitignore .scratchpad/.
set -euo pipefail

if [ $# -ne 1 ] || [ -z "$1" ]; then
  echo "usage: new-scratch-script.sh <name>[.ext]" >&2
  exit 2
fi

base=$(basename "$1")
case "$base" in
  *.*) stem=${base%.*}; ext=".${base##*.}" ;;
  *) stem=$base; ext="" ;;
esac

slug=$(printf '%s' "$stem" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-*//; s/-*$//')
if [ -z "$slug" ]; then
  echo "error: name '$1' has no letters or digits" >&2
  exit 2
fi

words=$(printf '%s\n' "$slug" | awk -F- '{ print NF }')
if [ "$words" -lt 3 ] || [ "$words" -gt 5 ]; then
  echo "WARN: '$slug' has $words words; use 3-5" >&2
fi

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
dir="$root/.scratchpad"
mkdir -p "$dir"

path="$dir/$(date +%Y%m%dT%H%M%S)-$slug$ext"
if [ -e "$path" ]; then
  echo "error: $path already exists" >&2
  exit 1
fi
touch "$path"
printf '%s\n' "$path"

if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if ! git -C "$root" check-ignore -q "$dir/"; then
    echo "WARN: .scratchpad/ is not gitignored in $root" >&2
  fi
fi
