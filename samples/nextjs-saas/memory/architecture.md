# Architecture

## Topology
```
[Browser] --HTTPS--> [Vercel Edge]
                          |
                          v
                  [Next.js 15 App]  (Vercel, us-east-1, Node runtime for DB-touching routes)
                  /     |        \
            [Neon PG]  [Clerk]  [Stripe]
                |
        [Reducto API]  (PDF extraction, async)
        [NetSuite/QBO] (ERP sync, async via cron)
        [Resend]       (email)
        [Slack]        (per-org webhooks)
```

## Runtime layers
1. **Edge** — middleware only (Clerk session check, org-slug resolution, redirects). No DB.
2. **Node (RSC)** — page rendering, server actions, route handlers. All DB access lives here.
3. **Cron worker** — `app/api/cron/[job]/route.ts`, invoked by Vercel Cron, protected by `CRON_SECRET`. Drains the `Job` table.

## Data flow: invoice approval
1. Submitter uploads PDF → server action stores blob in Vercel Blob, creates `Invoice(status=ingesting)`, enqueues `extract` job
2. Cron picks up `extract` → calls Reducto, updates `Invoice` with extracted fields → enqueues `assign-chain`
3. `assign-chain` matches an `ApprovalChainTemplate` by rule, creates `ApprovalChain` instance with steps → status=pending
4. First approver notified (Slack + email). On approve, advance step; on reject, terminate chain, status=rejected
5. Final approval → enqueue `erp-sync`. On success, status=synced. On failure, status=sync_failed (retried up to 5x).

## Single-writer rule for memory
Same as smartmem core: only `memory-finalizer` writes `memory/*.md`. Other agents emit `MEMORY_NOTES:` blocks consumed by the finalizer at session end / pre-compact.

## Failure domains
- Neon down → app degraded to read-only via `DB_READONLY` flag (manual flip)
- Reducto down → invoices stay in `ingesting`; surface banner; resume on recovery
- Stripe down → checkout disabled; existing subs unaffected
- ERP down → sync queue backs up; retry with exponential backoff up to 24h, then alert
