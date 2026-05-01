---
description: Quick task ops — /task add "desc" | /task done T-007 | /task block T-008 "reason" | /task list
argument-hint: add|done|block|unblock|list ...
allowed-tools: Read, Edit
---

Route to the `task-tracker` agent with operation `$1` and remaining args `${@:2}`. Print its one-line confirmation.
