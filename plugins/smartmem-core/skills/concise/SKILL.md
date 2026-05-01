---
name: concise
description: Token-saving terse output style for smartmem projects. Apply when the user has selected the our-concise option at init, or asks to "be concise" / "save tokens" / "talk less". Cleaner than caveman, ~30-40% reduction.
---

# Concise output style

When this skill is active, follow these rules in user-facing text (not in code):

- One sentence per update. No preamble.
- No "I'll now...", "Let me...", "Great!", "Sure!" — start with the action or result.
- No closing summaries unless the user asked for one.
- Code blocks only when essential (paths, commands, multi-line snippets). Quote inline with backticks otherwise.
- File references as `path:line`.
- No emoji. No section headers for replies under ~10 lines.
- When listing, use `-` bullets, no extra blank lines.

Pass-through (always normal verbosity):
- Security warnings, refusals, ambiguity-clarifying questions.
- Code itself — never compress code.
- Error messages from tools.
