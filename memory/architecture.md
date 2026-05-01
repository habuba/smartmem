# Architecture — smartmem

## High-level
smartmem is a Claude Code **plugin family** distributed via a `marketplace.json` (or via a clone+symlink fallback). Six plugins: `smartmem-core` plus five overlays (`software`, `fullstack`, `business`, `data`, `cli`). The core ships agents, hooks, skills, slash commands, language packs, and templates; overlays add project-type-specific memory files.

When a user runs `/smartmem-init` in a target project, the wizard renders templates from `plugins/smartmem-core/templates/_base{,_he}/` (overlay first, base second) into the target's `memory/`, `docs/`, and `.claude/smartmem/v1/` directories.

## Components
| Component | Responsibility | Implementation |
|---|---|---|
| Marketplace | Lists 6 plugins | `.claude-plugin/marketplace.json` |
| smartmem-core | Engine: agents, hooks, skills, commands, wizard | `plugins/smartmem-core/` |
| Overlays (×5) | Project-type-specific memory files | `plugins/smartmem-{software,fullstack,business,data,cli}/` |
| Wizard | Renders templates with merge strategies | `plugins/smartmem-core/scripts/wizard.{ps1,sh}` |
| memory-finalizer agent | Sole writer to memory; consumes `MEMORY_NOTES:` blocks | `plugins/smartmem-core/agents/memory-finalizer.md` |
| Hooks (×6) | SessionStart, PreCompact, PostCompact, Stop, SubagentStop, PreToolUse | `plugins/smartmem-core/hooks/` |
| Language packs (×6) | python/ts/go/rust/java/csharp style + LSP suggestions | `plugins/smartmem-core/language-packs/` |
| Install fallback | Symlinks plugins into `~/.claude/plugins/` | `scripts/install.{ps1,sh}` |

## Boundaries
- **Inside the system**: `<project>/memory/`, `<project>/docs/{BIG_PICTURE,DECISIONS,CHANGELOG,BACKLOG,prds/,plans/}`, `<project>/.claude/smartmem/v1/`, the merged blocks of `<project>/CLAUDE.md`, `<project>/.gitignore`, `<project>/.claude/settings.json`.
- **Outside**: never touched. smartmem does not write to source code, lockfiles, build outputs, or anything outside the directories above.
- **Coexists with**: Claude Code's auto-memory at `~/.claude/projects/<git-root>/memory/` (separate machine-local layer), cc10x's `.claude/cc10x/`, claude-mem's session capture.

## Cross-cutting
- **Auth/permissions**: scoped via `.claude/settings.json` `permissions.allow` entries that confine writes to `memory/**`, `docs/**`, `.claude/smartmem/**`.
- **Logging**: every finalizer write appends a JSONL line to `.claude/smartmem/v1/event-log.jsonl`.
- **Config / secrets**: durable answers in `.claude/smartmem/v1/config.json`; no secret material handled.
- **Error propagation**: hooks exit 0 with JSON for soft messages, exit 2 to block tool calls (only `block-secrets` does this).

## Wizard flow

```
/smartmem-init  (skill smartmem-init)
   ├─ AskUserQuestion × 10
   │   (type, name, description, modelTier, hookMode, caveman,
   │    memoryLanguage, autoMemory, lang-pack-now?, mcp servers)
   │
   ├─ wizard.{ps1|sh} -ConfigJson '<answers>' -Path <proj> -Overlay <type>
   │   ├─ Apply overlay manifest first       ← specialized files win
   │   ├─ Apply base manifest (en or he)     ← fills the rest as create-only
   │   ├─ Render {{name}} {{description}} {{MODEL_*}} {{date}} ...
   │   ├─ json-merge .claude/settings.json   (autoMemoryEnabled written here)
   │   ├─ overwrite-runtime .claude/smartmem/v1/config.json
   │   └─ append-once .gitignore
   │
   ├─ if user picked "install language pack now": chain into /smartmem-lang-init
   │
   └─ Briefing → /status, /prd, /tasks, /process
```

## Single-writer invariant
**Only `memory-finalizer` writes to project memory.** Every other agent emits `MEMORY_NOTES:` blocks in their reply. The finalizer runs on `Stop` (when `hookMode: full`), on `PreCompact`, and manually via `/memory-sync`. This is what makes hierarchical memory race-free across subagents and survivable across context compaction.

A `SubagentStop` hook audits each subagent's transcript and warns (non-blocking) if it forgot to emit `MEMORY_NOTES:`.
