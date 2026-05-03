# Tech context — kyc-gate

## Stack
- Python 3.12, FastAPI (intake), Flask + htmx (reviewer UI).
- Camunda 7.21 self-hosted (Docker). Engine on Postgres 15.
- Case-store on Postgres 15 (separate cluster).
- Object store: S3 (with Object Lock for audit WORM).
- Secrets: AWS Secrets Manager. KMS for per-tenant KEKs.
- Vendors: ComplyAdvantage (sanctions/PEP/adverse media — see active_context
  for renewal status), Refinitiv WorldCheck (fallback only).

## Local dev
- `make up` — brings up Camunda, both Postgres clusters, screening mocks,
  intake-api, reviewer-ui. Uses `docker-compose.dev.yml`.
- `make seed` — loads three golden cases (clean, PEP hit, EDD path).
- `make bpmn-deploy` — deploys all `bpmn/` and `dmn/` files to local Camunda.

## Tests
- `make test` — pytest unit + integration. Integration tests run against
  the dev compose stack with screening mocks.
- `make bpmn-test` — process replay: 40 golden cases checked into
  `tests/golden/`. Each case has expected end state + expected audit row
  hash. CI fails on any drift.
- `make lint-bpmn` — checks every BPMN ends in `record_audit_bundle`,
  every user task has a candidate group, every timer has a documented SLA.

## CI gates
- BPMN linter, DMN linter, schema-drift check (`schemas/pii.yaml` vs DB
  columns), audit-grant check (no `UPDATE`/`DELETE` on `audit.*`).
- Migration review: any change touching `audit.*` requires Compliance review
  approval label, enforced via CODEOWNERS.

## Observability
- Structured logs (JSON), `case_id` only — never PII.
- Metrics: per-flow throughput, per-SLA breach counter, vendor latency.
- Alert: any audit-chain hash mismatch = Sev-1, MLRO + on-call paged.
