# Decisions (ADR-lite)

Mirror of `docs/DECISIONS.md`. New entries on top.

---

## 2026-04-20 — Move from tRPC to Server Actions
**Context:** We started on tRPC (June 2025) for type-safe RPC from client components. With Next 15 stable + the React 19 `useActionState` API, Server Actions cover our needs and integrate with `revalidatePath`/`revalidateTag` natively.
**Reason:** tRPC's React Query cache layer didn't compose with Next.js fetch cache. We were maintaining two cache invalidation paths (RQ keys + Next tags). Server Actions collapse this.
**Cost:** ~3 weeks to migrate ~40 mutations. Lost: tRPC's middleware composition (replaced with a small `withOrgScope`/`withRole` action wrapper in `lib/actions.ts`).
**Status:** Adopted.

---

## 2026-04-12 — Vercel Blob over S3 for invoice PDFs (v1)
**Context:** Need durable storage for uploaded PDFs (≤25MB each, ~500GB projected at year 1).
**Reason:** Vercel Blob has zero infra. S3 needs IAM, CORS, signed-URL plumbing. At our v1 scale, Blob's pricing is within 20% of S3 + CloudFront. Re-evaluate at 100k invoices/mo or when egress bites.
**Status:** Adopted. Trigger to revisit: $X/mo blob cost OR latency p95 > 300ms on signed-URL fetches.

---

## 2026-03-30 — Use Reducto for PDF extraction; do not build in-house OCR
**Context:** Invoice extraction is the long pole of ingest. Options: AWS Textract, Google Document AI, Reducto, in-house (LayoutLM finetune).
**Reason:** Reducto's invoice-tuned model beat Textract on a 200-doc test set (94% vs 81% field-level F1). Their async webhook fits our job model. We're not an ML company; building this is months of work for parity at best.
**Cost:** $0.04/page. At 30 pages/invoice avg, $1.20/invoice ingest cost. Folded into pricing.
**Status:** Adopted.

---

## 2026-03-15 — Neon Postgres over RDS
**Context:** Need Postgres. Considered RDS, Aurora Serverless v2, Supabase, Neon.
**Reason:** Branching. Every PR gets its own DB branch via Neon's API + GitHub Action. Preview envs against branch DB = realistic e2e in CI without seeding pain. Aurora Serverless v2 cold starts were also disqualifying for our low-traffic preview envs.
**Risk:** Neon is younger than RDS. Mitigation: nightly logical dumps to S3, documented restore runbook.
**Status:** Adopted.

---

## 2026-02-28 — Clerk over Auth.js (NextAuth)
**Context:** Need auth + orgs + invitations. Clerk vs Auth.js + custom org layer vs WorkOS.
**Reason:** Clerk's Organizations primitive matches our tenancy model out of the box. Auth.js would be ~6 weeks of org/invitation/seat plumbing. WorkOS targets enterprise SSO, overkill for v1.
**Cost:** $25/mo + $0.02/MAU above 10k. Acceptable until ~50k MAU; revisit then.
**Status:** Adopted.
