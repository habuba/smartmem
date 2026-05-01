# smartmem

**Hierarchical smart memory + harness initializer for Claude Code projects.**

One command (`/smartmem-init`) gets any project from empty to fully-instrumented in under a minute: hierarchical memory files, a single-writer memory-finalizer agent, compaction-survival hooks, a `/prd → /tasks → /process` workflow, and project-type-specific overlays — all chosen interactively at init time.

```
empty dir   ─┐
existing  ─┤  /smartmem-init  ─►  CLAUDE.md + memory/ + docs/ + .claude/ + agents + hooks + commands
project   ─┘
```

## Why this exists

Most Claude Code projects either have no memory file at all, or they have a 500-line `CLAUDE.md` that gets stale instantly. smartmem ships a **fixed schema** of small memory files (Cline Memory Bank pattern), a **single-writer agent** that maintains them race-free (cc10x pattern), and **compaction-survival hooks** so nothing is lost when context compacts. You pick a project type and a model tier; smartmem does the rest.

What's in the box:

| Layer | Pieces |
|---|---|
| **6 plugins** | `smartmem-core` + 5 overlays: `software`, `fullstack`, `business`, `data`, `cli` |
| **5 subagents** | `memory-finalizer` (sole writer), `task-tracker`, `explorer`, `planner`, `reviewer` |
| **4 skills** | `smartmem-init` (wizard), `smartmem-new-template` (meta), `karpathy-guidelines`, `concise` |
| **10 commands** | `/status`, `/prd`, `/tasks`, `/process`, `/memory-sync`, `/memory-rotate`, `/task`, `/save-command`, `/caveman`, `/project-update` |
| **6 hooks** | `SessionStart` (briefing), `PreCompact` (finalize), `PostCompact` (reload), `Stop` (finalize), `SubagentStop` (audit), `PreToolUse` (secrets) |
| **Memory schema** | `memory/{MEMORY,project_brief,product_context,active_context,system_patterns,tech_context,progress,tasks,commands,decisions}.md` + `docs/{BIG_PICTURE,DECISIONS,CHANGELOG,BACKLOG}.md` + hot tier `.claude/smartmem/v1/` |

---

## Deployment — for the repo owner

You're publishing smartmem so that other people (or your future self on other machines) can install it.

### Option A — push to GitHub (recommended)

```bash
git init
git add .
git commit -m "Initial smartmem scaffold"
git remote add origin https://github.com/<you>/smartmem.git
git push -u origin main
```

Anyone can then install via:

```
claude plugin marketplace add <you>/smartmem
claude plugin install smartmem-core@smartmem
```

### Option B — local install (no GitHub)

From the cloned repo on your machine:

```powershell
# Windows
claude plugin marketplace add file://C:/cld-ins/Project-memory-init
claude plugin install smartmem-core@smartmem
```

```bash
# Unix
claude plugin marketplace add file:///absolute/path/to/Project-memory-init
claude plugin install smartmem-core@smartmem
```

### Option C — symlink fallback (locked-down envs without marketplace access)

```powershell
pwsh scripts\install.ps1                    # links all 6 plugins into ~/.claude/plugins/
pwsh scripts\install.ps1 -Plugins core      # just core
pwsh scripts\install.ps1 -Copy              # copy instead of symlink (no admin needed)
```

```bash
bash scripts/install.sh                     # all 6
bash scripts/install.sh core software       # subset
```

Restart Claude Code after install. The skills, agents, hooks, and commands appear automatically.

### Publishing a new version

1. Bump the `version` field in each `plugins/smartmem-*/.claude-plugin/plugin.json` you changed.
2. Bump the top-level `.claude-plugin/marketplace.json` `version`.
3. Append a `docs/CHANGELOG.md` entry.
4. `git tag v0.x.y && git push --tags`.

End users pick up the change with `claude plugin update smartmem-core` (or `--all`).

---

## Usage — for someone installing smartmem in their project

### 1. Install smartmem (one-time, per machine)

Pick the option from "Deployment" above that matches your environment. Verify install:

```
claude plugin list
# you should see smartmem-core (and any overlays you installed)
```

### 2. Bootstrap a project

`cd` into the project (can be empty or existing) and start Claude Code. Then:

```
/smartmem-init
```

The wizard asks 6 questions:

