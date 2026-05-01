# Quickstart

Bootstrap any Claude Code project with hierarchical memory in under 60 seconds.

## Install (one-time, per machine)

Pick one:

### From GitHub (recommended)
```
claude plugin marketplace add habuba/smartmem
claude plugin install smartmem-core@smartmem
```

### From a local clone (offline / restricted env)
```bash
git clone https://github.com/habuba/smartmem.git
cd smartmem

# Windows
pwsh scripts\install.ps1

# Linux/macOS/WSL
bash scripts/install.sh
```

This symlinks every plugin into `~/.claude/plugins/`. Use `-Copy` (PowerShell) to copy instead — needed if your shell can't make symlinks.

Restart Claude Code. Verify:
```
claude plugin list
```

## Bootstrap your project

`cd` into the project (empty or existing — smartmem is non-destructive). Start Claude Code, then:

```
/smartmem-init
```

You'll be asked **9 questions** — see the [wizard reference](02-wizard.md). The default answers are sensible; you can press **Enter** through most of them.

After the wizard you should see:

```
memory/             ← 19 split memory files (Cline-bank schema, expanded)
docs/               ← BIG_PICTURE, DECISIONS, CHANGELOG, BACKLOG
.claude/smartmem/   ← hot tier (gitignored)
.claude/settings.json (merged, not overwritten)
CLAUDE.md           ← thin pointer file (prepended if you already had one)
```

## First feature

```
/prd magic-link "passwordless login via email magic links"
/tasks magic-link
/process
```

`/prd` writes `docs/prds/magic-link.md`. `/tasks` expands it into 3-12 atomic tasks in `memory/tasks.md`. `/process` works the next open task — automatically using the `planner` agent for design and the `reviewer` agent before commit.

## Add language support

```
/smartmem-lang-init
```

Multi-select your language(s): Python, TypeScript, Go, Rust, Java, C#. Each pack installs:
- 1-2 behavioral skills (style + testing)
- An append to `memory/tech_context.md` with toolchain + commands
- An optional MCP-LSP suggestion you can paste into `.mcp.json`

## Daily commands

| Command | Purpose |
|---|---|
| `/status` | One-screen briefing: focus, open tasks, recent decisions |
| `/task add "..."` / `/task done T-007` | Quick task ops |
| `/save-command lint "ruff check ."` | Save a shell command |
| `/memory-sync` | Manually run the finalizer (auto on `Stop`/`PreCompact` if hookMode=full) |
| `/memory-rotate` | Archive Done tasks >30d |
| `/caveman on\|off\|switch` | Toggle concise output |

You should rarely touch memory files by hand. The `memory-finalizer` agent owns them.

## Next

- [Memory schema reference](03-memory-schema.md)
- [Wizard reference](02-wizard.md)
- [Hooks](04-hooks.md)
- [Architecture](05-architecture.md)
- [עברית](../he/01-quickstart.md)
