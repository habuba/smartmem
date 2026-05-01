# Glossary — smartmem

| Term | Definition |
|---|---|
| **smartmem** | This plugin family. Provides hierarchical memory + harness for Claude Code projects. |
| **Plugin family** | The set of 6 plugins published under one `marketplace.json`: `smartmem-core` + 5 overlays. |
| **Overlay** | A project-type plugin that adds specialized memory files on top of the base. e.g. `smartmem-fullstack` adds `frontend/CLAUDE.md`, `backend/CLAUDE.md`, `api_context.md`. |
| **Wizard** | The interactive setup flow run by `/smartmem-init`. Asks 10 questions, then renders templates into the target project. |
| **Template** | A source file in `plugins/smartmem-*/templates/` rendered into a target project at init. Contains `{{vars}}` substituted by the wizard. |
| **Manifest** | `templates/manifest.json` — declares which templates go where with which merge strategy. |
| **Merge strategy** | One of: `create-only`, `prepend-once`, `append-once`, `json-merge`, `overwrite-runtime`. Controls how the wizard handles existing files. |
| **memory-finalizer** | The single subagent permitted to write to `memory/**`, `.claude/smartmem/**`, or `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`. |
| **MEMORY_NOTES** | A markdown block format other agents emit in their replies. The finalizer consumes them and writes to the right memory files. |
| **Single-writer invariant** | Design rule: only the finalizer writes memory. All other agents emit notes. Eliminates write races. |
| **Hot tier** | Runtime state under `.claude/smartmem/v1/`. Gitignored. Includes `config.json`, `active_context.md`, `event-log.jsonl`. |
| **Hot tier vs cold tier** | "Hot" = frequently rewritten, gitignored. "Cold" = `memory/*.md` and `docs/*.md`, committed, durable. |
| **Auto-memory** | Claude Code's built-in machine-local memory at `~/.claude/projects/<git-root>/memory/MEMORY.md`. Distinct from smartmem. See `docs/guide/09-auto-memory.md`. |
| **Hook mode** | Setting in `config.json`: `off` / `guard` / `full`. Controls which hooks fire. |
| **Caveman** | The `JuliusBrussee/caveman` plugin — concise output style for token reduction. Optional integration. |
| **Language pack** | Per-language bundle of style skills + tech_context snippet + MCP-LSP suggestion. Installed via `/smartmem-lang-init`. |
| **MCP** | Model Context Protocol. Used here for LSP integration via `language-server-mcp` wrappers. |
| **Symlink fallback** | The `scripts/install.{ps1,sh}` installer for environments without marketplace access. |
