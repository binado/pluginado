---
name: scratchpad
description: Create a temporary computation script in the repo's .scratchpad/ directory, run it, explain its output, and ask whether to delete it. Use when you need to make a throwaway calculation, data check, or quick experiment in code, or when the user mentions a scratch script or scratchpad.
argument-hint: "Sum the invoice totals by month."
---

Run throwaway computations as scripts in `.scratchpad/` instead of inline shell one-liners, so the code and its output stay reviewable.

## Workflow

1. Pick a name of 3–5 words, in kebab-case, that says what the script does, e.g. `sum-monthly-invoice-totals`.
2. Run `scripts/new-scratch-script.sh <name>.<ext>` (in this skill's directory), e.g. `scripts/new-scratch-script.sh sum-monthly-invoice-totals.py`. It creates `<repo root>/.scratchpad/` if needed, creates an empty file, and prints its path: `<repo root>/.scratchpad/<timestamp>-<name>.<ext>`. Outside a git repo, it uses the current directory as the root.
3. Check that `.scratchpad/` is gitignored with `git check-ignore -q .scratchpad/`. If it is not, suggest adding `.scratchpad/` to the repo's `.gitignore`, and edit the file only if the user says yes. The script's `WARN:` line on stderr reports the same thing, so use it as a reminder, not a second check.
4. Write the code to the printed path, then run it from the repo root.
5. Explain the output: what was computed, the key results, and anything surprising or failing. If it errors, fix the same file and run it again.
6. Ask the user whether the script should be removed. Delete it with `rm` only after they say yes.

## Notes

- Never stage `.scratchpad/` in a commit. Add files by name, as the git rules require.
- Use the scratch script for computations and checks, not for code that belongs in the project.
