# kyc-gate

KYC/AML onboarding workflow for a regulated fintech. Orchestrates customer
intake, automated screening (sanctions, PEP, adverse media), reviewer queues,
and immutable audit logging. Camunda 7 BPMN engine; Python services around it.

## Purpose
Move every onboarding case from `submitted` to `decided` within SLA, with a
defensible audit trail that survives regulator inspection.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Working rules
- This is a regulated workflow. **Every change to a BPMN flow, decision rule,
  or retention policy needs an ADR in `memory/decisions.md`** before code lands.
- Reviewer-facing strings (queue labels, decision reasons) are legally
  reviewed. Do not reword them without Legal sign-off — flag in PR description.
- Audit log is append-only. No code path may update or delete an audit row;
  corrections are new rows referencing the original `case_event_id`.
- PII fields are tagged in `schemas/pii.yaml`. Anything new touching customer
  data must update that file and the DSAR exporter in the same PR.
- SLAs in `memory/slas.md` are contractual. If a change risks breach, surface
  it in the PR body and tag Compliance Officer.
- Memory is managed by the `memory-finalizer` agent. Other agents emit
  `MEMORY_NOTES:` blocks; only the finalizer writes to `memory/*.md`.
- Before non-trivial work, read the relevant pointer file:
  - new BPMN flow → `memory/processes.md` + `memory/architecture.md`
  - vendor / screening change → `memory/decisions.md` + `memory/stakeholders.md`
  - SLA-impacting change → `memory/slas.md`
- Local dev: `make up` (Camunda + Postgres + screening mocks). Tests:
  `make test` (unit) and `make bpmn-test` (process replay against golden cases).
- Workflow for features: `/prd <slug>` → `/tasks <slug>` → `/process`.
