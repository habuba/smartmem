---
description: Write a PRD for a feature. Usage — /prd <feature-slug> "one-line description"
argument-hint: <slug> "<description>"
allowed-tools: Read, Write, Glob
---

Write a Product Requirements Doc to `docs/prds/$1.md` for: $ARGUMENTS

Sections:
1. **Why** — problem, who's affected, current pain.
2. **What** — user-visible behavior. Bullet the must-haves vs nice-to-haves.
3. **Success criteria** — observable, testable.
4. **Out of scope** — what we explicitly will not do.
5. **Open questions** — for the user.

Read `docs/BIG_PICTURE.md` and `memory/project_brief.md` first for context. Keep <60 lines. Stop after writing — do not generate tasks yet (use `/tasks` next).

Emit `MEMORY_NOTES: PRD docs/prds/$1.md drafted`.
