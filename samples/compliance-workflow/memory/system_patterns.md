# System patterns — kyc-gate

## Process patterns
- **BPMN-first.** Any new flow starts as a BPMN diagram reviewed with
  Compliance before code. Code follows the diagram, not the other way round.
- **DMN for any branching policy.** If the rule is "Compliance might want to
  change this without a deploy", it's a DMN table, not Python.
- **Service tasks are external workers.** No embedded Java delegates. Keeps
  the engine boring and lets us scale workers independently.
- **One audit row per state transition.** No "batch" audit writes.

## Engineering patterns
- **Idempotency key = `case_event_id`.** Every external call carries it;
  every evidence/audit insert deduplicates on it.
- **Server-rendered reviewer UI.** htmx partials, no client state. An auditor
  must be able to "view source" and recognize the workflow.
- **Append-only at the grant level.** The DB role used by services has
  `INSERT, SELECT` on `audit.*` and no `UPDATE/DELETE`. Enforced in CI
  against the migration baseline.
- **Two databases.** Engine DB (Camunda) and case-store DB are physically
  separate. Engine DB is treated as opaque; we never query it for reporting.

## Anti-patterns (rejected at review)
- Writing decisions from a service task. Decisions are user tasks only.
- Hand-rolled state enums in Python that mirror BPMN state. Source of truth
  is Camunda.
- "Soft delete" on audit rows. Use a correction event referencing the prior
  `case_event_id`.
- Logging full payloads. `case_id` + field-name list only.

## Naming
- BPMN files: `bpmn/<flow_slug>.bpmn`, version in the `camunda:versionTag`.
- DMN files: `dmn/<decision_slug>.dmn`.
- Service task topic names: `kyc.<flow>.<step>` (e.g. `kyc.standard.screen`).
