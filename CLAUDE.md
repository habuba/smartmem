# smartmem

Source repo for the **smartmem** plugin family — hierarchical memory + harness initializer for Claude Code. This repo dogfoods itself: it uses the same memory schema it ships.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@memory/tasks.md
@docs/BIG_PICTURE.md

## Working rules
- This repo IS smartmem. When extending it, the changes you make ship as the next plugin version. Update `docs/CHANGELOG.md` and bump versions when relevant.
- Memory is managed by the `memory-finalizer` agent. Other agents emit `MEMORY_NOTES:` blocks; only the finalizer writes to `memory/*.md`, `.claude/smartmem/**`, or `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`.
- Keep this file <80 lines. Detail goes into pointer files imported above.
- Namespace all runtime state under `.claude/smartmem/v1/`.
- Don't claim generic command names (BUILD/PLAN/REVIEW/DEBUG); coexist with cc10x.
- Before non-trivial changes, read the relevant pointer from `memory/MEMORY.md`:
  - templates → `memory/code_structure.md` (look at `plugins/smartmem-*/templates/`)
  - wizard logic → `plugins/smartmem-core/scripts/wizard.{ps1,sh}` and `memory/architecture.md`
  - new memory file → update both `_base/manifest.json` and `_base/memory/MEMORY.md`
  - new project type → use the `/smartmem-new-template` skill rather than copying by hand
- Workflow for features: `/prd <slug>` → `/tasks <slug>` → `/process`.
