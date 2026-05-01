# `/smartmem-init` wizard reference

The wizard runs the first time you invoke `/smartmem-init` in a project. Re-running is non-destructive — it only fills in new fields and never overwrites your memory or docs.

## Questions

| # | Question | Default | Notes |
|---|---|---|---|
| 1 | Project type | (none) | `software-library` / `fullstack-web` / `business-workflow` / `data-ml` / `cli-tool` / `other` |
| 2 | Project name | dir name | slug, used in CLAUDE.md and docs |
| 3 | Description | (empty) | one line |
| 4 | Model tier | `balanced` | `frugal` (all haiku) / `balanced` / `premium` |
| 5 | Hook mode | `full` | `off` / `guard` (safety only) / `full` |
| 6 | Caveman concise | `off` | `caveman-plugin` / `our-concise` / `off` |
| 7 | Memory language | `en` | `en` / `he` / other. **Recommend keeping `en` even when chatting in another language — saves 30-50% tokens.** |
| 8 | Install language pack now | `no` | If yes, runs `/smartmem-lang-init` after the wizard |
| 9 | MCP servers | (skip) | optional list |

## Model tiers

| Tier | Finalizer | Task tracker | Explorer | Planner | Reviewer | Use case |
|---|---|---|---|---|---|---|
| `frugal` | haiku | haiku | haiku | haiku | haiku | Cost-sensitive solo dev |
| `balanced` | haiku | haiku | sonnet | opus | sonnet | Most teams |
| `premium` | sonnet | sonnet | sonnet | opus | sonnet | Mission-critical, fewer LLM passes acceptable |

You can edit `.claude/smartmem/v1/config.json` later to override per-agent.

## Hook modes

| Mode | What's on | When to use |
|---|---|---|
| `off` | nothing | You want zero auto-magic; fully manual `/memory-sync` |
| `guard` | block-secrets, PreCompact only | Safety net but no auto-finalizer |
| `full` | + auto-finalizer on Stop, SessionStart briefing, SubagentStop audit, PostCompact reload | **Default**. Race-free hierarchical memory |

## Memory language

Stored as `config.json` `memoryLanguage`. Currently shipped:

- `en` — English (default; recommended)
- `he` — עברית (Hebrew)

**Why English is recommended even for Hebrew/Arabic/CJK speakers**: memory files are text Claude re-reads on every session. English is denser per token in tokenizers like Claude's. The same content in Hebrew is roughly 30-50% more tokens. Memory only needs to be human-readable enough for occasional manual review — and Claude reasons over it equally well in any language. Conversation language is independent.

To force a non-default language: pick it at init, or edit `config.json` `memoryLanguage` and re-run `/smartmem-init` (only adds missing files; existing memory stays as-is).

## Re-running

Safe at any time. The wizard:
- **Skips** every existing `memory/*.md` and `docs/*.md` (`create-only` semantics)
- **Merges** new fields into `.claude/smartmem/v1/config.json`
- **Merges** new entries into `.claude/settings.json` (union of `permissions.allow`)
- **Skips** `CLAUDE.md` if the smartmem marker block is already present
- **Skips** `.gitignore` if the smartmem marker is already present

After bumping smartmem itself (`claude plugin update smartmem-core`), use `/project-update` — it adds new template fields without re-asking already-answered questions.
