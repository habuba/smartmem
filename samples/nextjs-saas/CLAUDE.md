# stipl

SaaS for stipulated invoice approval workflows. Mid-market AP teams route invoices through configurable approval chains with audit trails, then sync approved batches to NetSuite/QuickBooks.

## Stack
Next.js 15 (App Router, RSC), TypeScript strict, Prisma + Postgres (Neon), Clerk auth, Stripe billing, Tailwind + Radix primitives, Playwright e2e, Vercel.

## Memory
@memory/MEMORY.md
@memory/active_context.md

Subdirectory CLAUDE.md files scope context for focused work:
- `frontend/CLAUDE.md` — App Router conventions, RSC/client boundary rules, Radix usage
- `backend/CLAUDE.md` — Prisma patterns, multi-tenant scoping, webhook idempotency

## Rules
- Server Components by default. Add `'use client'` only at the leaf where interactivity actually starts.
- Every Prisma query MUST include `orgId` in the where clause. There is no global "admin escape hatch" — use the `withOrgScope()` helper from `lib/db.ts` which enforces this at the type level.
- Stripe and Clerk webhooks are idempotent: dedupe via `WebhookEvent` table keyed on provider event id. Never trust webhook order.
- Server Actions for mutations from RSC trees. Route handlers (`app/api/**/route.ts`) only for third-party webhooks and machine-to-machine endpoints.
- Currency is stored as integer minor units (cents). Never floats. Display layer does the conversion.
- Errors: throw typed `AppError` subclasses. The root `error.tsx` boundary maps them to user-facing messages. Don't catch-and-swallow.
- Database migrations: `prisma migrate dev` locally, `prisma migrate deploy` in CI. Never `db push` against anything but a scratch DB.
- Tests: unit (Vitest) for pure logic, integration (Vitest + test DB) for queries, Playwright for critical flows (signup, invoice submit, approval, billing).
- Memory is managed by the `memory-finalizer` agent. Other agents emit `MEMORY_NOTES:` blocks; only the finalizer writes to `memory/*.md` or `docs/{DECISIONS,CHANGELOG}.md`.
- Before non-trivial changes, read the relevant memory pointer:
  - schema/migration → `memory/db_structure.md`
  - new route or page → `memory/ui_structure.md` + `memory/system_patterns.md`
  - new endpoint/action → `memory/api_surface.md`
  - architectural shift → propose ADR in `docs/DECISIONS.md`
- Workflow: `/prd <slug>` → `/tasks <slug>` → `/process`.

## Don'ts
- No client-side fetching of data we already have on the server. Pass it down.
- No `any`. If TS complains, the model is wrong, not the type.
- No new top-level dependencies without a note in `decisions.md`.
