# marketwatch-etl

Vendor pricing ingestion: S3 CSV -> normalize -> Snowflake -> dbt models for downstream analytics.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Be concise. No preamble, no recap. Match the tone of existing memory notes.
- Use hierarchical memory: load `memory/MEMORY.md`, then only the files relevant to the task. Don't dump the whole tree.
- Auto-update mode: emit `MEMORY_NOTES:` blocks when you learn something durable (a new constraint, a decision, a finished task). Don't write to `memory/**` directly.
- **Only `memory-finalizer` writes to `memory/**`.** Every other agent (explorer, planner, reviewer, task-tracker) emits notes; the finalizer reconciles them at Stop / PreCompact.
- Before touching DAGs, read `memory/architecture.md` and `memory/system_patterns.md`. Before touching SQL, read `memory/db_structure.md`.
- New ADR? Append to `memory/decisions.md` with date + one-line rationale. Don't rewrite history.
- Run `ruff check . && pytest -q` before declaring a task done. See `memory/commands.md`.
