<!-- smartmem:start -->
# smartmem

Hierarchical smart memory + harness initializer for Claude Code projects.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@memory/tasks.md

## Working rules
- Memory is managed by the `memory-finalizer` agent. Other agents emit `MEMORY_NOTES:` blocks; only the finalizer writes to `memory/*.md`, `.claude/smartmem/**`, or `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`.
- Before non-trivial changes, read the relevant pointers from `memory/MEMORY.md`:
  - touching architecture â†’ `architecture.md`, `code_structure.md`
  - touching DB â†’ `db_structure.md`
  - touching UI â†’ `ui_structure.md`
  - touching API surface â†’ `api_surface.md`
  - any code â†’ `system_patterns.md`, `tech_context.md`
- Workflow for features: `/prd <slug>` â†’ `/tasks <slug>` â†’ `/process` (uses `planner` for design, `reviewer` before commit).
- Hot runtime state lives under `.claude/smartmem/v1/` (gitignored).

<!-- smartmem:end -->

# Project-memory-init

Source repo for the **smartmem** plugin family â€” hierarchical memory + harness initializer for Claude Code.

## What lives here
- `.claude-plugin/marketplace.json` â€” declares all 6 plugins
- `plugins/smartmem-core/` â€” base memory schema, finalizer agent, hooks, wizard, commands
- `plugins/smartmem-{software,fullstack,business,data,cli}/` â€” project-type overlays
- `scripts/install.{ps1,sh}` â€” non-marketplace install fallback
- `templates/` (per-plugin) â€” file shapes consumed by the wizard
- `docs/BIG_PICTURE.md` â€” durable design intent
- `memory/` â€” this repo's own pointer/recall files (we dogfood)

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@docs/BIG_PICTURE.md

## Working rules
- Never write to user `memory/*.md` from code; only the `memory-finalizer` agent writes.
- Keep this file <80 lines. Detail goes into pointer files imported above.
- Namespace all runtime state under `.claude/smartmem/v1/`.
- Don't claim generic command names (BUILD/PLAN/REVIEW/DEBUG); we coexist with cc10x.

