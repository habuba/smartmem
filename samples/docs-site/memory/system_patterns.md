# System patterns

## Diataxis taxonomy (mandatory)
Every page is exactly one of:
- **Overview** (`/docs/<area>/index.mdx`) — one page per top-level area, orients the reader.
- **How-to** (`/docs/how-to/<task>.mdx`) — goal-oriented, numbered steps, assumes context.
- **Reference** (`/docs/reference/<thing>.mdx`) — exhaustive, dry, table-first.
- **Explanation** (`/docs/explanation/<topic>.mdx`) — why and how-it-works, no steps.

Tutorials are a fifth type but we keep only ~6 of them, all under `/docs/get-started/`. Adding a tutorial requires sign-off because they rot fastest.

Do not blend types. If a page has both "here's how" and "here's why", split it and link.

## Runnable code samples
- All ```ts ```bash ```sh fenced blocks under `/docs/get-started/` and `/docs/how-to/` are extracted by `scripts/extract-samples.ts` and executed in CI.
- Mark non-runnable blocks explicitly: ```ts title="example, not runnable" or use ```text.
- Snippets that need fixtures live in `samples/` and are imported via the `<CodeFromFile>` MDX component. Never paste-duplicate.
- Version-pin every sample to the `dx` CLI version in `package.json`. CI fails on drift.

## Link policy
- Internal links: relative paths, no `.mdx` extension (Docusaurus rule).
- External links: prefer permalinks (commit SHA, tagged release URL, archived RFC) over `main` / `latest`.
- The nightly link checker (`lychee`) opens an issue per broken link, assigned to the page `owner:`.

## Frontmatter contract
Every MDX file requires: `title`, `description` (used by Algolia), `owner` (GitHub team handle), `last_reviewed` (ISO date). CI rejects PRs missing any of these.

## Sidebar
`sidebars.ts` is hand-curated. Order reflects reader journey, not alphabetical. Reordering requires reviewer from `@platform-docs`.
