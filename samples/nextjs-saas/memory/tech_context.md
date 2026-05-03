# Tech context

## Prerequisites
- Node 20.11+
- pnpm 9+
- Docker (for local Postgres) OR a Neon branch URL
- `.env.local` with: `DATABASE_URL`, `DIRECT_URL`, `CLERK_*`, `STRIPE_*`, `REDUCTO_API_KEY`, `RESEND_API_KEY`, `CRON_SECRET`

## Daily commands
```bash
pnpm install
pnpm dev                    # Next.js dev server, port 3000
pnpm db:up                  # docker compose up -d postgres
pnpm prisma migrate dev     # apply + generate client
pnpm prisma studio          # GUI on :5555
pnpm seed                   # tsx prisma/seed.ts — loads demo org
```

## Tests
```bash
pnpm test                   # vitest, unit + integration
pnpm test:unit              # vitest run tests/unit
pnpm test:int               # vitest run tests/integration (needs test DB)
pnpm test:e2e               # playwright test
pnpm test:e2e:ui            # playwright test --ui
```
Integration tests use a separate `stipl_test` DB; `pnpm test:int` runs `prisma migrate reset --force` against it first.

## Lint / typecheck
```bash
pnpm lint                   # eslint + the org-scope custom rule
pnpm typecheck              # tsc --noEmit, strict mode
pnpm check                  # lint + typecheck + test:unit (pre-push hook)
```

## Prisma workflow
- Schema change: edit `prisma/schema.prisma`, run `prisma migrate dev --name <slug>`
- Production deploy: CI runs `prisma migrate deploy`. Never `db push` outside `pnpm db:scratch`.
- Renames/drops: two-step migration (add new, backfill, swap, drop in next release) — never destructive in one step.

## Stripe local
```bash
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```
Copy the `whsec_...` into `STRIPE_WEBHOOK_SECRET`.

## Deploy
- Push to `main` → Vercel preview → manual promote to prod
- Migrations: GitHub Action runs `prisma migrate deploy` against prod DB BEFORE Vercel promote (gate on success)
