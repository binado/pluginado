---
paths:
  - "**/*.py"
---

# Python styleguide

- Use type annotations whenever possible (function signatures, class attributes, module-level constants).
- Type-check with `ty` (`uvx ty check`) — fix reported errors rather than suppressing them.
- Lint and format with `ruff` (`uvx ruff check`, `uvx ruff format`).
- Use numpy-style docstrings (`Parameters`, `Returns`, `Raises` sections) for public functions, classes, and modules.
- Concentrate imports at the top of the file. Only use inline/deferred imports when required (circular-import avoidance, optional/heavy dependencies, genuinely dynamic imports).
