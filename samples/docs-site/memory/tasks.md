# Tasks

## Open
- [ ] T-021 (2026-04-15) Migrate Auth section to Diataxis. Split `auth/guide.mdx` into how-to (token rotation, service-to-service, local dev) + explanation (trust model). Owner: @platform-identity. Blocks Q2 OKR.
- [ ] T-022 (2026-04-18) Replace typedoc with api-extractor. Branch `refactor/api-ref-extractor`. Regenerates ~140 pages. Needs reviewer from @platform-sdk.
- [ ] T-023 (2026-04-20) Add line-range support to `<CodeFromFile>` (issue #312). Authors are pasting partial snippets to work around it.
- [ ] T-024 (2026-04-25) Fix broken external links flagged by checker (28). Most are RFC draft URLs that moved to numbered RFCs. Single batched PR.
- [ ] T-025 (2026-04-28) Tune Algolia `customRanking` for short queries. Test on staging crawler first; compare top-5 satisfaction before/after.
- [ ] T-026 (2026-05-01) Audit tutorials for staleness. Anything `last_reviewed` > 120 days gets either re-verified or deprecated. Expect to drop 2 of 8.

## Done
- [x] T-020 (2026-04-10) Pin dx CLI version and add sample-drift CI check.
- [x] T-019 (2026-04-05) Frontmatter validator (owner + last_reviewed required).
- [x] T-018 (2026-03-28) Move runbooks out of Confluence into `/docs/runbooks/`.
- [x] T-017 (2026-03-15) Initial Diataxis split of CLI section (pilot for the rest).
