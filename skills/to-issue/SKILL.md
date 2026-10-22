---
name: to-issue
description: Write up the current problem as a GitHub issue, labelled bug, feature or perf, and post it with the gh CLI. Use when the user wants to file, open, create or post an issue, report a bug, request a feature, or log a performance problem on GitHub.
argument-hint: "File a bug for the crash on empty input."
disable-model-invocation: true
---

Turn the problem under discussion into a GitHub issue and post it with `gh issue create`.

## Workflow

1. **Identify the problem.** Use the current conversation. If it does not describe a concrete problem, ask the user what the issue should cover. If the user passed arguments, treat them as the focus.
2. **Pick one label:**
   - `bug`: something is broken or behaves incorrectly.
   - `feature`: a new capability or behaviour that does not exist yet.
   - `perf`: slowness, high memory or CPU use, or an optimisation.
   If the problem fits more than one, choose the closest to the user's words and say which you picked.
3. **Draft the title.** Keep it under 70 characters, state the problem or request directly, and leave the label out of it.
4. **Draft the body** from [ISSUE_TEMPLATE.md](assets/ISSUE_TEMPLATE.md) in this skill's directory. Keep the sections that apply and delete the rest. Include concrete evidence: error text, steps, timings, versions, file paths. Redact secrets, tokens and personal data.
5. **Check for duplicates and labels.**
   - Run `gh issue list --search "<keywords>"`. If an open issue already covers the problem, tell the user and stop instead of posting.
   - Run `gh label list --json name --jq '.[].name'`. If the chosen label is missing, create it with `gh label create <label>` and tell the user.
6. **Post the issue.** Write the body to a temporary file (`mktemp`), then run:

   ```sh
   gh issue create --title "<title>" --body-file <body-file> --label "<label>"
   ```

   Add `--repo owner/name` when the current directory is not the target repository.
7. **Report back.** Give the issue URL that `gh` prints and the label used. If `gh` fails, show the error and do not retry blindly.

## Notes

- `gh` needs a token. Under the user's git rules, run `gh` through the fnox MCP `exec` tool rather than setting `GH_TOKEN` yourself.
- Post each issue once. Do not file a second issue for a problem that already has one.
