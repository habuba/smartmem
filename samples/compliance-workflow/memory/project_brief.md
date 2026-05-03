# Project brief — kyc-gate

## What
A workflow platform that takes a prospective customer from "submitted
application" to "onboarding decision" under our regulatory obligations as a
licensed e-money institution (EMI) in the EU/UK.

## Why it exists
Manual onboarding via shared spreadsheets and email could not survive the
2025 FCA thematic review. We needed:
- A single system of record for every onboarding case.
- Standardized notation so external auditors can read the flow without a tour.
- Hard SLAs with measurable breach reporting.
- Provable separation between automated decisions and human approvals.

## Scope
In: individual + SMB onboarding, periodic review, off-boarding, regulator
information requests, DSAR (GDPR Art. 15) export.
Out: transaction monitoring (separate system, `tm-engine`), card issuance,
KYB for listed corporates (handled by Operations directly with bespoke DD).

## Success measure
- 95% of standard cases decided within SLA-1 (24 business hours).
- Zero "unaccounted" cases in any month-end reconciliation against CRM.
- Clean audit on annual MLRO review (no material findings).
