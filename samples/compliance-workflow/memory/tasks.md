# Tasks

## Open
- [ ] T-101 (2026-04-10) Shadow-mode harness for Dow Jones screening alongside
      ComplyAdvantage; diff report into reviewer UI debug pane (gated by
      vendor evaluation outcome — see active_context)
- [ ] T-102 (2026-04-09) Add 200-char minimum on EDD MLRO decision rationale;
      Legal-review the helper text before merge
- [ ] T-103 (2026-04-08) Capacity plan with T2 lead for May PEP periodic-review
      batch (P-3); produce a sizing memo for MLRO
- [ ] T-104 (2026-04-05) DSAR exporter v2: single signed bundle (PDF + JSON)
      replacing per-table CSVs; DPO sign-off required
- [ ] T-105 (2026-04-03) Investigate SLA-1 March uptick (3.1% → 4.4%);
      decompose by reviewer, geography, time-of-day
- [ ] T-106 (2026-03-28) Chunk audit Merkle-root job; current runtime trend
      will breach the 30-min nightly window by Q3 at projected case volume

## Done
- [x] T-100 (2026-04-08) Harden "no auto-pass for PEP" in DMN + BPMN linter
      check; backed by ADR 2026-04-08
- [x] T-099 (2026-03-12) Introduce `ScreeningProvider` interface in
      screening-worker; ComplyAdvantage and Refinitiv adapters
- [x] T-098 (2026-02-28) Migrate audit schema to hash-chained rows with
      daily Merkle root to WORM bucket
- [x] T-097 (2026-02-20) Replace bespoke YAML state machine with Camunda 7;
      first three flows (P-1, P-2, P-4) migrated
