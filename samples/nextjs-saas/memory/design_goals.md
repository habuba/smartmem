# Design goals

## Correctness over cleverness
Approval state is the product. A wrongly-approved invoice is worse than a slow one. Every state transition is logged in `AuditLog` with actor, timestamp, before/after. No soft-deletes on financial entities — use `voidedAt` + reason.

## Multi-tenant isolation is a property, not a feature
Every row in every business table carries `orgId`. The `withOrgScope()` Prisma extension makes it a type error to query without one. Periodic CI test scans the codebase for raw `prisma.invoice.findMany` (without scope) and fails the build.

## RSC-first
Default to Server Components. The mental model is: data lives on the server, components render where they're cheapest. Client components are leaf-level and exist only when there's local state or browser APIs in play.

## Idempotency everywhere external touches us
Stripe webhook, Clerk webhook, email-in, ERP sync callbacks — all dedupe on a provider-supplied event id stored in `WebhookEvent`. Replays are safe.

## Small, boring stack
Postgres for everything (no Redis until we measure a need). Next.js handles the worker queue via Vercel Cron + a `jobs` table polled from a route handler. We'll add a real queue when we hit the wall, not before.

## Observability before scale
Every server action and webhook is wrapped in a span (Sentry + OpenTelemetry). Log structured JSON with `orgId`, `userId`, `traceId`. We can answer "why was this invoice stuck for 3 hours" in <2 minutes.

## Performance budget
- TTFB on `/dashboard` p95 < 400ms (RSC + Postgres co-located in Vercel/Neon us-east)
- LCP on `/dashboard` p95 < 1.8s
- Approval action round-trip p95 < 600ms (server action + revalidate)
