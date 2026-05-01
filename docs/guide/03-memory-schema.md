# Memory schema

smartmem splits project memory into **18 small focused files** organized in three tiers. Each file has a single purpose and a single writer.

## Tiers

| Tier | Loaded | Updated by |
|---|---|---|
| **Core** (always in context) | every session | `memory-finalizer` agent (sole writer) |
| **Recall** (lazy-loaded via `@imports`) | when relevant | `memory-finalizer` |
| **Hot** (`.claude/smartmem/v1/`, gitignored) | every session | `memory-finalizer` |
| **Docs** (`docs/`, committed) | by reference | finalizer + humans |

## Files

### What & why
| File | Purpose | Edited by |
|---|---|---|
| `memory/project_brief.md` | One-paragraph: what this project is and why it exists | you (manually) |
| `memory/product_context.md` | Users, problems, success criteria | you |
| `memory/design_goals.md` | Priorities and trade-off rules | you |
| `memory/system_requirements.md` | Functional + non-functional reqs (FR-/NFR-) | you |
| `memory/glossary.md` | Project-specific terms and acronyms | finalizer |

### How
| File | Purpose | Edited by |
|---|---|---|
| `memory/architecture.md` | High-level system architecture, components, data flow | you + finalizer |
| `memory/code_structure.md` | Where code lives, module boundaries, naming | finalizer |
| `memory/system_patterns.md` | Code conventions to follow | finalizer |
| `memory/tech_context.md` | Stack, build, test, run commands | finalizer |
| `memory/db_structure.md` | Tables, indexes, migrations (skip if no DB) | finalizer |
| `memory/ui_structure.md` | Component tree, design system (skip if no UI) | finalizer |
| `memory/api_surface.md` | Endpoints, contracts (skip if no API) | finalizer |

### Now & history
| File | Purpose | Edited by |
|---|---|---|
| `memory/active_context.md` | Current focus | finalizer (mirror) |
| `memory/tasks.md` | Open / blocked / done | task-tracker (via finalizer) |
| `memory/progress.md` | Append-only milestones | finalizer |
| `memory/commands.md` | Frequently-used shell commands | finalizer (via `/save-command`) |
| `memory/decisions.md` | ADR-lite mirror | finalizer |

### Hot tier
| File | Purpose | Visibility |
|---|---|---|
| `.claude/smartmem/v1/active_context.md` | Session-fresh focus | gitignored optional |
| `.claude/smartmem/v1/event-log.jsonl` | Per-write audit trail | gitignored |
| `.claude/smartmem/v1/config.json` | Wizard answers | committed |

### Docs (committed, durable)
| File | Purpose | Edited by |
|---|---|---|
| `docs/BIG_PICTURE.md` | Durable design intent | you |
| `docs/DECISIONS.md` | Canonical ADR log | finalizer (one append per decision) |
| `docs/CHANGELOG.md` | Dated changes | finalizer |
| `docs/BACKLOG.md` | Idea parking lot | you + finalizer |
| `docs/prds/<slug>.md` | Per-feature PRDs | `/prd` command |
| `docs/plans/<slug>.md` | Per-feature plans | `planner` agent |

## The single-writer invariant

**Only `memory-finalizer` writes to `memory/**`, `.claude/smartmem/**`, or `docs/{DECISIONS,CHANGELOG,BACKLOG}.md`.**

Every other agent emits `MEMORY_NOTES:` blocks in their reply. The finalizer runs:
- on `Stop` (when `hookMode: full`)
- on `PreCompact` (always, even in `guard` mode)
- manually via `/memory-sync`

This is what makes hierarchical memory race-free across subagents and survivable across context compaction.

## Adding new memory files

You can add custom files. Two paths:

1. **Project-only** — just create `memory/my-file.md` and reference it in `memory/MEMORY.md`. Not portable.
2. **Reusable across projects** — add it to a new template overlay via `/smartmem-new-template`. Becomes part of the plugin family.

## Index file

`memory/MEMORY.md` is **the index, never the content** — one line per file, ≤200 lines total. Claude Code reads it first, then `@imports` only the files it needs.
