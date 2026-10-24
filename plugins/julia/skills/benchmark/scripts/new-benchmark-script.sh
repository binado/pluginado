#!/usr/bin/env bash
# Create <repo root>/.benchmark/<name>/benchmark.jl from the benchmark template and print its path.
# The script's results.csv and results.md are written to the same directory when it runs.
# Usage: new-benchmark-script.sh <name>   e.g. new-benchmark-script.sh diagonal-inner-product-methods
# Falls back to the current directory outside a git repo.
# Warns on stderr when the name is not 2-4 words, Julia or BenchmarkTools is missing from the
# active environment, or the repo does not gitignore .benchmark/. Never overwrites a directory.
set -euo pipefail

if [ $# -ne 1 ] || [ -z "$1" ]; then
  echo "usage: new-benchmark-script.sh <name>" >&2
  exit 2
fi

skill_dir=$(cd "$(dirname "$0")/.." && pwd)
template="$skill_dir/assets/benchmark_example.jl"

slug=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-*//; s/-*$//')
if [ -z "$slug" ]; then
  echo "error: name '$1' has no letters or digits" >&2
  exit 2
fi

words=$(printf '%s\n' "$slug" | awk -F- '{ print NF }')
if [ "$words" -lt 2 ] || [ "$words" -gt 4 ]; then
  echo "WARN: '$slug' has $words words; use 2-4" >&2
fi

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
benchmarks="$root/.benchmark"
dir="$benchmarks/$slug"
if [ -e "$dir" ]; then
  echo "error: $dir already exists" >&2
  exit 1
fi
mkdir -p "$dir"
cp "$template" "$dir/benchmark.jl"
printf '%s\n' "$dir/benchmark.jl"

if ! command -v julia >/dev/null 2>&1; then
  echo "WARN: julia is not on PATH; the benchmark cannot run" >&2
else
  # Check the repo's project if it has one, otherwise the default environment.
  if [ -f "$root/Project.toml" ]; then
    julia_cmd=(julia --project="$root")
  else
    julia_cmd=(julia)
  fi
  # Read the active project's own dependencies; find_package would also search the default environment.
  if ! "${julia_cmd[@]}" -e 'using Pkg; exit(haskey(Pkg.project().dependencies, "BenchmarkTools") ? 0 : 1)' >/dev/null 2>&1; then
    echo "WARN: BenchmarkTools is not in the active Julia environment; ask the user before running Pkg.add(\"BenchmarkTools\")" >&2
  fi
fi

if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if ! git -C "$root" check-ignore -q "$benchmarks/"; then
    echo "WARN: .benchmark/ is not gitignored in $root" >&2
  fi
fi
