---
description: One-screen briefing — current focus, open tasks, recent decisions.
allowed-tools: Read, Glob
---

Read these files (skip any that don't exist) and produce a tight one-screen briefing:

- `.claude/smartmem/v1/active_context.md` — current focus
- `memory/tasks.md` — open tasks (skip Done section)
- `docs/DECISIONS.md` — last 3 decisions
- `docs/CHANGELOG.md` — last 3 entries

Format: section per file with **bold** header, max 5 bullets each. End with one line: `Suggested next: <one action>`.
