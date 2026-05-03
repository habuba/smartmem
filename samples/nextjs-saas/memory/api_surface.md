# API surface

We use **Server Actions for first-party mutations** and **route handlers only for webhooks, cron, and inbound email**. There is no public REST/tRPC API in v1; ERP sync is outbound-only.

## Server Actions (selected)

### `app/(app)/invoices/actions.ts`
- `uploadInvoice(formData)` — validates PDF, stores blob, creates `Invoice(status=ingesting)`, enqueues `extract` job. Returns `{ id }` for client redirect.
- `approveInvoice(invoiceId, { comment, stipulationsMet })` — verifies caller is current step approver, advances chain, writes `AuditLog`, fires notification. Throws `ForbiddenError` if not assigned.
- `rejectInvoice(invoiceId, { reason })` — terminates chain, status=REJECTED.
- `voidInvoice(invoiceId, { reason })` — Admin only; sets `voidedAt`, prevents further state transitions.

### `app/(app)/chains/actions.ts`
- `saveChainTemplate(input)` — upsert template. Validates rule DSL via `lib/stipulation/dsl.ts` parser before save.

### `app/(app)/settings/members/actions.ts`
- `inviteMember(email, role)` — checks seat count vs. Stripe sub, creates Clerk invitation, prepares `User` row on acceptance via Clerk webhook.

## Route handlers

### `POST /api/webhooks/stripe` — `app/api/webhooks/stripe/route.ts`
Stripe webhook. Verifies signature, dedupes via `WebhookEvent`, dispatches on `event.type`:
- `checkout.session.completed` → activate subscription, set `Org.plan`
- `customer.subscription.updated` → update plan, seat limits
- `customer.subscription.deleted` → mark org `plan=CANCELED`, downgrade access at period end
- `invoice.payment_failed` → flag org, email admin

### `POST /api/webhooks/clerk` — `app/api/webhooks/clerk/route.ts`
Clerk webhook (svix-signed). Handles `user.created` (provision `User` row + first-org logic), `user.updated`, `organizationMembership.created`.

### `POST /api/webhooks/reducto` — `app/api/webhooks/reducto/route.ts`
Reducto extraction-complete callback. Looks up invoice by job id, writes `extractedData` + `extractedAt`, enqueues `assign-chain`.

### `POST /api/inbound/email` — `app/api/inbound/email/route.ts`
Resend inbound webhook for `invoices+<orgslug>@in.stipl.app`. Resolves org by slug, treats sender as submitter (must match a known `User.email`), creates Invoice from each PDF attachment.

### `GET /api/cron/[job]` — `app/api/cron/[job]/route.ts`
Vercel Cron entry point. Validates `Authorization: Bearer ${CRON_SECRET}`. `[job]` ∈ `{ drain-jobs, erp-sync, billing-sync, audit-archive }`. Each runs a bounded batch with a per-row lock (`SELECT ... FOR UPDATE SKIP LOCKED`).

### `GET /api/health` — liveness + DB ping. Used by Vercel + uptime monitor.
