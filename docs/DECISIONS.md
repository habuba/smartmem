# Decisions log (ADR-lite)

## 2026-05-01 — Ship as plugin marketplace, not init script
**Context:** NikiforovAll's claude-code-rules and cc10x both distribute via `marketplace.json`. Plugin updates ride on `/plugin update` for free.
**Decision:** Primary distribution is `.claude-plugin/marketplace.json` with 6 plugins. Secondary fallback is `scripts/install.{ps1,sh}` for offline/restricted envs.
**Consequences:** Non-destructive update path is mostly free. Have to maintain plugin manifests. Users on locked-down machines without marketplace access can still install.

## 2026-05-01 — Single-writer memory model
**Context:** cc10x demonstrated write-race issues when multiple subagents touch memory. Race conditions silently corrupt the index.
**Decision:** Only `memory-finalizer` writes to `memory/**`, `.claude/smartmem/**`, `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`. Other agents emit `MEMORY_NOTES:` blocks consumed at Stop / PreCompact.
**Consequences:** Race-free, compaction-survivable. Slight latency at end of turn for finalizer pass. SubagentStop contract auditor warns (non-blocking) when an agent forgets to emit a note.

## 2026-05-01 — hookMode enum, not per-hook checkboxes
**Context:** The init wizard had 6 hook checkboxes; users defaulted to "all" anyway. Six questions for one decision.
**Decision:** Single `hookMode: off | guard | full` setting. `guard` = block-secrets + PreCompact only; `full` = everything.
**Consequences:** Simpler init UX. Edge cases (someone wants finalizer but not block-secrets) require manual edit of `settings.json` — acceptable.
