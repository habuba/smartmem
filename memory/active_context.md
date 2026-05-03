# Active context

## Now
- v0.4.0 in flight. Wizard redesigned to ask file-checklist + update-mode rather than seeding content. Memory files now start as `# Title` + purpose stubs and grow as the user works.
- New `/memory-files add|remove|rename|list` command shipped.
- 10 sample projects added under `samples/` showing what filled memory looks like across disciplines.
- Dogfood memory files stripped back to stubs; samples carry the realistic examples instead.

## Open threads
- bash hook scripts only ship for `session-start` and `block-secrets`. Need bash equivalents for `post-compact`, `stop-finalize`, `subagent-contract-audit`.
- `hooks.json` references `pwsh` directly. Need an auto-detect or per-platform split.
- Manual updateMode flow needs end-to-end smoke test (approval prompt, partial-apply, scratch retention).
- `mirror` autoMemory mode heuristic still rough — team-shareable vs per-machine signal not crisp.

## Recently decided
- 2026-05-03: Wizard no longer pre-fills memory content. New flow: pick type → file checklist → update mode (auto/manual). Files are stubs until the user (or finalizer) writes them.
- 2026-05-03: New `/memory-files` command for adding, removing, renaming memory files post-init. Three sources of truth (MEMORY.md / config.json / files-on-disk) must stay in sync.
- 2026-05-03: Other agents (planner/reviewer/explorer) now append `MEMORY_NOTES:` to `.claude/smartmem/v1/scratch.md` instead of inline. task-tracker remains the one exception (writes `memory/tasks.md` directly).
- 2026-05-01: Coexist with Claude Code auto-memory. `autoMemory: keep | off | mirror`.
- 2026-05-01: Default memory language is English even when chatting in another language (30-50% token saving).
