#!/bin/sh
# Compile a LaTeX document with tectonic (preferred) or latexmk.
# Usage: compile.sh [main.tex] [--engine tectonic|latexmk]
set -eu

MAIN="main.tex"
ENGINE="auto"

for arg in "$@"; do
  case "$arg" in
    --engine=tectonic|--engine=latexmk|--engine=auto) ENGINE="${arg#--engine=}" ;;
    --engine) echo "usage: compile.sh [main.tex] [--engine tectonic|latexmk]" >&2; exit 2 ;;
    --engine=*) echo "error: unknown engine '$arg'" >&2; exit 2 ;;
    -*) echo "error: unknown flag '$arg'" >&2; exit 2 ;;
    *) MAIN="$arg" ;;
  esac
done

if [ ! -f "$MAIN" ]; then
  echo "error: '$MAIN' not found" >&2
  exit 2
fi

if [ "$ENGINE" = "auto" ]; then
  if command -v tectonic >/dev/null 2>&1; then
    ENGINE="tectonic"
  else
    ENGINE="latexmk"
  fi
fi

case "$ENGINE" in
  tectonic)
    tectonic "$MAIN"
    ;;
  latexmk)
    latexmk -pdf -interaction=nonstopmode -halt-on-error "$MAIN"
    ;;
  *)
    echo "error: unknown engine '$ENGINE'" >&2
    exit 2
    ;;
esac
