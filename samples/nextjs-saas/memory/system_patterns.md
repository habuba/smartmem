# System patterns

## Server-component-first
Every page and layout is an RSC by default. Data is fetched in the page/layout and passed down. We `'use client'` only at the leaf where we need: state, effects, refs, browser-only APIs, or event handlers that aren't a form action.

Boundary checklist when introducing a client component:
1. Can this be a Server Action invoked from a `<form>` instead? If yes, do that.
2. Does it need React state? Confirm the state can't live in URL searchParams (RSC-friendly).
3. Keep the client component small. Pass server-rendered children through it (composition pattern) rather than dragging more code client-side.

## Multi-tenant scoping rule
**Every Prisma call MUST be scoped by `orgId`.** Enforced three ways:
1. `lib/db.ts` exports `db = prisma.$extends(withOrgScope)` — the extension requires `orgId` for read/write on all tenant tables, at the type level.
2. Server actions and route handlers start with `const { orgId } = await requireOrg()` from `lib/auth.ts`. No `orgId`, no query.
3. CI lint rule (`scripts/check-org-scope.ts`) greps for `prisma.<model>.` direct usage outside `lib/db.ts` and fails the build.

## Server Actions for mutations
Mutations from RSC trees use Server Actions (`'use server'` functions co-located with the component or in `app/<route>/actions.ts`). They call `revalidatePath` / `revalidateTag` on success. Route handlers exist only for: third-party webhooks, cron, inbound email, and the rare M2M API.

## Error boundaries
- `app/error.tsx` — root boundary. Catches uncaught errors, shows generic UI, reports to Sentry.
- `app/(app)/error.tsx` — authenticated boundary. Same, but with nav still rendered.
- Throw `AppError` subclasses (`NotFoundError`, `ForbiddenError`, `ValidationError`, `IntegrationError`). The boundary maps class → message.
- `notFound()` from Next is used for 404s; don't throw `NotFoundError` for missing routes.

## Idempotency
Webhooks: on receipt, `INSERT INTO webhook_event (provider, event_id) ON CONFLICT DO NOTHING RETURNING *`. If RETURNING is empty, we've seen it — return 200 immediately.

Server Actions that hit external APIs accept an optional `idempotencyKey` and pass it through (Stripe supports this natively; for others we maintain a local dedupe table).

## Money
`Int` cents in DB. `Money` value object in app code (`{ amount: number, currency: string }`). Format only at the render boundary using `Intl.NumberFormat`.

## Naming
- Server-only modules end in `.server.ts` when ambiguous
- Server Actions: verb-first (`approveInvoice`, `voidInvoice`)
- Prisma models: PascalCase singular (`Invoice`, not `Invoices`)
