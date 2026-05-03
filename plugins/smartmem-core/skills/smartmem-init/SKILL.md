---
name: smartmem-init
description: Bootstrap or upgrade a Claude Code project with hierarchical smart memory and a configurable harness from a project-type template. Use when the user says things like "set up smart memory in this project", "init claude memory here", "scaffold smartmem", or "bootstrap this project".
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# smartmem-init

You are running the smartmem first-run wizard. Goal: bootstrap or non-destructively upgrade the current project. The new philosophy is **pick the file set, do not pre-fill content** — memory files start empty (just title + purpose stub) and grow as the user works.

## Step 1 — detect

Check for existing files (Read/Glob):
- `CLAUDE.md` at repo root
- `.claude/smartmem/v1/config.json` (already initialized if present)
- `memory/MEMORY.md`
- Git repo (`.git/`)

If `.claude/smartmem/v1/config.json` exists → call this an **upgrade** run; skip prompts that already have answers in the config and only ask the new ones.

## Step 2 — interactive prompts

Use AskUserQuestion. Save answers as you go.

1. **Project type** — `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `other`.
2. **Project name** — short slug (default: directory name).
3. **One-line description**.
4. **Pick memory files** — multi-select. Show the type-default checklist pre-checked (see registry below). User can uncheck or add custom names. Tell them: "Each file starts empty with just a title; you fill it as you work. You can add or remove files later with `/memory-files add|remove`."
   - Type defaults:
     - `software-library` / `cli-tool`: project_brief, design_goals, architecture, code_structure, system_patterns, tech_context, active_context, tasks, decisions, commands, progress
     - `fullstack-web`: + product_context, system_requirements, db_structure, ui_structure, api_surface
     - `business-workflow`: project_brief, product_context, design_goals, system_requirements, stakeholders, processes, slas, active_context, tasks, decisions, progress
     - `data-ml`: project_brief, design_goals, architecture, datasets, experiments, model_registry, tech_context, system_patterns, active_context, tasks, decisions, commands, progress
5. **Always-loaded files** — which of the chosen files should be `@`-imported in CLAUDE.md so they live in every session's context. Default: `active_context`, `tasks`. Recommend keeping this small (≤4 files).
6. **Update mode** — `auto` (recommended, default) / `manual`.
   - `auto`: `memory-finalizer` runs on Stop and PreCompact, applying scratch notes without prompting.
   - `manual`: nothing writes memory until you run `/memory-sync`; finalizer shows a diff and asks before writing.
7. **Model tier** — `frugal` / `balanced` (recommended) / `premium`.
8. **hookMode** — `off` / `guard` / `full` (recommended).
9. **Caveman concise mode** — `caveman-plugin` / `our-concise` / `off`.
10. **Memory language** — `en` (recommended) / `he` / other. Strongly recommend `en` even when chatting in another language (saves 30-50% tokens).
11. **Auto-memory** — `keep` (default) / `off` / `mirror`. See `docs/guide/09-auto-memory.md`.
12. **Install language pack now?** — yes/no. If yes, invoke `smartmem-lang-init` after.

## Step 3 — render

Run the wizard with the collected params:
- Windows: `pwsh -NoProfile -File ${CLAUDE_PLUGIN_ROOT}/scripts/wizard.ps1 -ConfigJson '<json>' -Path "$CLAUDE_PROJECT_DIR"`
- Unix: `bash ${CLAUDE_PLUGIN_ROOT}/scripts/wizard.sh --config '<json>' --path "$CLAUDE_PROJECT_DIR"`

`<json>` must include: `name`, `type`, `description`, `modelTier`, `hookMode`, `caveman`, `memoryLanguage`, `autoMemory`, `updateMode`, `memoryFiles[]`, `alwaysLoaded[]`.

The wizard:
- Creates `memory/`, `.claude/smartmem/v1/`, `docs/` (if missing).
- Generates `memory/<name>.md` for each chosen file (just `# Title` + purpose comment — empty body).
- Generates `memory/MEMORY.md` index based on the chosen file set.
- Writes `.claude/smartmem/v1/config.json` (the durable wizard answers).
- Renders root `CLAUDE.md` (non-destructive: prepends a marked block) with `@`-imports for the always-loaded files and the concise + hierarchical-memory + update-mode rules baked in.
- Updates `.claude/settings.json` with permission scoping for `.claude/smartmem/**`.

## Step 4 — verify and brief

After rendering:
1. Read back `memory/MEMORY.md` and the root `CLAUDE.md` smartmem block.
2. Print a one-screen briefing: chosen files, always-loaded set, update mode, what to do next (`/status`, `/memory-files list`, `/prd <slug>`).
3. If `caveman-plugin` was chosen, print the install command (do not auto-install).
4. Append a one-line `MEMORY_NOTES: project initialized via smartmem-init (<date>)` block to `.claude/smartmem/v1/scratch.md` so the next finalizer run logs the bootstrap event.

Never overwrite existing `memory/*.md` or `docs/*.md`. Only seed when absent.
