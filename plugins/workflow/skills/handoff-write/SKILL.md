---
name: handoff-write
description: Compact the current conversation into a handoff document for another agent to pick up. Use when the user wants to hand off, continue in another session, or write a handoff document.
argument-hint: "Let's handoff to another session."
disable-model-invocation: true
---

Write a handoff .md document summarising the current conversation so a fresh agent can continue the work.

## Workflow

1. Run `scripts/new-handoff.sh <short topic>` (in this skill's directory), passing 3–6 words that name the conversation's main topic, e.g. `scripts/new-handoff.sh auth token refresh`. The script lowercases and sanitises them. It creates `<repo root>/.handoff/` if needed and prints the path to write: `<repo root>/.handoff/<timestamp>-<topic-slug>.md`. Outside a git repo, it uses the current directory as the root.
2. If the script prints a `WARN:` line on stderr, tell the user that `.handoff/` is not gitignored and offer to add `.handoff/` to the repo's `.gitignore`. Edit `.gitignore` only if they say yes.
3. Write the handoff to the printed path.
4. Redact sensitive information such as API keys, passwords, and personally identifiable information.
5. If the user passed arguments, treat them as the focus of the next session and tailor the doc to it.
6. Reply with the handoff path.
