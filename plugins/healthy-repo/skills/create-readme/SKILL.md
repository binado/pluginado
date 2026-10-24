---
name: create-readme
description: Create a concise README.md for a repository or package from a standard template. Use when the user asks to create, write, add or generate a README, or to document a repo or package that has none.
---

Create a `README.md` at the root of the target repository or package, using [README_TEMPLATE.md](assets/README_TEMPLATE.md) in this skill's directory.

## Workflow

1. **Check for an existing README.** If one exists, ask the user before overwriting it.
2. **Read the project.** Look at the manifest (`pyproject.toml`, `package.json`, `Cargo.toml`, `plugin.json`, ...), the entry point or public API, the LICENSE file, and any install commands already in the justfile, Makefile or CI.
3. **Fill the template.**
   - Keep the sections that apply and delete the rest, headings included. Replace every `<...>` placeholder.
   - One-liner: one sentence saying what the project does.
   - Installation: the real package-manager, clone or plugin command.
   - Usage: one or two short, runnable examples of the public API.
   - Features: plain-text bullets, no bold.
   - Caveats, Acknowledgements and References: only when they apply. References are one bullet each.
   - License: name it from the LICENSE file or manifest.
4. **Keep it short.** Aim for about one screen. Do not restate behaviour that docstrings or `--help` already describe; point to them instead. Do not list every parameter or option.
5. **Write the file.** Save it as `README.md` at the repository root. Keep the template's heading order. Do not add badges, a table of contents, or sections the template does not have unless the user asks.
6. **Report back.** List the sections kept and removed, and anything you could not confirm, such as the license or the install command.

## Notes

- Use only facts from the code and manifests. If a value is unknown, ask the user rather than invent it.
