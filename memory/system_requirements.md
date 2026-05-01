# System requirements — smartmem

## Functional
- **FR-1**: `/smartmem-init` bootstraps a project from empty (or partial) state to the full smartmem schema in one wizard pass.
- **FR-2**: The wizard never overwrites user-authored content in `memory/*.md` or `docs/*.md` (`create-only` semantics).
- **FR-3**: `/memory-sync` consolidates `MEMORY_NOTES:` blocks from the conversation into the right memory files, applied as minimal diffs.
- **FR-4**: PreCompact + PostCompact hooks ensure no memory loss across context compaction.
- **FR-5**: `/smartmem-lang-init` installs language packs (style skills + tech_context additions + MCP suggestions) idempotently for python/ts/go/rust/java/csharp.
- **FR-6**: `/smartmem-new-template` scaffolds a new overlay plugin from any existing template and registers it in the marketplace.
- **FR-7**: `/project-update` re-runs init non-destructively after a `claude plugin update smartmem-core`.
- **FR-8**: Memory language toggle: English (default) and Hebrew at v0.2+.
- **FR-9**: Auto-memory toggle: keep / off / mirror at v0.3+.

## Non-functional
- **NFR-perf**: Wizard runtime <2s on a clean dir with one overlay.
- **NFR-scale**: Memory schema bounded — `MEMORY.md` ≤200 lines, total memory dir ≤25 KB before compaction concerns.
- **NFR-portability**: PowerShell 7+ AND bash both fully supported. No platform-specific paths in templates.
- **NFR-coexistence**: Zero command, file, or settings collision when installed alongside cc10x or caveman.
- **NFR-security**: `block-secrets` PreToolUse hook refuses writes containing AWS keys, GitHub tokens, JWTs, private key headers.
- **NFR-determinism**: Re-running the wizard with the same config must produce identical results (idempotent).

## Assumptions
- Claude Code v2.1.59+ (auto-memory feature available).
- Target machine has either PowerShell 7+ or bash 4+ on PATH.
- For symlink install on Windows: Developer Mode enabled OR `-Copy` fallback used.
- For language packs with MCP: Node available for `npx` (the suggested MCP wrappers).

## Constraints
- No build step in the repo (markdown + JSON + scripts only). Keeps the marketplace install fast.
- No external runtime dependencies beyond what Claude Code itself ships.
- Every command, skill, and agent must work without internet access (other than the optional caveman plugin install).
