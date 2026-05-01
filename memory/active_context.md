# Active context

## Now
- v0.3.0 shipped. Full plugin family + 18-file memory schema + 6 language packs + Hebrew memory + auto-memory coexistence is live at https://github.com/habuba/smartmem.
- Repo dogfoods itself: real content in all 18 memory files (not template stubs).
- Awaiting first external user end-to-end validation.

## Open threads
- bash hook scripts only ship for `session-start` and `block-secrets`; the other 4 (`post-compact`, `stop-finalize`, `subagent-contract-audit`) are PowerShell-only. Need bash equivalents for full Linux/macOS parity.
- `hooks.json` references `pwsh` directly. Need an auto-detect (or split `hooks.json` per platform) so Linux users don't have to hand-edit.
- `/smartmem-new-template` writes to the smartmem source repo, not user repos. Need clearer docs explaining this is an authoring tool.
- `mirror` mode for auto-memory is experimental — heuristic for "team-shareable vs per-machine" needs tightening.

## Recently decided
- 2026-05-01: Coexist with Claude Code auto-memory, don't replace it. v0.3.0 wizard option `autoMemory: keep | off | mirror`.
- 2026-05-01: Default memory language is English even when chatting in another language (30-50% token saving). Hebrew templates ship in v0.2.0+ for users who explicitly want them.
- 2026-05-01: 18-file memory schema (granular split). Each file has a single purpose and a single writer.
- 2026-05-01: Single-writer invariant — only `memory-finalizer` writes memory. SubagentStop hook audits compliance.
- 2026-05-01: Distribution = plugin marketplace primary + clone+symlink fallback for restricted envs.
