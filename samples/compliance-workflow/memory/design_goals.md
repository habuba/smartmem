# Design goals — kyc-gate

## Non-negotiable
1. **Auditability over cleverness.** A junior auditor with no system access
   must be able to reconstruct any decision from the audit export alone.
   Optimizations that obscure the trail are rejected on principle.
2. **Standard notation.** BPMN 2.0 for processes, DMN for decision tables.
   No bespoke YAML state machines, no code-as-flow. Regulators read BPMN.
3. **Human-in-the-loop for any adverse decision.** Automated screening can
   *flag* and *enrich*, never *reject*.
4. **Append-only audit.** Corrections are new events. No `UPDATE` on the
   audit table; enforced at DB grant level.
5. **PII minimization in logs.** Application logs carry `case_id` only.
   PII lives in the case store with field-level encryption.

## Strong preferences
- Idempotent service tasks — every BPMN service task must tolerate replay
  with the same `case_event_id`. Camunda retries are real.
- Time-based SLA breach is a first-class signal, not a report. Breach raises
  a BPMN message event that reroutes the case.
- Reviewer UI is boring on purpose. Plain server-rendered HTML over htmx;
  no SPA. Auditors should be able to view source.

## Explicitly out of scope
- ML-based risk scoring inside the decision path. We will surface vendor
  scores as evidence but will not train our own classifier into the flow.
