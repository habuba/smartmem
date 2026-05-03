# Product context — kyc-gate

## Who uses it
- **Reviewer Team (T1)** — front-line analysts. Live in the queue UI all day.
  Need fast triage, clear decision reasons, no dead clicks.
- **Reviewer Team (T2) / EDD specialists** — handle escalations and
  high-risk geographies. Need full case history + source-of-funds evidence
  attached in one view.
- **Compliance Officer / MLRO** — final approver on EDD and PEP cases.
  Cares about defensibility: every decision must be reproducible from the
  audit log alone.
- **Customer Ops** — chase customers for missing docs, communicate decisions.
  Need pre-approved templates and a clear "what's blocking" indicator.
- **Regulator (FCA/BaFin) — indirect** — never touches the system but its
  expectations shape every design decision.

## What "good" looks like for them
- Reviewers: median case-handling time trends down quarter on quarter without
  decision quality dropping (sample QA rate ≥ 5%, error rate < 2%).
- MLRO: can answer any "show me all PEP decisions in Q1 2026 and the
  reasoning" question in < 10 minutes via the audit export.
- Customer Ops: customers do not have to resubmit the same document twice.

## What we deliberately don't do
- We don't auto-decide PEP cases, ever. Hard rule.
- We don't suggest a decision to the human reviewer (anchoring risk flagged
  by Legal). We surface evidence; the human concludes.
