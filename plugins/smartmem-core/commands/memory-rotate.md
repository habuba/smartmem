---
description: Archive stale entries from active_context.md and tasks.md (Done >30 days) into memory/archive/YYYY-MM/.
allowed-tools: Read, Write, Edit, Bash, Glob
---

1. Read `memory/tasks.md`. Move every entry from `## Done` whose date is >30 days old into `memory/archive/$(date +%Y-%m)/tasks-done.md`. Append, don't overwrite.
2. Read `.claude/smartmem/v1/active_context.md`. Move any section whose last-modified line is >30 days old into the same archive folder, file `active-archive.md`.
3. Trim `memory/MEMORY.md` index of entries pointing to non-existent files.
4. Emit `MEMORY_NOTES: rotated N entries to memory/archive/<month>/` so memory-finalizer logs it to `docs/CHANGELOG.md`.

Show counts. Never delete — only move.
