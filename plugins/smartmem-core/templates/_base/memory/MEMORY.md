# Memory index

One line per memory file. Keep <200 lines total. Lazy-loaded by Claude Code via `@imports` from `CLAUDE.md`.

## Always-loaded (core tier)
- [active_context](active_context.md) — current focus (managed by finalizer)
- [tasks](tasks.md) — open / blocked / done

## What & why (recall tier)
- [project_brief](project_brief.md) — one-paragraph description
- [product_context](product_context.md) — users, problems, success criteria
- [design_goals](design_goals.md) — priorities and trade-off rules
- [system_requirements](system_requirements.md) — functional + non-functional reqs
- [glossary](glossary.md) — project-specific terms

## How (recall tier)
- [architecture](architecture.md) — high-level system architecture
- [code_structure](code_structure.md) — where code lives, module boundaries
- [system_patterns](system_patterns.md) — conventions to follow
- [tech_context](tech_context.md) — stack, build, test, run commands
- [db_structure](db_structure.md) — schema, migrations (skip if no DB)
- [ui_structure](ui_structure.md) — component tree, design system (skip if no UI)
- [api_surface](api_surface.md) — endpoints, contracts (skip if no API)

## History (recall tier)
- [decisions](decisions.md) — ADR mirror; canonical at `docs/DECISIONS.md`
- [progress](progress.md) — append-only milestones
- [commands](commands.md) — frequently-used shell commands
