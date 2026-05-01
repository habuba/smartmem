# smartmem ↔ Claude Code auto-memory

Claude Code (v2.1.59+) ships a built-in **auto-memory** feature. smartmem and auto-memory are *different things* serving *different purposes*. This page explains how they relate.

## TL;DR

| Layer | Path | Scope | Who writes | Lifetime |
|---|---|---|---|---|
| **smartmem `memory/`** | `<project>/memory/*.md` | Repo (committed, team-shared) | `memory-finalizer` agent (only) | Project lifetime |
| **smartmem hot tier** | `<project>/.claude/smartmem/v1/` | Repo (gitignored, machine-local) | `memory-finalizer` agent | Session-fresh |
| **Claude auto-memory** | `~/.claude/projects/<git-root>/memory/MEMORY.md` | **Machine-local, per-git-repo** | Claude (autonomous, via `Edit` tool) | Persists across sessions on this machine |

Both can coexist. They don't fight.

## What auto-memory actually is

When Claude Code starts a session, it loads up to **200 lines / 25 KB** from `~/.claude/projects/<git-root>/memory/MEMORY.md` (where `<git-root>` is derived from your git repo path). Claude can autonomously update this file via its normal `Edit` tool when it decides something is worth remembering — build commands you ran, debugging patterns, your stylistic preferences, etc.

Key facts:

- **Per machine**: never synced across users or machines. Two devs on the same repo have independent auto-memories.
- **Per git repo**: all worktrees and subdirectories of the same repo share one auto-memory dir.
- **Plain markdown**: just files. You can read, edit, or delete via `/memory` or your editor.
- **Topic files**: Claude can create additional files like `debugging.md` next to `MEMORY.md`. Those load on demand, not at session start.
- **No write tool**: there's no "save to memory" tool — Claude uses regular `Edit` and the harness watches the path.
- **Toggle**: `autoMemoryEnabled: false` in settings, or `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` env var.
- **Custom location**: `autoMemoryDirectory` in `~/.claude/settings.json` (user-level only — not allowed in shared `.claude/settings.json` for security).

Official docs: <https://code.claude.com/docs/en/memory.md>

## Why smartmem keeps its own `memory/` dir

smartmem's `<project>/memory/` is **deliberately different** from auto-memory:

| Property | smartmem `memory/` | Claude auto-memory |
|---|---|---|
| Committed to git | ✓ | ✗ |
| Team-shareable | ✓ | ✗ |
| Schema-enforced (18 files, fixed roles) | ✓ | ✗ |
| Race-free (single-writer agent) | ✓ | ✗ (Claude writes whenever) |
| Compaction-safe (PreCompact/PostCompact hooks) | ✓ | ✗ |
| Manageable from CI / outside Claude | ✓ | ✗ |
| Surface for `/prd → /tasks → /process` workflow | ✓ | ✗ |

If we wrote everything to auto-memory we'd lose: commit history, code review of memory changes, team sharing, CI inspection, and the structured schema that makes the finalizer race-free. So smartmem owns the durable layer; auto-memory stays as Claude's private learning tier.

## The wizard option

`/smartmem-init` asks `autoMemory`:

| Value | Behavior |
|---|---|
| `keep` (default, recommended) | Auto-memory stays on. Claude can keep its private notes; smartmem owns the structured schema. |
| `off` | Sets `autoMemoryEnabled: false` in `.claude/settings.json`. Useful if you want exactly one source of truth. |
| `mirror` | (Experimental) Auto-memory stays on AND the finalizer reads `~/.claude/projects/<git-root>/memory/MEMORY.md` on each pass and copies any decisions/patterns it finds into `memory/decisions.md` / `memory/system_patterns.md`. |

You can change this any time by editing `.claude/smartmem/v1/config.json` `autoMemory` field and re-running `/smartmem-init` (or `/project-update`).

## What goes where (mental model)

When Claude is about to save something, it picks based on **portability**:

- "We always run tests with `pytest -x`" → **smartmem** (`memory/commands.md`) — every dev on the team needs this.
- "User prefers I don't add extra comments" → **auto-memory** — preference, machine-local.
- "The auth flow is OAuth2 with PKCE" → **smartmem** (`memory/architecture.md`) — durable architecture.
- "Last session we couldn't reproduce bug X with the standard repro" → **auto-memory** — debugging trail, not durable.

In `mirror` mode the finalizer audits auto-memory each turn and promotes anything that looks team-shareable. Off by default because the heuristic is imperfect.

## How to inspect

```bash
# Where auto-memory lives for THIS repo:
echo "$HOME/.claude/projects/$(git rev-parse --show-toplevel | sed 's:/:-:g; s:^-::')/memory/"

# Open it via Claude Code:
/memory   # then click "Open auto-memory folder"
```

Compare with smartmem:

```bash
ls memory/                     # smartmem durable
ls .claude/smartmem/v1/        # smartmem hot tier
```

## Disabling Claude auto-memory project-wide

If you choose `autoMemory: off` at init, the wizard writes:

```json
// .claude/settings.json
{
  "autoMemoryEnabled": false
}
```

This stops Claude from reading or writing `~/.claude/projects/.../memory/`. smartmem continues to work normally.

## Related

- [Memory schema](03-memory-schema.md)
- [Hooks](04-hooks.md)
- [Architecture](05-architecture.md)
