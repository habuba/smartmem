# Active context

## Now
- Migrating Stripe webhook handler from a legacy `pages/api/stripe.ts` (left over from the Next 13 days) to `app/api/webhooks/stripe/route.ts`. The legacy handler is still live behind a feature flag (`STRIPE_WEBHOOK_NEXT=true` routes to new). Cutover planned this week once we've seen 48h of dual-receive parity in logs.
- Side-effect of the migration: the new handler uses `headers()` from `next/headers` and the raw body via `req.text()`. Verified signature parity with `stripe.webhooks.constructEvent`.

## Open threads
- `assign-chain` job picks the wrong template when multiple rules match. Need a priority/specificity tiebreaker. Current behavior: first-match by `createdAt`. Proposed: explicit `priority Int` on `ApprovalChainTemplate`, ties broken by specificity (more clauses = higher).
- Reducto occasionally returns `amount` as a string with currency symbol embedded. Parser in `lib/reducto.ts` strips `$` but not `€`/`£`. Need a proper money parser.
- Playwright e2e flakes on the approve flow when Clerk's test mode rotates the session mid-test. Looking at pinning the session via `clerk-testing-tokens`.
- QBO sync token expiry handling is naive — we refresh on 401 but don't persist the new refresh token atomically. Race possible if two cron runs overlap. Adding a `SELECT ... FOR UPDATE` on the integration row.

## Recently decided
- 2026-04-20: Move all mutations from tRPC to Server Actions. See decisions.md.
- 2026-04-12: Adopt Vercel Blob over S3 for invoice PDFs (v1). Re-evaluate at 100k invoices/mo.
- 2026-03-30: Reducto over in-house OCR. We're not an ML company.
- 2026-03-15: Neon over RDS. Branching for preview envs is the killer feature.
