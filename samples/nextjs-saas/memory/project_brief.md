# Project brief

## What
stipl is a B2B SaaS that routes supplier invoices through configurable approval chains. Customers upload PDFs (or pull from email/Bill.com), reviewers stipulate conditions ("approved if PO matches"), the chain enforces ordering and SLAs, and approved batches sync to the customer's GL (NetSuite, QuickBooks Online).

## Why this exists
Mid-market AP teams (50-500 invoices/week) live in spreadsheet + email approval flows. Bill.com handles small businesses; Coupa/Tipalti target enterprise. The 50-500/week segment overpays for Coupa or duct-tapes Bill.com. stipl targets that gap.

## Scope (v1)
- Org signup, seat-based billing
- Invoice ingest: manual upload, email-in (`invoices+<orgslug>@in.stipl.app`)
- Approval chains: ordered or parallel, with stipulation rules (boolean conditions on extracted fields)
- Audit log (immutable, exportable for SOX)
- NetSuite + QBO sync (one-way push)
- Slack + email notifications

## Out of scope (v1)
- OCR/extraction in-house (we use Reducto API)
- Payment execution (we approve, customer pays via their bank/Bill.com)
- Mobile app (responsive web only)
- SSO beyond Clerk's built-in (no custom SAML in v1)

## Success metric
Time-to-approval for an average invoice drops from "days" (email) to "<4 business hours" within 30 days of customer onboarding.
