# smartmem

**Hierarchical smart memory + harness initializer for Claude Code projects.**

[English docs](docs/guide/01-quickstart.md) · [תיעוד בעברית](docs/he/README.md)

One command (`/smartmem-init`) gets any project from empty to fully-instrumented in under a minute: 18 split memory files, a single-writer memory-finalizer agent, compaction-survival hooks, a `/prd → /tasks → /process` workflow, project-type overlays, and per-language packs (Python, TypeScript, Go, Rust, Java, C#).

```
empty dir   ─┐
existing  ─┤  /smartmem-init  ─►  CLAUDE.md + memory/ + docs/ + .claude/ + agents + hooks + commands
project   ─┘
```

## Why this exists

Most Claude Code projects either have no memory file at all, or they have a 500-line `CLAUDE.md` that gets stale instantly. smartmem ships:

- A **fixed schema of 18 small focused memory files** — `architecture`, `code_structure`, `db_structure`, `ui_structure`, `api_surface`, `design_goals`, `system_requirements`, `system_patterns`, `tech_context`, `tasks`, `progress`, `decisions`, etc. — instead of one giant blob.
- A **single-writer `memory-finalizer` agent** so memory updates are race-free across subagents.
- **PreCompact + PostCompact hooks** so nothing is lost when context compacts.
- A **wizard** that picks a project type, model tier, hook mode, caveman concise mode, and **memory language** (default English even when chatting in another language — saves 30-50% tokens).
- **Per-language packs** with style/testing skills, toolchain notes, and MCP-LSP suggestions.

## What's in the box

| Layer | Pieces |
|---|---|
| **6 plugins** | `smartmem-core` + 5 overlays: `software`, `fullstack`, `business`, `data`, `cli` |
| **5 subagents** | `memory-finalizer` (sole writer), `task-tracker`, `explorer`, `planner`, `reviewer` |
| **5 skills** | `smartmem-init`, `smartmem-new-template`, `smartmem-lang-init`, `karpathy-guidelines`, `concise` |
| **10 slash commands** | `/status`, `/prd`, `/tasks`, `/process`, `/memory-sync`, `/memory-rotate`, `/task`, `/save-command`, `/caveman`, `/project-update` |
| **6 hooks** | `SessionStart`, `PreCompact`, `PostCompact`, `Stop`, `SubagentStop`, `PreToolUse` (block-secrets) |
| **6 language packs** | python, typescript, go, rust, java, csharp |
| **2 memory languages** | English (default), Hebrew (עברית) |
| **18 memory files** | see [memory schema](docs/guide/03-memory-schema.md) |

---

## Install (one-time, per machine)

### Option A — from GitHub (recommended)
```
claude plugin marketplace add habuba/smartmem
claude plugin install smartmem-core@smartmem
```

### Option B — local marketplace
```bash
git clone https://github.com/habuba/smartmem.git
claude plugin marketplace add file:///absolute/path/to/smartmem
claude plugin install smartmem-core@smartmem
```

### Option C — symlink fallback (locked-down envs)
```powershell
pwsh scripts\install.ps1                 # all 6 plugins
```
```bash
bash scripts/install.sh
```

Restart Claude Code after install.

---

## Quickstart

```
cd <your-project>
claude
> /smartmem-init                    # 9-question wizard
> /smartmem-lang-init               # pick languages → installs style skills + tech_context
> /prd magic-link "passwordless login"
> /tasks magic-link
> /process
```

That's it.

## Documentation

| Page | Topic |
|---|---|
| [Quickstart](docs/guide/01-quickstart.md) | install + first project |
| [Wizard reference](docs/guide/02-wizard.md) | the 9 questions, model tiers, memory language |
| [Memory schema](docs/guide/03-memory-schema.md) | what each of the 18 files holds |
| [Hooks](docs/guide/04-hooks.md) | events, hookMode levels, custom hooks |
| [Architecture](docs/guide/05-architecture.md) | how smartmem itself is built |
| [Language packs](docs/guide/06-language-packs.md) | python/ts/go/rust/java/csharp + LSP via MCP |
| [Troubleshooting](docs/guide/07-troubleshooting.md) | install / wizard / hooks / memory issues |
| [Publishing](docs/guide/08-publishing.md) | fork & ship your own marketplace |
| [תיעוד בעברית](docs/he/README.md) | Hebrew documentation |

## Memory language note

The wizard asks for `memoryLanguage` and **defaults to `en`**. We strongly recommend keeping it English **even if you chat with Claude in Hebrew, Arabic, or another language**.

Why: memory files are re-read on every session. English is denser per token in Claude's tokenizer; equivalent Hebrew/Arabic/CJK content is 30-50% more tokens. Claude reasons over English memory equally well regardless of conversation language. If you specifically need human-readable Hebrew memory, choose `he` at init — full Hebrew templates ship in v0.2.

---

## Memory schema (at a glance)

```
memory/
├── MEMORY.md              # index — one line per file
├── project_brief.md       # what & why
├── product_context.md     # users, problems, success
├── design_goals.md        # priorities, trade-off rules
├── system_requirements.md # FR-/NFR-
├── glossary.md            # terms
├── architecture.md        # high-level system architecture
├── code_structure.md      # where code lives
├── system_patterns.md     # code conventions
├── tech_context.md        # stack + commands  (auto-extended by lang packs)
├── db_structure.md        # schema, migrations (skip if no DB)
├── ui_structure.md        # component tree, design system (skip if no UI)
├── api_surface.md         # endpoints, contracts (skip if no API)
├── active_context.md      # current focus (managed by finalizer)
├── tasks.md               # open / blocked / done
├── progress.md            # append-only milestones
├── commands.md            # shell command bookmarks
└── decisions.md           # ADR mirror

docs/
├── BIG_PICTURE.md         # durable design intent (you edit)
├── DECISIONS.md           # canonical ADR log (finalizer)
├── CHANGELOG.md           # dated changes
└── BACKLOG.md             # parking lot

.claude/smartmem/v1/       # hot tier, gitignored
├── config.json            # wizard answers
├── active_context.md      # session-fresh focus
└── event-log.jsonl        # finalizer audit trail
```

Full reference: [Memory schema docs](docs/guide/03-memory-schema.md).

---

## Project types

The wizard picks one. Each is its own overlay plugin.

| Type | Adds |
|---|---|
| `software-library` | tuned `system_patterns.md`, `tech_context.md` for libraries |
| `fullstack-web` | `frontend/CLAUDE.md`, `backend/CLAUDE.md`, `api_context.md`, `frontend_context.md` |
| `business-workflow` | `stakeholders.md`, `processes.md`, `slas.md` |
| `data-ml` | `datasets.md`, `experiments.md`, `model_registry.md` |
| `cli-tool` | argument-design and distribution patterns |

Add a new project type with `/smartmem-new-template` (interactive forking of any existing template).

---

## How it interoperates

- **caveman** (`JuliusBrussee/caveman`) — opt-in at init.
- **cc10x** (`romiluz13/cc10x`) — coexists. We namespace under `.claude/smartmem/`, avoid generic verbs (BUILD/PLAN/REVIEW).
- **claude-mem** — coexists. Different scope (session capture vs. durable schema).
- **Cline Memory Bank** — schema inspiration; smartmem extends with hot tier + finalizer + lang packs.

---

## License

MIT.
