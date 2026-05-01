---
description: Manually run the memory-finalizer to distill recent conversation into memory files. Usage — /memory-sync [scope]
argument-hint: [tasks|active|patterns|all]
allowed-tools: Read, Write, Edit, Glob
---

Spawn the `memory-finalizer` agent now with scope = `$1` (default: `all`).

Instruct it to:
- Scan the recent conversation for `MEMORY_NOTES:` blocks AND for distillable signal (decisions made, patterns observed, tasks completed) even without explicit notes.
- Apply minimal diffs to the right memory files per its routing rules.
- Show me the diff before writing if scope contains `active` or `patterns`.

After it returns, print its report verbatim.
