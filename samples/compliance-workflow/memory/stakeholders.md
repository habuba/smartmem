# Stakeholders — kyc-gate

## Compliance Officer / MLRO (final approver)
- Owns: regulatory relationship, suspicious activity reporting, EDD sign-off.
- Cares about: defensibility, completeness of audit, named accountability on
  every decision. Will personally read the audit export of any case the
  regulator queries.
- Escalation: any policy ambiguity, any PEP case, any "should we exit this
  customer" question.
- Don't: ship policy-affecting changes without their written approval.

## Reviewer Team — Tier 1 (Customer Ops aligned)
- ~12 analysts. Handle the standard-risk queue.
- Cares about: queue clarity, no rework, decision-reason picklist that maps
  cleanly to letter templates.
- Escalation up to T2 when: hits on adverse media, mismatched address vs ID,
  source-of-wealth implausibility for declared income.

## Reviewer Team — Tier 2 / EDD specialists
- 3 senior analysts. Handle EDD, PEP-adjacent, high-risk geographies.
- Cares about: full case timeline, attached evidence, ability to request
  further documents without losing case state.
- Escalation up to MLRO for final sign-off on EDD and any adverse decision
  involving a PEP or sanctioned-adjacent party.

## Customer Operations
- Front door for the customer. Sends document requests, communicates outcomes.
- Cares about: pre-approved templated comms (Legal-reviewed), a single
  "what's blocking this case" indicator per case.

## Legal
- Owns: customer-facing wording (decision letters, document request emails),
  privacy notice, DPIA. Reviews any change to reviewer-visible text.
- Escalation: novel data-sharing requests, cross-border transfer questions.

## Engineering (this team)
- Owns: platform, BPMN models, integrations, on-call.
- Does NOT own: policy. We implement what Compliance + Legal define.
- Escalation: SLA breach trend, vendor outage, audit integrity alarm.
