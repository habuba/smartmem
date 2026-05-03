# Active context

## Now
- Reorganizing API reference auto-generation: switching from `docusaurus-plugin-typedoc-markdown` to `@microsoft/api-extractor` + a thin MDX emitter (`scripts/gen-api-ref.ts`).
- Reason: typedoc output flattened nested namespaces and lost `@beta` tags. api-extractor preserves both and gives us a stable JSON intermediate we can lint.
- Branch: `refactor/api-ref-extractor`. Target merge: end of week. Will regenerate ~140 reference pages; review burden absorbed by `@platform-sdk`.

## Open threads
- Diataxis migration is ~60% done. Auth section (T-021) is the next big chunk; it's the most-trafficked area and the most-mixed.
- Lychee flagged 28 external links broken in the last nightly (T-024). Most are RFC drafts that moved to RFC numbers — easy fixes, batched PR coming.
- Algolia relevance is degraded for short queries ("env", "log"). DocSearch support suggested `customRanking` tweak; testing on staging crawler.
- `<CodeFromFile>` doesn't yet support line-range slicing. Authors are pasting partial snippets to work around it. Issue #312.

## Recently decided
- 2026-04-22: Block PRs that add tutorials without `@platform-docs` reviewer. Tutorials rot fastest and we already have too many.
- 2026-04-10: Pin `dx` CLI version in `package.json` and fail CI on sample drift. Closes the "docs work in dev, break in prod" gap.
- 2026-03-01: Adopt Diataxis. See decisions.md.
