# Changelog

## 2026-05-03 — v0.4.0
- Wizard redesigned: picks **memory file checklist + update mode** instead of seeding content. New memory files are empty stubs (`# Title` + purpose comment) and grow as the user works.
- New `/memory-files add|remove|rename|list` command.
- New `updateMode: auto | manual` option. `auto` (default) = finalizer applies on Stop/PreCompact silently. `manual` = finalizer proposes diff, user approves before writing.
- Other agents (planner, reviewer, explorer) now append `MEMORY_NOTES:` to `.claude/smartmem/v1/scratch.md` instead of inline. task-tracker keeps writing `memory/tasks.md` directly.
- New `samples/` directory with 10 filled-memory examples across disciplines (python-data-pipeline, rust-cli-tool, nextjs-saas, go-microservice, ml-training-pipeline, react-native-mobile, embedded-firmware, unity-game, compliance-workflow, docs-site).
- CLAUDE.md template now bakes in concise + hierarchical-memory + update-mode rules.
- Manifest: removed per-memory-file entries; wizard generates them from the chosen file set.

## 2026-05-01 — v0.3.0
- Project initialized via smartmem-init. Plugin family, 18-file schema, 6 language packs, Hebrew memory, auto-memory coexistence.
