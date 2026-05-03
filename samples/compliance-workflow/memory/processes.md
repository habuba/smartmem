# Processes — kyc-gate BPMN flows

All flows live in `bpmn/` as BPMN 2.0 XML. Decision tables in `dmn/`.

## P-1 Standard KYC onboarding (`bpmn/standard_kyc.bpmn`)
Submit → validate payload → automated screening (sanctions, PEP, adverse
media in parallel) → DMN routing decision → either:
  (a) auto-pass (low risk, all clean) → notify customer + downstream CRM
  (b) T1 review queue → reviewer decision → notify
Timer boundary event on the review user task fires SLA-1 breach signal at
24 business hours. Breach reroutes to a "stale case" subprocess that pages
the team lead and re-prioritizes.

## P-2 Enhanced Due Diligence (`bpmn/edd.bpmn`)
Triggered from P-1 routing when DMN flags EDD (high-risk jurisdiction, PEP
hit, declared SoW > threshold, or T1 escalation). Steps: request additional
documents → SoF/SoW analysis user task (T2) → adverse media re-run with
expanded query → MLRO approval user task → notify. Hard rule: MLRO step is
non-skippable; the BPMN has no bypass path. Timer escalation at SLA-2
(5 business days) raises a message event to MLRO directly.

## P-3 Periodic review (`bpmn/periodic_review.bpmn`)
Scheduled per risk band (low 3y, medium 2y, high 1y, PEP 6m). Triggered by
a cron-style timer start event reading the customer's `next_review_at`.
Re-runs screening only; if anything material has changed (new sanctions
hit, new adverse media, risk-band change) it forks into P-2. Otherwise
records "reviewed, no change" and resets the timer.

## P-4 Off-boarding (`bpmn/offboarding.bpmn`)
Triggered by: customer request, MLRO decision, or expiry of an unresolved
case past SLA-2 + 10 business days. Mandatory exit-reason taxonomy
(`dmn/exit_reasons.dmn`). Always emits a downstream event to `tm-engine` to
freeze transaction processing before the customer record is closed. Audit
bundle is generated and stored before the case is marked closed; this is a
service task with `asyncBefore=true` so retries are safe.

## Cross-cutting
Every flow ends with a `record_audit_bundle` service task. Cases never
"end" without one. Linter in CI rejects any BPMN missing this end task.
