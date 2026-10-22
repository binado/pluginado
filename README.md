# pluginado

Repository hosting some of my skills.

## Installation instructions

### claude code

From the tui:

```
/plugin install binado --marketplace binado/pluginado
```

From the shell:

```
claude plugin marketplace add binado/pluginado
claude plugin add pluginado@binado
```

(please don't mind the cacophony)

## Skills

| Skill | Description |
| --- | --- |
| [handoff-read](skills/handoff-read/SKILL.md) | Read the latest handoff document and resume the work it describes. |
| [handoff-write](skills/handoff-write/SKILL.md) | Compact the current conversation into a handoff document for another agent to pick up. |

## Acknowledgments

- The `handoff-read` and `handoff-write` skills were adapted from Matt Pocock's [`handoff` skill](https://github.com/mattpocock/skills/blob/main/skills/productivity/handoff/SKILL.md)
