---
description: Expand a PRD into tasks. Usage — /tasks <prd-slug>
argument-hint: <prd-slug>
allowed-tools: Read, Edit, Glob
---

Read `docs/prds/$1.md`. Expand into discrete tasks in `memory/tasks.md` under `## Open`.

Rules:
- Each task is an action: starts with a verb.
- Atomic: one PR worth of work.
- Stable IDs: continue numbering from existing T-NNN.
- Reference the PRD: `(prd:$1)` suffix on each task.
- 3-12 tasks total. If more, the PRD is too big — push back.

Show the list, ask the user to confirm before writing. Then route via `task-tracker` agent.

Emit `MEMORY_NOTES: tasks generated from prd:$1 — N tasks`.
