# Memory index — smartmem (dogfood)

This repo IS smartmem; we use the same schema we ship.

## Always-loaded
- [active_context](active_context.md) — current focus
- [tasks](tasks.md) — open / done

## What & why
- [project_brief](project_brief.md) — what smartmem is and why it exists
- [product_context](product_context.md) — who installs smartmem and what they get
- [design_goals](design_goals.md) — non-destructive, race-free, cross-platform
- [system_requirements](system_requirements.md) — functional + non-functional reqs
- [glossary](glossary.md) — terms (overlay, finalizer, hot tier, etc.)

## How
- [architecture](architecture.md) — plugin family, wizard flow, single-writer rule
- [code_structure](code_structure.md) — repo layout, where each piece lives
- [system_patterns](system_patterns.md) — plugin layout, merge strategies, naming
- [tech_context](tech_context.md) — how to test the wizard
- [db_structure](db_structure.md) — N/A (no DB)
- [ui_structure](ui_structure.md) — N/A (no UI)
- [api_surface](api_surface.md) — N/A (no API)

## History
- [decisions](decisions.md) — local mirror of `docs/DECISIONS.md`
- [progress](progress.md) — milestones
- [commands](commands.md) — install/test commands
