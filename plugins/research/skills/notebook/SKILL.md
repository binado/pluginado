---
name: notebook
description: Write well-structured Jupyter, marimo, or Pluto notebooks with a title, imports cell, config cell, and semantic sections.
---

# Notebook Writing

Write notebooks that read like a short lesson, not a script dump.
Apply to Jupyter (`.ipynb`), marimo (`.py`), and Pluto (`.jl`).

## Universal layout, in order

1. **Title markdown cell.** The notebook starts with a `#` markdown
   title, plus one or two sentences saying what the reader will learn.
2. **First code cell: imports only.** Standard library, third-party,
   then local imports. No data loading, no computation, no plotting.
   Jupyter adds the retina config here (see below).
3. **Second code cell: configuration variables.** Input/output paths,
   filenames, random seeds, and config knobs (figure size, sample counts,
   thresholds). Everything later cells need to tweak lives here so a
   reader reproduces the notebook by editing one cell.
4. **Body: alternating markdown and small code cells.** Each section
   opens with a markdown header (`##`) stating its idea, followed by
   one or a few short code cells. Split code cells by semantics
   (load data / clean / analyze / plot), never one monolithic cell.

## Markdown and tone

- Give every section a markdown header and a short goal sentence before
  any code.
- Write for the concept: explain what the step shows and why it
  matters, not how each line of code works.
- Keep markdown free of code technicalities (no function signatures,
  parameter dumps, or line-by-line walkthroughs).

## Jupyter specifics

- In the imports cell, enable retina figures with the exact line:
  `%config InlineBackend.figure_format = 'retina'`
- One statement group per cell; restart-and-run-top-to-bottom must work.

## marimo specifics

- `import marimo as mo` opens the imports cell; the title is
  `mo.md("# Title ...")` in its own cell.
- Each cell is an `@app.cell` function that declares its inputs as
  arguments and exposes outputs via `return`; never rely on hidden
  execution order.

## Pluto specifics

- The title is a markdown-string cell, e.g. `md"""# Title ..."""`
  (with `using PlutoUI` in the imports cell).
- Pluto cells are reactive: keep one definition per cell and keep cells
  order-independent so any cell can re-run safely.
