# Active context

## Now
- **Sanctions vendor renewal (Apr 30).** ComplyAdvantage contract up for
  renewal end of April. Procurement asked us to evaluate switching to
  Dow Jones Risk & Compliance for sanctions+PEP. Engineering position so
  far: switching is feasible (screening-worker is vendor-agnostic by
  design, see ADR-2026-03-12) but we'd want a 6-week shadow period running
  both vendors and diffing hits before flipping primary. Decision owner:
  MLRO + Head of Procurement. Eng input due Apr 22.
- **SLA-1 trend.** Breach rate ticked from 3.1% (Feb) to 4.4% (Mar). Below
  the 5% RCA threshold but visible. Suspected cause: T1 staffing dip during
  Easter cover. Watching April numbers before raising formally.
- **EDD MLRO step UX.** MLRO has asked for a "decision rationale required ≥
  200 chars" guard on the EDD approval form. Trivial change but touches
  reviewer-visible legal copy — Legal review queued.

## Open threads
- Audit Merkle-root job has been running 4 minutes longer per week as case
  volume grows. Not yet a problem; will need to chunk the daily run before
  Q3 if the trend holds.
- Periodic review (P-3) for the PEP cohort (6m cadence) hits its first
  large batch in mid-May. Capacity plan with T2 lead pending.
- DSAR exporter still emits one CSV per PII table; DPO has asked for a
  single signed bundle. Tracked as T-104.

## Recently decided
- 2026-04-08: PEP cases never auto-pass. Hardened in DMN + BPMN linter.
- 2026-03-12: Screening worker abstracts vendor behind a `ScreeningProvider`
  interface so a vendor swap is config-only at the worker layer.
