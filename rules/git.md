# Git workflow

- Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages: `<type>[optional scope]: <description>` (e.g. `feat(auth): add token refresh`, `fix: handle empty response body`). Common types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`.
- When a task is finished, commit the changes and push:
  - If already on a non-`main` branch, commit and push there.
  - If on `main`, create a new branch first, then commit and push to it.
  - Never commit or push directly to `main`.
- Only stage files that were created or modified as part of the current task. Do not run broad staging (`git add -A` / `git add .`) that could sweep in unrelated untracked files — add files by name.

