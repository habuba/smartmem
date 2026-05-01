# Progress

Append-only milestone log. Newest at top.

## 2026-05-01
- **v0.3.0** — Coexist with Claude Code's built-in auto-memory. Wizard option `autoMemory: keep | off | mirror`. New doc page `docs/guide/09-auto-memory.md` (EN+HE). settings.json now writes `autoMemoryEnabled` from wizard answer.
- **v0.2.0** — Granular memory split: 18 files instead of 10 (added `architecture`, `code_structure`, `db_structure`, `ui_structure`, `api_surface`, `design_goals`, `system_requirements`, `glossary`). New `/smartmem-lang-init` skill with 6 language packs (python/ts/go/rust/java/csharp). Hebrew memory templates + `memoryLanguage` wizard option. GitHub-friendly docs at `docs/guide/01-08` (EN) + `docs/he/01-08` (HE).
- **v0.1.1** — Wizard hardening: handle empty templates, idempotent CLAUDE.md prepend (marker block written on first create), always-merge runtime config, overlay applies before base.
- **v0.1.0** — Initial scaffold: 6 plugins, 5 subagents, 5 skills, 10 slash commands, 6 hooks, 5 project-type overlays, install fallback, README. Pushed to https://github.com/habuba/smartmem.
