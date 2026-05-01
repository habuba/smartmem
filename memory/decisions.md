# Decisions (local mirror)

Canonical log: `docs/DECISIONS.md`. This file is auto-synced by `memory-finalizer` for in-context recall.

## 2026-05-01 — Coexist with Claude Code auto-memory
**Context:** Claude Code v2.1.59+ ships auto-memory at `~/.claude/projects/<git-root>/memory/MEMORY.md` (machine-local).
**Decision:** Keep smartmem's repo-committed schema. Add wizard option `autoMemory: keep | off | mirror`.
**Consequences:** Two layers serving different purposes. No data duplication by default.

## 2026-05-01 — Single-writer memory model
**Context:** Multiple subagents writing to memory simultaneously caused races (cc10x experience).
**Decision:** Only `memory-finalizer` writes. Others emit `MEMORY_NOTES:` blocks consumed at Stop / PreCompact.
**Consequences:** Race-free, compaction-survivable. SubagentStop hook warns (non-blocking) on missing notes.

## 2026-05-01 — hookMode enum
**Context:** Six hook checkboxes; users picked "all" anyway.
**Decision:** Single setting `hookMode: off | guard | full`.
**Consequences:** Simpler init UX. Edge cases require manual `settings.json` edit.

## 2026-05-01 — Plugin marketplace as primary distribution
**Context:** NikiforovAll/claude-code-rules and cc10x distribute via `marketplace.json`. Plugin updates ride on `/plugin update`.
**Decision:** Marketplace primary; `scripts/install.{ps1,sh}` symlink fallback for restricted envs.
**Consequences:** Free non-destructive updates. Plugin manifests to maintain.

## 2026-05-01 — Default memory language is English
**Context:** Hebrew/Arabic/CJK content costs 30-50% more tokens than English in Claude's tokenizer. Memory loaded every session.
**Decision:** `memoryLanguage: en` by default, even when user is chatting in another language. Ship Hebrew templates for users who explicitly opt in.
**Consequences:** Lower token cost for everyone by default. Hebrew users who prefer human-readable memory can opt in.
