---
description: Toggle concise output style. Usage — /caveman on | off | switch | status
argument-hint: on|off|switch|status
allowed-tools: Read, Edit, Bash
---

Read `.claude/smartmem/v1/config.json` field `caveman` (`caveman-plugin` | `our-concise` | `off`).

- `on` → set to user's preferred (`caveman` field of config); print install command if `caveman-plugin` is not yet installed.
- `off` → set to `off` and remove output-style activation in `.claude/settings.json`.
- `switch` → toggle between `caveman-plugin` and `our-concise`.
- `status` → print current value and which output-style file is active.

For `our-concise`, ensure `${CLAUDE_PLUGIN_ROOT}/skills/concise/SKILL.md` is referenced. For `caveman-plugin`, print:
`claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman`
