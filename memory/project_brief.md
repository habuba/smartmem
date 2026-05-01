# Project brief — smartmem

**Name:** smartmem
**One-liner:** Hierarchical memory + harness initializer for Claude Code projects, distributed as a marketplace plugin family.

## What this is
A reusable bootstrapper that turns any directory into a Claude Code project with: hierarchical memory (Cline-bank schema), a single-writer `memory-finalizer` agent, compaction-survival hooks, a `/prd → /tasks → /process` workflow, and 5 project-type overlay plugins. Ships as 6 plugins under one `marketplace.json`, plus a non-marketplace clone+symlink installer.

## What it is not
- A multi-model router. We pick model tiers per role at init; we do not proxy.
- A workflow engine. Loops are recurring agents, not constrained processes (see babysitter for that).
- A replacement for cc10x or caveman — we coexist with both.
