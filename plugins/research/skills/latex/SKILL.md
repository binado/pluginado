---
name: latex
description: Write clear academic LaTeX.
---

# LaTeX Writing

Write LaTeX documents with a consistent style.

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
- Compile with `latexmk`.
