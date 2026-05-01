# Hooks

smartmem ships 6 hooks. They're packaged in `plugins/smartmem-core/hooks/hooks.json` and activated when you install the plugin.

| Event | Action | Default |
|---|---|---|
| `SessionStart` | Print `/status` briefing | on |
| `PreCompact` | Run `memory-finalizer` to distill notes before compaction | on |
| `PostCompact` | Re-inject `MEMORY.md` index + `active_context.md` after compaction | on |
| `Stop` | Tell Claude to invoke `memory-finalizer` (only if `hookMode: full`) | conditional |
| `SubagentStop` | Audit: warn if subagent emitted no `MEMORY_NOTES:` block | on (warning) |
| `PreToolUse` (`Write\|Edit`) | Block secrets — refuse with exit 2 if AWS key, GitHub token, JWT, etc. detected | on |

## Hook mode toggle

`.claude/smartmem/v1/config.json` field `hookMode`:

```jsonc
"hookMode": "full"   // off | guard | full
```

| Mode | block-secrets | PreCompact | PostCompact | SessionStart | Stop finalizer | SubagentStop |
|---|---|---|---|---|---|---|
| `off` | – | – | – | – | – | – |
| `guard` | ✓ | ✓ | – | – | – | – |
| `full` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

The hook scripts inspect this field at runtime and bail early when not in scope.

## Cross-platform

All hooks ship as PowerShell `.ps1` (primary) with bash `.sh` equivalents for Unix. The plugin's `hooks.json` references the PowerShell variant; on Linux/macOS, replace `pwsh -NoProfile -File ...` with `bash ...sh` in `hooks.json`. (We'll auto-detect in a future version.)

## Authoring custom hooks

Add entries to your project's `.claude/settings.json`:

```jsonc
{
  "hooks": {
    "PreCommit": [{
      "matcher": "*",
      "hooks": [{ "type": "command", "command": "your-script.ps1" }]
    }]
  }
}
```

These merge with smartmem's hooks via the array-union semantics of Claude Code's settings precedence.

## Disabling smartmem hooks temporarily

```
claude plugin disable smartmem-core
```

Memory files stay; hooks stop firing. Re-enable with `claude plugin enable smartmem-core`.
