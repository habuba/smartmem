# Design goals — smartmem

In priority order. When trade-offs arise, higher wins.

1. **Non-destructive on existing projects.** Re-running `/smartmem-init` on a real project must not corrupt or overwrite anything the user authored. The single most important property.
2. **Race-free memory writes.** Multiple subagents must never collide. Achieved by the single-writer (`memory-finalizer`) invariant.
3. **Coexistence over replacement.** Don't fight Claude Code's auto-memory, cc10x, caveman, or claude-mem. Namespace under `.claude/smartmem/`, avoid generic command verbs, document overlap explicitly.
4. **Cross-platform parity.** Every primary script in PowerShell has a bash equivalent. Windows is a first-class target, not an afterthought.
5. **Schema-enforced memory.** A fixed set of 18 memory files with single-purpose semantics beats one giant blob. Predictable slots → predictable reads → cheaper context.
6. **Token efficiency by default.** English memory recommended even when the user chats in another language (30-50% token savings). `concise` skill ships built-in. `caveman` integration optional.
7. **Plugin-shape distribution.** Use the Claude Code plugin marketplace so updates ride on `/plugin update`. Provide a clone+symlink fallback for restricted environments.

## Explicit non-priorities
- **Multi-model API routing.** Out of scope; that's claude-code-router's domain. We pick model TIERS at init for our own agents only.
- **Workflow constraint engine.** Out of scope; that's babysitter's domain. Our "loops" are recurring agents, not constrained processes.
- **Vendoring third-party plugins.** Caveman, cline-memory-bank — we cite, integrate, and offer install commands; we don't bundle.
- **Backwards compatibility for unreleased versions.** Until 1.0, breaking schema changes are allowed at minor bumps with migration notes in CHANGELOG.

## Quality bars
- **Wizard runtime**: <2s to render 30 files into an empty target dir.
- **Idempotency**: re-running the wizard on an already-initialized project produces a clean diff (only `merged-runtime` and `json-merged` lines, no `wrote:` for existing files).
- **Cohabitation**: installing alongside cc10x must produce zero namespace, command, or memory-file collisions.
- **Compaction safety**: PreCompact must run the finalizer; PostCompact must re-inject the index. Verified manually.
