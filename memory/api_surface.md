# API surface — smartmem

**N/A** — smartmem exposes no programmatic API. The "interfaces" are:

- **Slash commands** (10) — see `plugins/smartmem-core/commands/`.
- **Skills** (5) — see `plugins/smartmem-core/skills/`. Routed by description matching.
- **Subagents** (5) — see `plugins/smartmem-core/agents/`. Routed by description.
- **Hooks** (6) — see `plugins/smartmem-core/hooks/hooks.json`.
- **Wizard CLI** — `wizard.ps1` / `wizard.sh` accept `-ConfigJson` / `--config`, `-Path` / `--path`, `-Overlay` / `--overlay`, `-Update` / `--update`. Documented at `docs/guide/02-wizard.md`.
- **Lang-pack installer CLI** — `install-lang-pack.ps1` / `.sh` accept `-Lang`/`--lang`, `-Path`/`--path`, `-WithMcp`/`--with-mcp`.

The wizard JSON config schema is the closest thing to a public API:

```json
{
  "name": "<slug>",
  "type": "software-library | fullstack-web | business-workflow | data-ml | cli-tool",
  "description": "<one line>",
  "modelTier": "frugal | balanced | premium",
  "hookMode": "off | guard | full",
  "caveman": "off | caveman-plugin | our-concise",
  "memoryLanguage": "en | he",
  "autoMemory": "keep | off | mirror"
}
```

Breaking changes to this schema require a major version bump.
