# System requirements

## Functional
- Org signup with Clerk; first user becomes Admin; org gets a slug used for email-in routing
- Seat-based billing via Stripe Checkout + Customer Portal; seat count enforced at invite time
- Invoice ingest: PDF upload (≤25MB), email-in with attachments, manual entry
- Reducto extraction kicked off async; polling job updates `Invoice.extractedAt` and fields
- Approval chains: per-org templates, attachable to invoices by rule (vendor, amount threshold, GL code)
- Stipulation rules: boolean DSL evaluated against extracted + manual fields ("amount < 5000 AND po_match = true")
- Audit log: append-only, every state transition, exportable as CSV/JSON
- ERP sync: NetSuite (SuiteTalk REST), QBO (Intuit API); push-only in v1; failures retry with backoff
- Notifications: Slack (per-org webhook or app install), email (Resend)

## Non-functional
- **Tenancy**: row-level `orgId` scoping; cross-org access is impossible by construction
- **Auth**: Clerk; sessions in JWT; server actions verify via `auth()` from `@clerk/nextjs/server`
- **Audit retention**: 7 years; soft-archive after 2y to cold storage (S3 Glacier — post-v1)
- **Availability**: 99.9% (Vercel + Neon SLAs cover this; we add health checks)
- **Backups**: Neon PITR 30 days; nightly logical dump to S3
- **PII/PCI**: invoice PDFs may contain bank info — encrypted at rest (Neon default), access logged. No card data ever touches us (Stripe Checkout hosted)
- **Compliance roadmap**: SOC 2 Type 1 by month 6, Type 2 by month 18

## Browser support
Last 2 versions of Chrome, Edge, Safari, Firefox. No IE. Mobile Safari/Chrome supported but UI is desktop-optimized.
