# Commands cheatsheet

## Setup
```bash
pnpm install
cp .env.example .env.local            # then fill in secrets
pnpm db:up                            # docker compose up -d postgres
pnpm prisma migrate dev
pnpm seed                             # demo org + sample invoices
```

## Daily dev
```bash
pnpm dev                              # Next.js on :3000
pnpm prisma studio                    # DB GUI on :5555
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```

## Tests
```bash
pnpm test                             # all vitest
pnpm test:unit
pnpm test:int                         # resets test DB first
pnpm test:e2e
pnpm test:e2e:ui                      # playwright --ui
pnpm test -- --filter <pattern>
```

## DB
```bash
pnpm prisma migrate dev --name <slug>
pnpm prisma migrate deploy            # CI uses this against prod
pnpm prisma migrate reset             # local only; nukes data
pnpm prisma generate                  # after schema changes
pnpm db:scratch                       # ephemeral DB for prisma db push experiments
```

## Lint / typecheck
```bash
pnpm lint
pnpm lint:fix
pnpm typecheck
pnpm check                            # lint + typecheck + test:unit (pre-push)
```

## Build / deploy
```bash
pnpm build                            # next build
pnpm start                            # next start (prod-mode local)
vercel                                # preview deploy
vercel --prod                         # NOT USED — use GH Actions promote workflow
```

## Useful one-liners
```bash
pnpm tsx scripts/replay-webhook.ts <eventId>   # replay a stored Stripe event
pnpm tsx scripts/recompute-chain.ts <invoiceId> # re-run assign-chain logic
pnpm tsx scripts/export-audit.ts <orgId> <from> <to> > audit.csv
```
