# Code structure — smartmem

## Tree
```
smartmem/
├── .claude-plugin/marketplace.json       # publishes all 6 plugins
├── plugins/
│   ├── smartmem-core/                    # the engine
│   │   ├── .claude-plugin/plugin.json
│   │   ├── agents/{memory-finalizer,task-tracker,explorer,planner,reviewer}.md
│   │   ├── hooks/{hooks.json,*.ps1,*.sh}
│   │   ├── skills/{smartmem-init,smartmem-new-template,smartmem-lang-init,karpathy-guidelines,concise}/SKILL.md
│   │   ├── commands/{status,prd,tasks,process,memory-sync,memory-rotate,task,save-command,caveman,project-update}.md
│   │   ├── language-packs/{python,typescript,go,rust,java,csharp}/
│   │   │   ├── skills/<name>/SKILL.md
│   │   │   ├── tech_context.snippet.md
│   │   │   └── mcp_suggestions.md
│   │   ├── scripts/{wizard,install-lang-pack}.{ps1,sh}
│   │   └── templates/
│   │       ├── manifest.json             # English template manifest
│   │       ├── manifest_he.json          # Hebrew template manifest
│   │       ├── _base/                    # English source files
│   │       └── _base_he/                 # Hebrew source files
│   ├── smartmem-software/templates/      # overlays — each only ships the files it specializes
│   ├── smartmem-fullstack/templates/
│   ├── smartmem-business/templates/
│   ├── smartmem-data/templates/
│   └── smartmem-cli/templates/
├── scripts/
│   ├── install.ps1                       # symlink/copy installer (no marketplace)
│   └── install.sh
├── docs/
│   ├── BIG_PICTURE.md / DECISIONS.md / CHANGELOG.md / BACKLOG.md
│   ├── guide/01-09*.md                   # English docs
│   └── he/01-09*.md                      # Hebrew docs
├── memory/                               # this repo's own dogfood memory
├── .claude/smartmem/v1/                  # this repo's hot tier (gitignored runtime state)
├── CLAUDE.md
└── README.md
```

## Module boundaries
- `plugins/smartmem-core/` — generic engine. Must work for ANY project type.
- `plugins/smartmem-<overlay>/` — only contains files that specialize a single project type. Overlays MUST NOT depend on one another; each declares `dependencies: ["smartmem-core"]` only.
- `scripts/` (root) — repo-level tooling; not shipped to user projects.
- `docs/` (root) — documentation; not shipped to user projects.
- `templates/_base*/` — files copied INTO user projects. Anything here gets `{{vars}}` rendered.
- `templates/manifest*.json` — declares each template's destination + merge strategy.

## Naming conventions
- Plugins: `smartmem-<name>` (lowercase, hyphenated).
- Skills: directory `smartmem-<verb>` (or single-word for behavioral skills like `concise`).
- Commands: distinctive verbs only — never `BUILD`/`PLAN`/`REVIEW` (collides with cc10x).
- Memory files: `snake_case.md`, in the singular for nouns (`tech_context`, not `tech_contexts`).
- Hooks: `kebab-case` matching the event verb (`session-start.ps1`, `block-secrets.sh`).
- Runtime state: `.claude/smartmem/v1/` — version directory bumps if we break the schema.

## Where things live
- New memory file → add to `plugins/smartmem-core/templates/_base/memory/<file>.md` AND register in `templates/manifest.json` AND mirror to `_base_he/memory/<file>.md` AND `manifest_he.json` AND update `_base/memory/MEMORY.md` index.
- New project type → use `/smartmem-new-template`. Don't copy by hand.
- New language pack → `plugins/smartmem-core/language-packs/<lang>/{skills/,tech_context.snippet.md,mcp_suggestions.md}` and append to `language-packs/manifest.json`.
- New hook → script in `plugins/smartmem-core/hooks/<verb>.ps1` (and `.sh` if cross-platform), entry in `hooks/hooks.json`.
- New slash command → `plugins/smartmem-core/commands/<name>.md` with frontmatter.
- New documentation page → `docs/guide/NN-name.md` (English) AND `docs/he/NN-name.md` (Hebrew).
