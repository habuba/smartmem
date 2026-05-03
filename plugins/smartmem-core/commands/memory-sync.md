---
description: Run the memory-finalizer to distill recent conversation + scratch into memory files. In manual updateMode this is the primary entry point; in auto mode it forces an immediate flush. Usage — /memory-sync [scope]
argument-hint: [tasks|active|patterns|all]
allowed-tools: Read, Write, Edit, Glob
---

Spawn the `memory-finalizer` agent now with scope = `$1` (default: `all`).

Steps:
1. Read `.claude/smartmem/v1/config.json` to learn `updateMode`.
2. If `updateMode: "manual"`, instruct the finalizer to propose diffs and ask for approval per file before writing.
3. If `updateMode: "auto"`, instruct the finalizer to apply directly (this is the same path the Stop/PreCompact hooks take — `/memory-sync` here just forces an early flush).
4. Pass the scope filter through: `tasks` → only tasks.md; `active` → only active_context.md; `patterns` → only system_patterns.md + tech_context.md; `all` → no filter.
5. After the agent returns, print its report verbatim.
