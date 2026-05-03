# dx-docs

Internal developer platform documentation site. Docusaurus 3 + MDX, Algolia DocSearch, deployed on Vercel via GitHub PR workflow. Audience: ~400 internal engineers across 12 product teams.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md
@memory/tasks.md

## Working rules
- Writing style is enforced (see `memory/design_goals.md`). When in doubt: accuracy > brevity > consistency > completeness.
- Every code sample in `/docs/**/*.mdx` must compile and run in CI. Don't add untested snippets.
- Diataxis taxonomy is mandatory: every page is exactly one of overview / how-to / reference / explanation. Don't blend.
- External links are checked nightly. If you add a link, prefer permalinks (commit SHA, versioned doc URL) over `main` or latest.
- Memory writes go through the `memory-finalizer` agent only. Other agents emit `MEMORY_NOTES:` blocks.
- Sidebar order is hand-curated in `sidebars.ts` — alphabetical sorting will break IA. Don't auto-sort.
- API reference under `/docs/reference/api/` is generated. Don't hand-edit; edit the source TSDoc instead.
- For non-trivial IA changes, read `memory/system_patterns.md` first and open an ADR in `memory/decisions.md`.
- Workflow: `/prd <slug>` for new doc sections, `/tasks <slug>` to break down, `/process` to execute.
