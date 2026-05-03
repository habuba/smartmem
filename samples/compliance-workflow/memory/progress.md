# Progress — kyc-gate

## 2026-Q1
- **Feb:** Migrated P-1, P-2, P-4 from bespoke YAML state machine to
  Camunda 7 / BPMN. P-3 (periodic review) followed in early March.
- **Feb:** Audit log redesign: hash-chained, append-only, daily Merkle
  root to WORM. Closed a 2025 FCA thematic-review finding category
  pre-emptively.
- **Mar:** `ScreeningProvider` interface landed; Refinitiv adapter added
  as fallback. Set up the platform for the Apr renewal evaluation.
- **Mar:** First quarter end with zero unaccounted cases in CRM
  reconciliation. First time since the platform launched.

## 2026-Q2 (in flight)
- **Apr:** Sanctions vendor renewal evaluation — engineering input due
  Apr 22, decision Apr 30. See active_context.
- **Apr:** "PEP never auto-pass" hardening shipped (ADR 2026-04-08).
- **May (planned):** First large PEP periodic-review batch under the new
  6-month cadence. Capacity plan in flight (T-103).

## Earlier
- **2025-Q4:** Platform launch (replacing the spreadsheet-based process)
  for individual onboarding. SMB onboarding followed in Jan 2026.
- **2025-Q3:** Project kickoff post FCA thematic review. MLRO + Eng
  agreed on the BPMN-first principle as a foundational constraint.

## Open risk items being tracked
- Audit Merkle-root job runtime trend (see T-106).
- SLA-1 March uptick (T-105) — not yet at RCA threshold.
- DSAR exporter UX gap flagged by DPO (T-104).
