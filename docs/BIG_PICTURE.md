# smartmem — big picture

## Goal
Make every new Claude Code project start with smart, hierarchical, self-maintaining memory and a sensible harness — without the user having to design any of it. One command (`/smartmem-init`) gets a project from empty to fully-instrumented in <60 seconds.

## Constraints
- Must coexist with cc10x, caveman, and any other Claude Code plugin without namespace collisions.
- Must be non-destructive on existing projects: never overwrite user-edited memory or docs.
- Must work offline (clone+install fallback).
- Must work on Windows (PowerShell) and Unix (bash) equally.

## Non-goals
- Multi-model API routing.
- Workflow constraint engine.
- Vendoring caveman or cline-memory-bank — we cite and integrate.

## Architecture in one paragraph
A marketplace family of 6 plugins. `smartmem-core` ships the memory-finalizer agent (sole writer to memory/), 5 other agents (task-tracker, explorer, planner, reviewer + the finalizer itself), 4 skills (smartmem-init wizard entry, smartmem-new-template meta-skill, karpathy-guidelines behavioral, concise output style), 10 slash commands (prd/tasks/process workflow + memory-sync/rotate + status/task/save-command/caveman/project-update), 6 hooks (SessionStart briefing, PreCompact finalizer, PostCompact reload, Stop finalizer trigger, SubagentStop contract audit, PreToolUse secret blocker), and templates with declarative merge strategies. Five overlay plugins extend templates per project type. Distribution via `claude plugin marketplace add` or via `scripts/install.{ps1,sh}` symlink fallback.

## The single most important invariant
**Only `memory-finalizer` writes to project memory.** Every other agent emits `MEMORY_NOTES:` blocks. This is what makes hierarchical memory race-free across subagents and survivable across compaction.
