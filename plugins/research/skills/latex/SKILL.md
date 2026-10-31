---
name: latex
description: Write clear academic LaTeX and compile it with latexmk or tectonic via the bundled compile script.
---

# LaTeX Writing and Compilation

Write and compile LaTeX documents with a consistent style.

## Writing style

- One sentence per line in `.tex` sources so diffs stay readable.
- Prefer `amsmath`, `amssymb`, `amsthm`, `mathtools`, `booktabs`, and
  `hyperref` with `cleveref` for cross-references.
- Label everything referenced (`\label{sec:..}`, `\label{fig:..}`,
  `\label{eq:..}`). Reference with `\ref{}` and `\eqref{}`
- Keep figures as vector PDFs in a `figures/` directory; never commit
  build artifacts (`.aux`, `.bbl`, `.log`, `.out`, `.pdf` intermediates).
- Match the venue template (article, IEEE, ACM, LNCS) before adding packages.
- Avoid inline equations unless they are trivial. New variables that are referenced
later should be introduced in proper equation environments

## Compilation

Run the bundled script from the project root:

- `sh <plugin-root>/skills/latex/scripts/compile.sh [main.tex] [--engine latexmk|tectonic]`

Rules:

1. Default to `tectonic` when installed, otherwise `latexmk -pdf`.
   An explicit `--engine` flag overrides the default.
2. Never commit build output next to sources; pass `-outdir` through to
   `latexmk` or let `tectonic` use its default build directory.
3. On failure, read the log tail first and fix the first error before
   rerunning — do not loop blindly.
4. For venues requiring `.bbl` upload, run the full `latexmk` pass so
   BibTeX/biber resolves before submission.
