---
name: smartmem-lang-init
description: Install language-specific skill packs (style, testing, LSP/MCP suggestions) into the current smartmem project. Use when the user says "configure for python", "add language skills", "set up lsp", "install language pack".
user-invocable: true
allowed-tools: Read, Write, Edit, Bash, Glob
---

# smartmem-lang-init

Install per-language packs into a project that has already been initialized with `/smartmem-init`.

## Step 1 — preflight

Confirm `.claude/smartmem/v1/config.json` exists. If not, tell the user to run `/smartmem-init` first.

## Step 2 — pick languages (AskUserQuestion, multiSelect)

Read `${CLAUDE_PLUGIN_ROOT}/language-packs/manifest.json` to get the available list. Currently:
**Python, TypeScript, Go, Rust, Java, C#/.NET**.

Ask the user: **"Which language packs to install?"** (multi-select).

For each language, also ask: **"Register MCP LSP server suggestions?"** (yes/no — yes adds a pointer in `memory/mcp_suggestions.md`).

## Step 3 — install

For each selected language `<lang>`, run:

- Windows: `pwsh -NoProfile -File ${CLAUDE_PLUGIN_ROOT}/scripts/install-lang-pack.ps1 -Lang <lang> -Path "$CLAUDE_PROJECT_DIR" [-WithMcp]`
- Unix: `bash ${CLAUDE_PLUGIN_ROOT}/scripts/install-lang-pack.sh --lang <lang> --path "$CLAUDE_PROJECT_DIR" [--with-mcp]`

The script:
- Copies `${CLAUDE_PLUGIN_ROOT}/language-packs/<lang>/skills/*/SKILL.md` into `<project>/.claude/skills/`
- Appends `tech_context.snippet.md` to `<project>/memory/tech_context.md` (idempotent — guarded by marker)
- If `--with-mcp`: writes `mcp_suggestions.md` to `<project>/memory/mcp_suggestions.md` and prints the `.mcp.json` snippet for the user to apply
- Updates `.claude/smartmem/v1/config.json` `languages` array (creates if missing)

## Step 4 — confirm

Print:
- Skills installed (paths)
- Memory files touched
- If MCP suggestions were generated: tell the user to edit their `.mcp.json` and restart Claude Code, then verify with `/mcp`

Emit `MEMORY_NOTES: installed language pack(s) <list>` so memory-finalizer logs it to `docs/CHANGELOG.md`.
