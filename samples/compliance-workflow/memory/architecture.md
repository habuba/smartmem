# Architecture — kyc-gate

## One-line shape
Intake → automated screening (parallel) → DMN routing → reviewer queue (or
auto-pass) → decision → audit bundle → downstream notify.

## Components
- **intake-api** (Python/FastAPI) — REST + SFTP ingestion. Validates payload
  against `schemas/onboarding.v3.json`. Emits `case.submitted` to Camunda.
- **Camunda 7** (self-hosted) — BPMN runtime, owner of process state.
  Workflow definitions versioned under `bpmn/`. Engine DB is Postgres,
  isolated from the case-store DB.
- **screening-worker** (Python, Camunda external task) — calls vendor APIs:
  ComplyAdvantage (incumbent, see active_context), Dow Jones (PEP), Refinitiv
  WorldCheck (fallback). Each result stored as an evidence row keyed by
  `case_event_id`; idempotent on retry.
- **case-store** (Postgres) — case header + evidence + decisions. Field-level
  encryption on PII columns via pgcrypto with per-tenant KEKs in AWS KMS.
- **audit-log** (Postgres, separate schema, append-only grants) —
  hash-chained event rows. Daily Merkle root written to S3 Object Lock
  (WORM) bucket `kyc-gate-audit-worm`.
- **reviewer-ui** (Python/Flask + htmx) — server-rendered. Reads case-store,
  claims user tasks via Camunda REST. No client-side state.
- **notify-worker** — outbound email (decision letters, doc requests) and
  internal events to `tm-engine` and CRM. Templates owned by Legal, stored
  in `templates/` and rendered with strict allow-list of variables.

## Data flow guarantees
- Every state transition writes one audit row before acknowledging the
  caller. Service tasks are `asyncBefore=true` so the audit write and the
  Camunda commit happen in the same transaction boundary (Camunda's
  job-executor pattern).
- Vendor calls are idempotent on `case_event_id`; results are deduped on
  insert into the evidence table.

## Boundary
Upstream: public web app, partner SFTP. Downstream: `tm-engine` (transaction
monitoring), CRM (Salesforce), customer email via SES.
