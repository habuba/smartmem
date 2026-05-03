# Decisions (ADR-lite)

## 2026-04-22 — Tutorials require @platform-docs reviewer
Tutorials are 8% of pages but generate 34% of stale-page issues. They rot because they cross many surfaces and any one of them changing breaks the tutorial. Gating new tutorials behind a docs-team review keeps the count low and forces authors to consider how-to + explanation alternatives first.
Trade-off: slower contribution path for tutorials. Accepted; tutorials are rare by design.

## 2026-04-10 — Pin dx CLI version in package.json; fail CI on sample drift
Sample-execution CI was passing against whatever `dx` was on the runner, which drifted from what readers had installed. We now pin `dx` to a specific version in `package.json` and bump it deliberately. When the CLI ships a breaking change, the docs PR to update samples is the forcing function.
Trade-off: docs lag CLI by up to one sprint. Accepted; lag is visible and bounded.

## 2026-03-01 — Adopt Diataxis taxonomy
Contributors kept mixing how-to with reference ("here's the endpoint, and here's how to call it, and here's why we built it that way"). Pre-change DocSearch satisfaction was 41%; readers couldn't tell which pages would answer "how do I" vs "what is". Diataxis gives us four clear buckets and a rule for splitting.
Alternatives considered: a custom 3-bucket taxonomy (rejected — reinventing); no taxonomy, just better titles (rejected — didn't help in pilot).
Trade-off: ~6 months of migration work. In progress; ~60% done.

## 2025-11-12 — Docusaurus 3 over Nextra and VitePress
Docusaurus 3's MDX 3 + plugin ecosystem (Algolia, OpenAPI, versioned docs) was the only option that covered all four must-haves without custom work. Nextra was close but versioned-docs support was immature. VitePress lacked an Algolia plugin we trusted.
Revisit if: MDX 3 churn becomes painful, or Nextra ships first-class versioning.
