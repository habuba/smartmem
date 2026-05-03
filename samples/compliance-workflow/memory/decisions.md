# Decisions (ADR-lite)

Local mirror of the ADRs that shape the platform. One-paragraph each;
full ADRs in `docs/adr/`.

## 2026-04-08 — PEP cases never auto-pass
PEP hits always route to T2 + MLRO regardless of other risk signals.
Hardened in DMN (`dmn/routing.dmn`) and enforced by a BPMN linter check
that fails CI if any path from a PEP-positive screening result reaches
`auto_pass`. Reason: regulator expectation under MLR 2017 reg. 35; also
MLRO policy. Reverses the earlier "low-exposure PEP can auto-pass on
clean adverse media" carve-out which Legal was never comfortable with.

## 2026-03-12 — Vendor abstraction in screening-worker
Introduced `ScreeningProvider` interface. ComplyAdvantage and Refinitiv
implement it; vendor selection is config per environment. Reason: the
2026 contract renewal cycle made it clear we should not be locked in,
and a future shadow-mode evaluation needs to call two vendors in
parallel without forking the worker.

## 2026-02-28 — Hash-chained append-only audit log
Replaced the prior `audit_log` table (UPDATE-able, single-row-per-case)
with `audit.events` — append-only, each row carrying
`prev_hash` + `row_hash`, with a daily Merkle root pushed to S3 Object
Lock. Reason: 2025 FCA thematic review feedback flagged "audit
mutability risk" as a finding category; pre-empting it before next cycle.

## 2026-02-20 — Adopt BPMN over custom state machine
Migrated from a bespoke YAML state machine to Camunda 7 / BPMN 2.0 for
all process definitions. Reason: regulator audits expect standardized
notation; external auditors and Compliance staff read BPMN, do not read
our YAML. Cost: one engineer for 6 weeks. Worth it on the first audit.

## 2026-01-15 — Reviewer UI is server-rendered, not SPA
Chose Flask + htmx over the team's instinct to use React. Reason:
auditability (view-source recognizability), reduced PII exposure surface
(no client-side state), and faster for the boring CRUD-shaped UI we
actually have. Revisit if reviewer workflow grows materially richer.
