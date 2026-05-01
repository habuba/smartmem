---
name: smartmem-init
description: Bootstrap or upgrade a Claude Code project with hierarchical smart memory and a configurable harness from a project-type template. Use when the user says things like "set up smart memory in this project", "init claude memory here", "scaffold smartmem", or "bootstrap this project".
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# smartmem-init

You are running the smartmem first-run wizard. Goal: bootstrap or non-destructively upgrade the current project.

## Step 1 — detect

Check for existing files (Read/Glob):
- `CLAUDE.md` at repo root
- `.claude/smartmem/v1/config.json` (already initialized if present)
- `memory/MEMORY.md`
- Git repo (`.git/`)

If `.claude/smartmem/v1/config.json` exists → call this an **upgrade** run; skip prompts that already have answers in the config and only ask the new ones.

## Step 2 — interactive prompts

Use the AskUserQuestion tool for each. Save answers as you go.

1. **Project type** — `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `other (custom)`
2. **Project name** — short slug (default: directory name)
3. **One-line description**
4. **Model tier per role** — single question with three tiers:
   - frugal: all haiku
   - balanced (recommended): finalizer/task-tracker=haiku, explorer/reviewer=sonnet, planner=opus
   - premium: all sonnet+ (planner=opus)
5. **hookMode** — `off` / `guard` / `full` (recommended)
6. **Caveman concise mode** — `caveman-plugin` / `our-concise` / `off`
7. **Memory language** — `en` (recommended, default) / `he` / other.
   **Important UX note:** strongly recommend keeping memory in English even if the user is chatting with Claude in another language. English memory files are ~30-50% fewer tokens than equivalent Hebrew/Arabic/CJK content, and Claude reasons equally well over English memory regardless of conversation language.
8. **Auto-memory** — `keep` (default, recommended) / `off` / `mirror`.
   Claude Code has its own machine-local auto-memory at `~/.claude/projects/<git-root>/memory/MEMORY.md`. Two systems can coexist:
   - `keep`: leave Claude's auto-memory on. smartmem owns team-shared durable; auto-memory keeps per-machine learning.
   - `off`: writes `autoMemoryEnabled: false` into `.claude/settings.json` so Claude won't read/write auto-memory in this repo.
   - `mirror`: (experimental) finalizer reads auto-memory on each pass and promotes team-shareable facts (build commands, decisions) into smartmem.
   See `docs/guide/09-auto-memory.md`.
9. **Install language pack now?** — yes/no. If yes, after the wizard completes, automatically invoke `smartmem-lang-init`.
10. **MCP servers to register** — optional list, can skip

## Step 3 — render

Run the wizard script with the collected params:
- Windows: `pwsh -NoProfile -File ${CLAUDE_PLUGIN_ROOT}/scripts/wizard.ps1 -ConfigJson '<json>' -Path "$CLAUDE_PROJECT_DIR"`
- Unix: `bash ${CLAUDE_PLUGIN_ROOT}/scripts/wizard.sh --config '<json>' --path "$CLAUDE_PROJECT_DIR"`

The wizard:
- Creates `memory/`, `.claude/smartmem/v1/`, `docs/` (if missing)
- Renders templates from the chosen overlay (substituting `{{name}}`, `{{description}}`, `{{MODEL_*}}`, etc.)
- Writes `.claude/smartmem/v1/config.json` (the durable wizard answers)
- Updates root `CLAUDE.md` with `@imports` (non-destructive: prepends a marked block, never overwrites)
- Updates `.claude/settings.json` with permission scoping for `.claude/smartmem/**`

## Step 4 — verify and brief

After rendering:
1. Read back the new `memory/MEMORY.md` and `.claude/smartmem/v1/active_context.md`
2. Print a one-screen briefing: what was created, what the user should do next (`/status`, `/prd`, etc.)
3. If `caveman-plugin` was chosen, print the install command (do not auto-install).
4. Spawn `memory-finalizer` once with a synthetic note `MEMORY_NOTES: project initialized via smartmem-init` so the event-log has a first entry.

Never overwrite existing `memory/*.md` or `docs/*.md`. Only seed when absent.
