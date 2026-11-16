#!/bin/sh
# Fetch an arXiv paper PDF and LaTeX source into .research/references.
# Usage: fetch-arxiv.sh <arxiv-id> [--pdf-only | --source-only]
set -eu

ID_RAW="${1:-}"
MODE="${2:-all}"

if [ -z "$ID_RAW" ]; then
  echo "usage: fetch-arxiv.sh <arxiv-id> [--pdf-only | --source-only]" >&2
  exit 2
fi

# Strip common URL prefixes down to the bare identifier.
ID="$(printf '%s' "$ID_RAW" | sed -e 's#^https\?://arxiv\.org/abs/##' -e 's#^https\?://arxiv\.org/pdf/##' -e 's#\.pdf$##' -e 's#^arXiv:##')"
if [ -z "$ID" ]; then
  echo "error: could not parse arXiv id from '$ID_RAW'" >&2
  exit 2
fi

# Sanity check: new-style (yymm.nnnnn) or old-style (archive/nnnnnnn) ids.
case "$ID" in
  *..*|*/*/*|*" "*|*\\*|"")
    echo "error: suspicious arXiv id '$ID'" >&2
    exit 2
    ;;
esac

DEST=".research/references/$ID"
mkdir -p "$DEST/source"

PDF_OK=0
SRC_OK=0

if [ "$MODE" != "--source-only" ]; then
  if curl -fL --retry 3 -o "$DEST/$ID.pdf" "https://arxiv.org/pdf/$ID"; then
    PDF_OK=1
  else
    echo "warning: PDF download failed for $ID" >&2
    rm -f "$DEST/$ID.pdf"
  fi
fi

if [ "$MODE" != "--pdf-only" ]; then
  TMP="$(mktemp "$DEST/eprint-XXXXXX.tar.gz")"
  if curl -fL --retry 3 -o "$TMP" "https://arxiv.org/e-print/$ID"; then
    if tar -tzf "$TMP" >/dev/null 2>&1; then
      tar -xzf "$TMP" -C "$DEST/source"
      SRC_OK=1
    else
      # Single-file e-print (e.g. a lone .tex or .pdf); keep it as-is.
      mv "$TMP" "$DEST/source/eprint-file"
      SRC_OK=1
    fi
  else
    echo "warning: source download failed for $ID" >&2
  fi
  rm -f "$TMP"
fi

DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat > "$DEST/meta.json" <<EOF
{"arxiv_id": "$ID", "pdf": $PDF_OK, "source": $SRC_OK, "fetched_at": "$DATE", "pdf_url": "https://arxiv.org/pdf/$ID", "source_url": "https://arxiv.org/e-print/$ID"}
EOF

echo "stored $ID in $DEST (pdf=$PDF_OK source=$SRC_OK)"
