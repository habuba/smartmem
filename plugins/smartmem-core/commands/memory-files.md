---
description: Add, remove, rename, or list memory files. Usage — /memory-files <add|remove|rename|list> [args]
argument-hint: add <name> [--always-loaded] | remove <name> | rename <old> <new> | list
allowed-tools: Read, Write, Edit, Glob, Grep
---

Manage the project's memory file set. Subcommand is `$1`. Remaining args: `$2 $3 ...`.

Canonical registry of known memory file names + purposes (use these defaults when scaffolding):
- project_brief — What this project is and why it exists.
- product_context — Users, problems being solved, success criteria.
- design_goals — Priorities and trade-off rules.
- system_requirements — FR-/NFR-.
- glossary — Project-specific terms.
- architecture — High-level system architecture.
- code_structure — Where code lives.
- system_patterns — Code conventions and recurring patterns.
- tech_context — Stack, versions, build/test commands.
- db_structure, ui_structure, api_surface — schema / routes / endpoints.
- active_context — current focus.
- tasks, progress, commands, decisions — lifecycle/operational.
- stakeholders, processes, slas — business-workflow specific.
- datasets, experiments, model_registry — data/ML specific.
A name not in this registry is fine — just use a sensible title and ask the user for the one-line purpose.

## Subcommand: list
Read `memory/MEMORY.md`. Print:
- the always-loaded set (from `## Always-loaded` section)
- the on-demand set (from `## On demand` section)
- which entries point to files that are missing on disk (warn)
Also print `.claude/smartmem/v1/config.json` `memoryFiles` and `alwaysLoaded` arrays for cross-check.

## Subcommand: add <name> [--always-loaded]
1. Refuse if `memory/<name>.md` already exists or if name contains a path separator.
2. Determine title + purpose: from the registry above if known; otherwise ask the user one short question for the purpose.
3. Write `memory/<name>.md` with:
   ```
   # <Title>
   <!-- Purpose: <purpose> -->

   ```
4. Update `memory/MEMORY.md`: add `- [<name>](<name>.md) — <purpose>` under the right section (`## Always-loaded` if `--always-loaded` was passed, else `## On demand`). Keep the file ≤200 lines.
5. Update `.claude/smartmem/v1/config.json`: append `<name>` to `memoryFiles` array; if `--always-loaded`, also append to `alwaysLoaded` and add `@memory/<name>.md` to `CLAUDE.md` between `<!-- smartmem:start -->` and `<!-- smartmem:end -->` markers (insert after the existing `@memory/...` lines).
6. Report: `added: memory/<name>.md (always-loaded: yes/no)`.

## Subcommand: remove <name>
Refuse for these never-removable names: `MEMORY` (the index itself).
1. Confirm with the user before deleting (show the file's line count + first 5 lines so they know what they're losing).
2. Delete `memory/<name>.md`.
3. Remove the entry from `memory/MEMORY.md` (both sections).
4. Remove `<name>` from `.claude/smartmem/v1/config.json` `memoryFiles` and `alwaysLoaded`.
5. Remove `@memory/<name>.md` from `CLAUDE.md` if present.
6. Report: `removed: memory/<name>.md`.

## Subcommand: rename <old> <new>
1. Refuse if `memory/<new>.md` already exists or if either name is `MEMORY`.
2. Move `memory/<old>.md` → `memory/<new>.md`.
3. Update `memory/MEMORY.md`: rewrite the entry's link + path.
4. Update `.claude/smartmem/v1/config.json`: replace `<old>` with `<new>` in both arrays.
5. Update `CLAUDE.md`: replace `@memory/<old>.md` with `@memory/<new>.md`.
6. Grep the rest of `memory/` and `docs/` for `[<old>](`/`@memory/<old>.md` and update any cross-references found. Report each rewrite.
7. Report: `renamed: <old> -> <new>`.

## Invariants (apply to every subcommand)
- Never write to memory/ outside the file you are explicitly creating/removing/renaming.
- After any change, the three sources of truth must agree: `memory/MEMORY.md` index, `.claude/smartmem/v1/config.json` `memoryFiles` array, and the actual files in `memory/`. Run a final reconciliation check; if they diverge, report the discrepancy and stop.
- Do not silently overwrite user-edited content. If a user-edited file would be touched, ask first.
