# Commands — kyc-gate

## Local dev
- `make up` — start full dev stack (Camunda, Postgres x2, screening mocks,
  intake-api, reviewer-ui).
- `make down` — stop and remove containers; volumes preserved.
- `make nuke` — `down` + drop volumes. Use when migrations get tangled.
- `make seed` — load the three golden cases (clean / PEP / EDD).
- `make bpmn-deploy` — deploy `bpmn/` and `dmn/` to local Camunda.

## Tests
- `make test` — unit + integration (pytest).
- `make bpmn-test` — process replay against `tests/golden/`.
- `make lint-bpmn` — BPMN/DMN structural lints.
- `make lint-pii` — checks `schemas/pii.yaml` against live DB columns.
- `make audit-grants-check` — verifies the audit DB role has no
  `UPDATE`/`DELETE` privileges.

## Operations (read-only, safe to run in any env)
- `bin/case-show <case_id>` — print case header + state + last 20 audit
  events. Redacts PII unless `--unredact` is passed (logged + alerts DPO).
- `bin/audit-verify <case_id>` — recomputes the hash chain for a case and
  reports any break.
- `bin/sla-report <YYYY-MM>` — monthly SLA breach breakdown for MLRO pack.

## Operations (privileged, MLRO approval required)
- `bin/dsar-export <subject_id>` — produces the signed DSAR bundle. Logs
  the requesting operator into `audit.privileged_actions`.
- `bin/regulator-bundle <case_id>` — produces the regulator-ready PDF + JSON
  audit export. Same logging.
