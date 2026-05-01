---
description: Save a frequently-used shell command to memory/commands.md. Usage — /save-command <name> "<command>"
argument-hint: <name> "<command>"
allowed-tools: Read, Edit
---

Append to `memory/commands.md` under section matching name prefix (or `## misc` if no match):

```
### $1
`$2`
```

If `$1` already exists, ask whether to replace.

Emit `MEMORY_NOTES: saved command $1`.
