# Architecture

How smartmem itself is built.

## Plugin family

```
.claude-plugin/marketplace.json
└── 6 plugins
    ├── smartmem-core            ← the engine
    ├── smartmem-software        ← overlay: code-only libraries
    ├── smartmem-fullstack       ← overlay: frontend + backend
    ├── smartmem-business        ← overlay: non-code workflows
    ├── smartmem-data            ← overlay: data/ML projects
    └── smartmem-cli             ← overlay: CLI tools
```

Overlays depend on `smartmem-core`. Installing core alone gives you the generic base. Adding an overlay specializes a few memory files (e.g. `software` provides a software-library-tuned `system_patterns.md` and `tech_context.md`).

## smartmem-core layout

```
plugins/smartmem-core/
├── .claude-plugin/plugin.json
├── agents/                              # 5 subagents
│   ├── memory-finalizer.md              # sole writer to memory/
│   ├── task-tracker.md                  # tasks.md ops
│   ├── explorer.md                      # read-only search
│   ├── planner.md                       # implementation plans
│   └── reviewer.md                      # pre-commit review
├── hooks/                               # 6 hooks (ps1 + sh)
│   ├── hooks.json
│   ├── session-start.ps1 + .sh
│   ├── post-compact.ps1
│   ├── stop-finalize.ps1
│   ├── subagent-contract-audit.ps1
│   └── block-secrets.ps1 + .sh
├── skills/                              # 4 skills
│   ├── smartmem-init/SKILL.md           # the wizard entry
│   ├── smartmem-new-template/SKILL.md   # add a new project type
│   ├── smartmem-lang-init/SKILL.md      # install language pack
│   ├── karpathy-guidelines/SKILL.md     # behavioral
│   └── concise/SKILL.md                 # token-saving output style
├── commands/                            # 10 slash commands
│   ├── status.md / prd.md / tasks.md / process.md
│   ├── memory-sync.md / memory-rotate.md
│   ├── task.md / save-command.md
│   ├── caveman.md / project-update.md
├── language-packs/                      # 6 languages
│   ├── manifest.json
│   ├── python/{skills,tech_context.snippet.md,mcp_suggestions.md}
│   ├── typescript/...
│   └── go/ rust/ java/ csharp/
├── scripts/
│   ├── wizard.ps1 + .sh                 # template renderer
│   └── install-lang-pack.ps1 + .sh      # language pack installer
└── templates/
    ├── manifest.json                    # English base manifest
    ├── manifest_he.json                 # Hebrew base manifest
    ├── _base/...                        # English templates (18 memory + 4 docs)
    └── _base_he/...                     # Hebrew templates
```

## Wizard flow

```
/smartmem-init
       │
       ▼
   AskUserQuestion × 9
       │
       ▼
   wizard.{ps1|sh} -ConfigJson '<answers>' -Path <proj> -Overlay <type>
       │
       ├── Apply overlay manifest first      (specialized files win)
       ├── Apply base manifest (en or he)    (fills the rest as create-only)
       ├── Render {{name}}, {{description}}, {{MODEL_*}}, {{date}}, {{memoryLanguage}}
       ├── json-merge .claude/settings.json
       ├── overwrite-runtime .claude/smartmem/v1/config.json
       └── append-once .gitignore
       │
       ▼
   if user answered "install language pack now": chain into /smartmem-lang-init
       │
       ▼
   Briefing: /status, /prd, /tasks, /process
```

## Merge strategies

Each manifest entry declares one of:

| Strategy | What happens on first run | What happens on re-run |
|---|---|---|
| `create-only` | Write file | Skip (preserves user edits) |
| `prepend-once` | Write with marker block | Skip if marker present |
| `append-once` | Write with marker | Skip if marker present |
| `json-merge` | Write file | Union arrays, additive object props |
| `overwrite-runtime` | Write file | Merge: new fields added, existing kept (or replaced if `-Update`) |

All five are implemented in `wizard.ps1`. Bash port covers the same set with python helpers for json-merge.

## The single-writer invariant

A core design choice. Every subagent emits `MEMORY_NOTES:` blocks; only `memory-finalizer` actually writes to memory. This means:

- No write races between concurrent subagents.
- Memory survives context compaction (PreCompact triggers the finalizer).
- The audit trail (`event-log.jsonl`) is single-source-of-truth.
- A `SubagentStop` hook warns when an agent forgets to emit notes.

## Coexistence

smartmem coexists with:

- **caveman** (`JuliusBrussee/caveman`) — opt-in via wizard.
- **cc10x** (`romiluz13/cc10x`) — namespaced under `.claude/smartmem/`, avoids generic verbs.
- **claude-mem** — claude-mem captures session events; smartmem owns the durable schema.
- **Cline Memory Bank** — schema inspiration; we extend with hot tier + finalizer.

Nothing in smartmem touches files outside `memory/`, `docs/`, `.claude/smartmem/`, the merged `CLAUDE.md`/`.gitignore`/`.claude/settings.json`, and its own plugin directory.
