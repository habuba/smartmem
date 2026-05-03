# DB structure

Postgres via Neon. Prisma 5.x. All tenant tables include `orgId` (FK to `Org.id`) and a composite index on `(orgId, createdAt)`.

## Key tables (highlights)

### Org
```
id            String   @id @default(cuid())
slug          String   @unique          // used in email-in: invoices+<slug>@in.stipl.app
name          String
stripeCustId  String?  @unique
plan          Plan     @default(TRIAL)  // enum: TRIAL, STARTER, GROWTH
createdAt     DateTime @default(now())
deletedAt     DateTime?                  // soft-delete on org only
```

### User
```
id          String   @id @default(cuid())
clerkId     String   @unique
email       String
orgId       String                       // primary org; multi-org via Membership
role        Role     @default(SUBMITTER) // SUBMITTER, APPROVER, ADMIN
createdAt   DateTime @default(now())
@@index([orgId, role])
```

### Invoice
```
id            String        @id @default(cuid())
orgId         String
vendorId      String?
amountCents   Int                       // never float
currency      String        @default("USD")
status        InvoiceStatus              // INGESTING, PENDING, APPROVED, REJECTED, SYNCED, SYNC_FAILED, VOIDED
pdfUrl        String                     // Vercel Blob URL
extractedAt   DateTime?
extractedData Json?                      // raw Reducto output
chainId       String?                    // current ApprovalChain instance
voidedAt      DateTime?
voidReason    String?
createdAt     DateTime      @default(now())
@@index([orgId, status, createdAt])
```

### ApprovalChain (instance, one per invoice)
```
id           String   @id @default(cuid())
orgId        String
invoiceId    String   @unique
templateId   String                       // FK ApprovalChainTemplate
currentStep  Int      @default(0)
steps        Json                         // [{order, approverId, status, decidedAt, comment, stipulations[]}]
status       ChainStatus                  // PENDING, APPROVED, REJECTED
@@index([orgId, status])
```

### AuditLog (append-only)
```
id         BigInt   @id @default(autoincrement())
orgId      String
actorId    String?                       // null = system
entity     String                        // "invoice", "chain", "user", ...
entityId   String
action     String                        // "approve", "reject", "void", "rule_match", ...
before     Json?
after      Json?
createdAt  DateTime @default(now())
@@index([orgId, entity, entityId])
@@index([orgId, createdAt])
```
No UPDATE or DELETE permitted on `AuditLog` — enforced by a Postgres trigger.

### Supporting
- `WebhookEvent(provider, eventId, receivedAt)` — idempotency dedupe, unique on `(provider, eventId)`
- `Job(type, payload, runAt, attempts, lockedAt, status)` — drained by cron route handler
- `Membership(userId, orgId, role)` — for users in multiple orgs (post-v1)

## Migration strategy
- One migration per PR, named with verb-noun (`add_invoice_voided_at`)
- Destructive migrations are two-PR: PR 1 adds + dual-writes; PR 2 drops after one prod release
- `prisma migrate diff` in CI compares branch schema to prod for review
