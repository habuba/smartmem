# Troubleshooting

## Install

**`claude plugin marketplace add` fails with "not found"** — confirm the URL: `claude plugin marketplace add habuba/smartmem`. Check `claude plugin marketplace list` to see what's registered.

**Symlink install on Windows fails** — symlinks need either Developer Mode (Settings → For developers → Developer Mode) or an elevated shell. Or use `pwsh scripts\install.ps1 -Copy`.

## Wizard

**"You cannot call a method on a null-valued expression"** — fixed in v0.2+. Update with `claude plugin update smartmem-core`.

**Overlay file didn't win** — overlay applies *before* base, so the overlay's `system_patterns.md` should appear, not the generic base one. If you see the wrong content, you may have run init before v0.1.1 — delete the file and re-run.

**Hebrew memory files written but content is English** — you ran the wizard with `memoryLanguage: en`; the per-file content is locked at first init. To switch: delete `memory/*.md`, re-run with `memoryLanguage: he`.

## Hooks

**Hooks not firing on Windows** — needs `pwsh` (PowerShell 7+) on PATH, not Windows PowerShell 5.1. Check: `pwsh -NoProfile -Command 'Write-Host ok'`.

**Hooks not firing on Linux/macOS** — current `hooks.json` references `pwsh`. Until auto-detect ships, replace `pwsh -NoProfile -File <script>.ps1` with `bash <script>.sh` in `plugins/smartmem-core/hooks/hooks.json`.

**`memory-finalizer` not invoked on Stop** — check `.claude/smartmem/v1/config.json` `hookMode` is `full`. Restart Claude Code after editing.

**`SubagentStop` audit warns on every agent** — false positives if the agent legitimately had nothing to record. Disable in `hooks.json` or override in your project's `.claude/settings.json`.

## Memory

**A subagent wrote directly to `memory/` instead of emitting `MEMORY_NOTES`** — fix the agent's prompt to instruct it to emit notes, not write. Then run `/memory-sync` to get the finalizer to consolidate.

**`active_context.md` is stale** — finalizer didn't run. Trigger manually: `/memory-sync`. If `hookMode: full`, also check that `Stop` hook is configured.

**Re-running wizard wiped my custom edits** — should never happen for `memory/*.md` or `docs/*.md` (they're `create-only`). If it did, file an issue with the wizard output. Recover from `git`.

## Language packs

**`/smartmem-lang-init` says "language pack not found"** — confirm `plugins/smartmem-core/language-packs/<lang>/` exists in your installed plugin path.

**MCP server doesn't connect** — verify `.mcp.json` syntax (jq / `claude --print '@.mcp.json'`), confirm the LSP binary is on PATH, restart Claude Code, run `/mcp` to inspect.

## Removing smartmem

```
claude plugin uninstall smartmem-core
```

Memory files, docs, and `.claude/smartmem/` stay (they're yours). To fully remove:

```bash
rm -rf memory/ docs/ .claude/smartmem/
# remove the smartmem block from CLAUDE.md and .gitignore (between the markers)
```
