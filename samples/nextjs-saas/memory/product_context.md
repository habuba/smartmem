# Product context

## Who buys
AP Manager or Controller at a 100-1000 person company. They've outgrown Bill.com's approval features, can't justify Coupa's $80k/yr floor, and currently route invoices via Outlook + a shared Excel.

## Who uses it daily
- **Submitters** (5-20 per org) — AP clerks, ops managers — upload invoices, attach POs
- **Approvers** (10-100 per org) — department heads, project managers — review queue, approve/reject with comments
- **Admins** (1-3 per org) — Controller, AP Manager — configure chains, run reports, manage seats

## Buying trigger
Usually a failed audit finding ("no audit trail on invoice approvals") or a new ERP migration where the buyer realizes their approval flow doesn't transfer.

## Pricing
Seat-based, $25/approver/mo, $10/submitter/mo, admins free. Annual billing standard. Stripe handles subscriptions; we manage seat counts via Stripe metered billing reports nightly.

## Adjacent tools customers keep
- ERP: NetSuite, QBO, Sage Intacct (we sync to first two; Intacct is on the roadmap)
- Communication: Slack (we post approval requests), Outlook/Gmail (email-in)
- Storage: NOT a doc storage replacement. Approved invoices stay in stipl for audit retention (7 years default), but customers also push to their DMS.

## Design tone
Utilitarian. AP people don't want a delightful experience; they want fewer clicks and a queue that empties. Density over whitespace. Keyboard shortcuts on every list view.
