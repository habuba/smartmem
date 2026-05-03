# Code structure

```
stipl/
├── app/                          # Next.js App Router
│   ├── (marketing)/              # public site, no auth
│   │   ├── page.tsx
│   │   └── pricing/page.tsx
│   ├── (app)/                    # authenticated app, Clerk middleware
│   │   ├── dashboard/page.tsx
│   │   ├── invoices/
│   │   │   ├── page.tsx          # list (RSC + filter via searchParams)
│   │   │   ├── [id]/page.tsx     # detail
│   │   │   └── new/page.tsx      # upload
│   │   ├── chains/
│   │   ├── settings/
│   │   │   ├── billing/page.tsx
│   │   │   ├── members/page.tsx
│   │   │   └── integrations/page.tsx
│   │   └── layout.tsx            # org switcher, nav
│   ├── api/
│   │   ├── webhooks/
│   │   │   ├── stripe/route.ts
│   │   │   ├── clerk/route.ts
│   │   │   └── reducto/route.ts
│   │   ├── cron/[job]/route.ts
│   │   └── inbound/email/route.ts  # Resend inbound
│   └── error.tsx                 # root error boundary
├── components/
│   ├── ui/                       # Radix-based primitives (Button, Dialog, ...)
│   ├── invoices/                 # InvoiceList, InvoiceCard, ApprovalActions
│   ├── chains/
│   └── shared/                   # OrgSwitcher, NavBar, EmptyState
├── lib/
│   ├── db.ts                     # Prisma client + withOrgScope extension
│   ├── auth.ts                   # Clerk wrappers, requireOrg()
│   ├── stripe.ts
│   ├── reducto.ts
│   ├── erp/{netsuite,qbo}.ts
│   ├── jobs.ts                   # enqueue, drain
│   ├── errors.ts                 # AppError hierarchy
│   └── stipulation/dsl.ts        # rule parser + evaluator
├── prisma/
│   ├── schema.prisma
│   └── migrations/
├── tests/
│   ├── unit/                     # Vitest
│   ├── integration/              # Vitest + test DB
│   └── e2e/                      # Playwright
├── frontend/CLAUDE.md            # scoped context for /app and /components
├── backend/CLAUDE.md             # scoped context for /lib, /prisma, /app/api
└── memory/                       # smartmem
```

Notes:
- `(marketing)` and `(app)` are route groups — different layouts, no URL impact
- `lib/` is the only place that imports `@prisma/client` directly. Consumers go through helpers
- No `pages/` dir. App Router only.
