---
name: handoff-read
description: Read the latest handoff document from the repo's .handoff/ directory and resume the work it describes. Use when the user wants to pick up a handoff, continue from a previous session, or read the last handoff written by handoff-write.
argument-hint: "Pick up where the last session left off."
disable-model-invocation: true
---

Read the most recent handoff written by `handoff-write` and continue the work it describes.

## Workflow

1. Run `scripts/latest-handoff.sh` (in this skill's directory). It prints the newest `<repo root>/.handoff/*.md` by filename timestamp. If it exits 1, tell the user there are no handoffs and stop.
2. Read the printed file in full.
3. Before relying on any path, PR, or issue it references, check that it still exists.
4. If the user passed arguments, treat them as the focus of this session. The handoff's "Suggested skills" section lists skills to invoke.
5. Summarise the handoff and your next step to the user, then continue. Ask only if the handoff is unclear or contradicts the current repo state.
