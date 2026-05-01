# System patterns — smartmem repo

## Plugin layout
- Each plugin is self-contained under `plugins/smartmem-<name>/`.
- Manifests at `.claude-plugin/plugin.json`. Marketplace at root `.claude-plugin/marketplace.json`.
- Templates live in `plugins/<name>/templates/` with a `manifest.json` describing each file's merge strategy.

## Merge strategies (templates/manifest.json)
- `create-only` — never overwrite. Default for memory/* and docs/*.
- `prepend-once` — wraps content in marker block; skip if marker present (CLAUDE.md).
- `append-once` — appends if marker absent (.gitignore).
- `json-merge` — union arrays, additive object props (settings.json).
- `overwrite-runtime` — for `.claude/smartmem/v1/config.json`; merges new fields on `-Update`.

## Memory write rule
Only `memory-finalizer` writes to memory/, .claude/smartmem/**, or docs/{DECISIONS,CHANGELOG,BACKLOG}.md. Other agents emit `MEMORY_NOTES:` blocks. Enforced by SubagentStop contract auditor.

## Naming
- Plugins: `smartmem-<name>`.
- Commands: avoid generic verbs (BUILD/PLAN/REVIEW). Our distinctive: `prd`, `tasks`, `process`, `memory-sync`, `memory-rotate`, `caveman`, `smartmem-init`, `smartmem-new-template`.
- Runtime state: `.claude/smartmem/v1/` (versioned).
