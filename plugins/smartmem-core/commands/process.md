---
description: Pick the next open task and work on it. Usage — /process [task-id]
argument-hint: [T-NNN]
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

If `$1` is given, work on task `$1`. Otherwise read `memory/tasks.md` and pick the first unblocked Open task.

Workflow:
1. Print the task line.
2. If non-trivial, spawn `planner` agent to write `docs/plans/<slug>.md`.
3. Implement. Use `explorer` for any code search.
4. After implementing, spawn `reviewer` to self-review.
5. Mark the task done via `task-tracker`.
6. Emit `MEMORY_NOTES:` with the outcome.

If the task description is ambiguous, ask before starting.
