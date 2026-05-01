# Project-memory-init

Source repo for the **smartmem** plugin family — hierarchical memory + harness initializer for Claude Code.

## What lives here
- `.claude-plugin/marketplace.json` — declares all 6 plugins
- `plugins/smartmem-core/` — base memory schema, finalizer agent, hooks, wizard, commands
- `plugins/smartmem-{software,fullstack,business,data,cli}/` — project-type overlays
- `scripts/install.{ps1,sh}` — non-marketplace install fallback
- `templates/` (per-plugin) — file shapes consumed by the wizard
- `docs/BIG_PICTURE.md` — durable design intent
- `memory/` — this repo's own pointer/recall files (we dogfood)

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@docs/BIG_PICTURE.md

## Working rules
- Never write to user `memory/*.md` from code; only the `memory-finalizer` agent writes.
- Keep this file <80 lines. Detail goes into pointer files imported above.
- Namespace all runtime state under `.claude/smartmem/v1/`.
- Don't claim generic command names (BUILD/PLAN/REVIEW/DEBUG); we coexist with cc10x.
