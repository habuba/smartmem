# Tasks

## Open
- [ ] T-041 (2026-04-28) Cutover Stripe webhook to App Router handler; remove legacy `pages/api/stripe.ts` after 48h parity
- [ ] T-042 (2026-04-28) Add `priority Int` to `ApprovalChainTemplate`; migration + admin UI + assign-chain tiebreaker
- [ ] T-043 (2026-04-25) Money parser in `lib/reducto.ts` — handle `$ € £ ¥`, decimal/thousand separators per locale
- [ ] T-044 (2026-04-22) Pin Clerk session in Playwright via `clerk-testing-tokens`; unflake `tests/e2e/approve.spec.ts`
- [ ] T-045 (2026-04-20) QBO refresh-token race — wrap refresh in `SELECT FOR UPDATE` on `Integration` row
- [ ] T-046 (2026-04-18) `/audit` CSV export — currently loads all rows in memory; switch to streamed response
- [ ] T-047 (2026-04-15) Seat count enforcement — block `inviteMember` when active seats >= Stripe `quantity`
- [ ] T-048 (2026-04-10) Sentry source maps in CI (currently only uploaded from local builds)

## Done
- [x] T-040 (2026-04-19) Server Actions migration complete for invoices + chains routers
- [x] T-039 (2026-04-15) `withOrgScope` Prisma extension + ESLint rule blocking raw `prisma.<model>.`
- [x] T-038 (2026-04-10) Vercel Blob integration for PDF storage; signed URLs for viewer
- [x] T-037 (2026-04-05) Reducto async extraction wired up end-to-end
- [x] T-036 (2026-03-28) Clerk org provisioning via webhook; first-user-becomes-admin logic
- [x] T-035 (2026-03-20) Initial Prisma schema (Org/User/Invoice/Chain/AuditLog/Job/WebhookEvent)
- [x] T-034 (2026-03-15) Neon setup + preview branch CI integration