| Question | Options |
|---|---|
| Project type | `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `other` |
| Project name | (slug; defaults to dir name) |
| One-line description | (free text) |
| Model tier | `frugal` (all haiku) / `balanced` (recommended) / `premium` (sonnet+opus) |
| Hook mode | `off` / `guard` (safety only) / `full` (recommended) |
| Caveman concise | `caveman-plugin` / `our-concise` / `off` |

It then:
- Creates `memory/`, `docs/`, `.claude/smartmem/v1/`, root `CLAUDE.md` (non-destructively prepended to any existing one).
- Renders the matching overlay (extra files for fullstack/data/etc.).
- Wires hooks and permissions in `.claude/settings.json` (merged, not overwritten).
- Logs the init event to `.claude/smartmem/v1/event-log.jsonl`.

### 3. Daily workflow

```
/status                        # one-screen briefing: focus, open tasks, recent decisions
/prd auth-flow "passwordless login via magic link"
/tasks auth-flow               # expand the PRD into 3-12 atomic tasks in memory/tasks.md
/process                       # work the next open task; uses planner + reviewer
/task done T-007               # mark done
/save-command test-watch "npm run test -- --watch"
/memory-sync                   # manual finalizer pass (auto-runs on Stop / PreCompact when hookMode=full)
```

The finalizer keeps `memory/active_context.md`, `docs/DECISIONS.md`, `docs/CHANGELOG.md`, `memory/system_patterns.md`, and `memory/tech_context.md` up to date silently. You should rarely need to edit memory files by hand — when you do, the finalizer leaves your edits alone.

### 4. Periodic upkeep

```
/memory-rotate                 # archive Done tasks >30 days into memory/archive/YYYY-MM/
/project-update                # non-destructive re-init after `claude plugin update smartmem-core`
```

### 5. Adding a new project type

Inside the smartmem source repo (the one with `marketplace.json` at root):

```
/smartmem-new-template
```

The meta-skill walks you through forking an existing template. New overlay registers itself in `marketplace.json`.

---

## Memory schema reference

| File | Tier | Writer | Purpose |
|---|---|---|---|
| `CLAUDE.md` (root) | core (always loaded) | init + you (manual) | thin entry — `@imports` everything else |
| `memory/MEMORY.md` | core | finalizer | one-line index of memory files |
| `memory/project_brief.md` | recall | you | what & why; durable |
| `memory/product_context.md` | recall | you | users, problems, success |
| `memory/active_context.md` | core | **finalizer only** | current focus |
| `memory/system_patterns.md` | recall | finalizer | discovered patterns |
| `memory/tech_context.md` | recall | finalizer | stack, build, test commands |
| `memory/progress.md` | recall | finalizer | append-only milestones |
| `memory/tasks.md` | recall | task-tracker (via finalizer) | open / done |
| `memory/commands.md` | recall | finalizer | shell command bookmarks |
| `memory/decisions.md` | recall | finalizer | ADR mirror |
| `docs/BIG_PICTURE.md` | committed | you | durable design intent |
| `docs/DECISIONS.md` | committed | finalizer | canonical ADR log |
| `docs/CHANGELOG.md` | committed | finalizer | dated changes |
| `docs/BACKLOG.md` | committed | you + finalizer | parking lot |
| `.claude/smartmem/v1/active_context.md` | hot (gitignored) | finalizer | session-fresh focus |
| `.claude/smartmem/v1/event-log.jsonl` | hot (gitignored) | finalizer | per-write audit trail |

---

## How it interoperates

- **Caveman** (`JuliusBrussee/caveman`) — opt-in at init. We don't vendor it; we point at it.
- **cc10x** (`romiluz13/cc10x`) — coexists. We namespace under `.claude/smartmem/`, avoid generic verbs (BUILD/PLAN/REVIEW), don't claim its keywords.
- **claude-mem** — coexists. claude-mem captures session events; smartmem owns the durable schema.
- **Cline Memory Bank** — schema inspiration; we extend with hot tier + finalizer.

---

## Troubleshooting

**Hooks not firing on Windows.** Make sure `pwsh` is on PATH (PowerShell 7+, not Windows PowerShell 5.1). Test: `pwsh -NoProfile -Command 'Write-Host ok'`.

**Symlink install needs admin on Windows.** Either enable Developer Mode (Settings → For developers → Developer Mode), run `pwsh scripts\install.ps1` from an elevated shell, or use `-Copy` to copy instead of symlink.

**`memory-finalizer` not being invoked on Stop.** Check `.claude/smartmem/v1/config.json` — `hookMode` should be `full`. Restart Claude Code after changing it.

**Wizard says overlay not found.** Install the overlay plugin: `claude plugin install smartmem-fullstack@smartmem` (or whichever).

**I want to disable smartmem temporarily.** `claude plugin disable smartmem-core` — your memory files stay, hooks stop firing.

---

## License

MIT.
