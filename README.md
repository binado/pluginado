# pluginado

Repository hosting some of my skills.

## Installation instructions

### claude code

From the tui:

```
/plugin install workflow --marketplace binado/pluginado
```

From the shell:

```
claude plugin marketplace add binado/pluginado
claude plugin add workflow@pluginado
```

(please don't mind the cacophony)

## Plugins

| Plugin | Contents |
| --- | --- |
| [workflow](plugins/workflow/README.md) | `handoff-read`, `handoff-write`, `to-issue`, `scratchpad` skills |
| [healthy-repo](plugins/healthy-repo/README.md) | `create-readme` skill |
| [julia](plugins/julia/README.md) | `benchmark` skill |

## Skills

| Skill | Description |
| --- | --- |
| [handoff-read](plugins/workflow/skills/handoff-read/SKILL.md) | Read the latest handoff document and resume the work it describes. |
| [handoff-write](plugins/workflow/skills/handoff-write/SKILL.md) | Compact the current conversation into a handoff document for another agent to pick up. |
| [to-issue](plugins/workflow/skills/to-issue/SKILL.md) | Write up the current problem as a GitHub issue labelled bug, feature or perf, and post it with the gh CLI. |
| [scratchpad](plugins/workflow/skills/scratchpad/SKILL.md) | Create a temporary computation script in the repo's `.scratchpad/` directory, run it, explain its output, and ask whether to delete it. |
| [create-readme](plugins/healthy-repo/skills/create-readme/SKILL.md) | Create a concise README.md for a repository or package from a standard template. |
| [benchmark](plugins/julia/skills/benchmark/SKILL.md) | Benchmark Julia code with BenchmarkTools by writing a script to `./.benchmark/<name>.jl`, running it, summarizing each trial's statistics in a table, and saving them to a CSV. |

## Acknowledgments

- The `handoff-read` and `handoff-write` skills were adapted from Matt Pocock's [`handoff` skill](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md)
