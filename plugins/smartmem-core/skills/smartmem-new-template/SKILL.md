---
name: smartmem-new-template
description: Scaffold a new smartmem project-type template (overlay plugin) from an existing one. Use when the user says "create a new smartmem template", "add a project type", "fork the X template", or wants to support a new kind of project.
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

# smartmem-new-template

Create a new overlay plugin under `plugins/smartmem-<name>/` and register it in the marketplace.

## Step 1 — collect (AskUserQuestion)

1. **New template name** — slug (e.g. `mobile-app`, `firmware`, `research-paper`)
2. **Base to fork from** — `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `_base` (start fresh)
3. **One-line description**
4. **Extra memory files** to add (free text, comma-separated; e.g. `device_matrix.md, build_targets.md`)
5. **Extra subagents** (free text; each becomes a stub `.md`)
6. **Extra slash commands** (free text)

## Step 2 — render

Working in the smartmem source repo (the one containing `.claude-plugin/marketplace.json`):

1. Copy `plugins/smartmem-<base>/` to `plugins/smartmem-<name>/`. If base is `_base`, copy from `plugins/smartmem-core/templates/_base/`.
2. Update `plugins/smartmem-<name>/.claude-plugin/plugin.json` with new `name` and `description`.
3. Append to `.claude-plugin/marketplace.json` `plugins` array.
4. For each extra memory file: create a stub at `plugins/smartmem-<name>/templates/memory/<file>` with a one-line H1 header.
5. For each extra subagent: create a stub `.md` under `plugins/smartmem-<name>/agents/` with frontmatter (name, description placeholder, model: haiku).
6. For each extra command: create a stub under `plugins/smartmem-<name>/commands/`.

## Step 3 — confirm

Print the diff of changed files. Tell the user:
- How to test locally: `claude plugin marketplace add file://<repo-root>` then `claude plugin install smartmem-<name>@smartmem`.
- To dogfood it: scaffold a test project and run `/smartmem-init` choosing the new template.

Emit `MEMORY_NOTES: created template smartmem-<name> based on <base>` so the finalizer logs it to `docs/CHANGELOG.md`.
