---
name: arxiv
description: Fetch an arXiv paper PDF and LaTeX source into .research/references using the bundled fetch script.
---

# arXiv Fetch

Fetch arXiv papers and their LaTeX source into the project's reference store.

## Layout

Store every paper under `.research/references/<arxiv-id>/`:

- `<arxiv-id>.pdf` — the published PDF.
- `source/` — the extracted e-print source (`.tex`, figures, `.bbl` inputs).
- `meta.json` — id, URL, fetched date, and which artifacts succeeded.

Normalize `<arxiv-id>` as the full arXiv identifier with version when given
(for example `2301.12345v2` or `hep-th/9901001v1`), stripping any URL prefix.

## Workflow

1. Run the bundled script from the project root:
   `sh <plugin-root>/skills/arxiv/scripts/fetch-arxiv.sh <arxiv-id> [--pdf-only | --source-only]`
2. Do not invent the PDF or source contents. If either download fails,
   report which artifact failed and keep whatever succeeded.
3. Read the extracted `.tex` files for citations, notation, or proofs;
   cite the arXiv id in any summary.

## Script behavior

- Uses `curl` with retries and fails on HTTP errors.
- PDF comes from `https://arxiv.org/pdf/<id>`.
- Source tarball comes from `https://arxiv.org/e-print/<id>` and is
  extracted with `tar` into `source/`. Some e-prints are single files
  rather than tarballs; the script keeps those as `source/eprint-file`.
- Creates `.research/references/` when missing. Never writes outside it.
