#!/usr/bin/env bash
# Print the newest handoff in <repo root>/.handoff/ and exit 1 if there are none.
# Filenames start with a fixed-width timestamp, so sorting by name sorts by time.
set -euo pipefail

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
dir="$root/.handoff"

shopt -s nullglob
files=("$dir"/*.md)
if [ ${#files[@]} -eq 0 ]; then
  echo "No handoffs in $dir" >&2
  exit 1
fi
printf '%s\n' "${files[@]}" | sort | tail -n 1
