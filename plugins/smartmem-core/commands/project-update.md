---
description: Non-destructive re-run of smartmem init. Updates plugin and re-asks only for new wizard prompts.
allowed-tools: Read, Write, Edit, Bash, Glob
---

1. Suggest the user run `claude plugin update smartmem-core` first (we can't run it from here).
2. Diff current `.claude/smartmem/v1/config.json` against the template's expected fields. Identify any new fields added since their version.
3. For each new field, prompt the user via AskUserQuestion.
4. Re-run `${CLAUDE_PLUGIN_ROOT}/scripts/wizard.ps1 -ConfigJson '<merged>' -Path "$CLAUDE_PROJECT_DIR" -Update` — the `-Update` flag tells the wizard:
   - Never overwrite `memory/*.md`, `docs/*.md`, `CLAUDE.md`
   - Only add missing files and update `.claude/smartmem/v1/` runtime config
5. Print the change summary.

Emit `MEMORY_NOTES: smartmem upgraded to <version>`.
