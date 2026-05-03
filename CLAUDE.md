# smartmem

Source repo for the **smartmem** plugin family — hierarchical memory + harness initializer for Claude Code. This repo dogfoods itself.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@memory/tasks.md

## Working rules
- Be concise. No preamble, no trailing summaries, no marketing tone, no emojis.
- Hierarchical memory: read `memory/MEMORY.md` first, then `@`-import only files relevant to the task.
- Memory updates: automatic — `memory-finalizer` runs on Stop and PreCompact, applying scratch notes without prompting.
- Only `memory-finalizer` writes to `memory/**`, `.claude/smartmem/**`, or `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`. Other agents append `MEMORY_NOTES:` blocks to `.claude/smartmem/v1/scratch.md`.
- Add or remove memory files with `/memory-files add|remove|rename|list`.
- Non-trivial features: `/prd <slug>` → `/tasks <slug>` → `/process`.
- Hot runtime state under `.claude/smartmem/v1/` (gitignored).
- This repo IS smartmem — descriptive memory files are intentionally near-empty stubs. Filled examples live in `samples/` (10 disciplines).
- Changes here ship as the next plugin version. Update `docs/CHANGELOG.md` and bump `plugins/smartmem-core/.claude-plugin/plugin.json` when relevant.
- Don't claim generic command names (BUILD/PLAN/REVIEW); coexist with cc10x.
