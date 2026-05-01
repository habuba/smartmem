# Product context — smartmem

## Users
- **Primary**: Solo developers and small teams using Claude Code who keep losing context between sessions because their `CLAUDE.md` is either missing or has bloated into a 500-line stale dump.
- **Secondary**: Plugin authors who want a reference example of how to structure a Claude Code marketplace plugin family with hooks, skills, agents, and slash commands.
- **Tertiary**: Multilingual developers who chat in non-English but want their project memory in English for token efficiency.

## Problems we solve
- **No structure to memory.** Most projects have one giant CLAUDE.md (or none). smartmem ships a fixed 18-file schema with single-purpose roles.
- **Memory writes race when subagents proliferate.** Single-writer `memory-finalizer` agent eliminates the race.
- **Context compaction silently drops work.** PreCompact/PostCompact hooks distill into memory before, re-inject after.
- **No clean way to bootstrap a new project.** `/smartmem-init` does it in one pass, with overlays per project type.
- **Per-language conventions are repetitive boilerplate.** Language packs install style + testing skills + LSP/MCP suggestions in one command.
- **Re-running init destroys customizations.** Five merge strategies (create-only, prepend-once, append-once, json-merge, overwrite-runtime) ensure idempotency.

## Success looks like
- A user runs `/smartmem-init` once on a new project and never edits a memory file by hand again — the finalizer keeps everything current.
- After 3 months of use, `git log memory/` shows steady, meaningful updates (not stale or churning).
- Re-running the wizard after a plugin update produces zero unintended diffs.
- Installing alongside cc10x or caveman: no collisions, no surprises.
