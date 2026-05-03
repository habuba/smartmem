# SLAs — kyc-gate

These are contractual (customer-facing or regulator-facing) and drive BPMN
timer events. Breach is a first-class signal, not a dashboard metric.

## SLA-1 — Standard onboarding decision
- **Target:** ≤ 24 business hours from `case.submitted` to `case.decided`.
- **Scope:** P-1 cases not routed to EDD.
- **Measurement:** wall-clock minus weekends and published bank holidays
  (UK + DE calendars merged). "Waiting on customer" pauses the clock; this
  is the only pause state.
- **Breach behavior:** BPMN timer raises `sla1_breach`; case is reassigned
  to team-lead queue and flagged amber in reviewer UI.
- **Reporting:** monthly breach % to MLRO; > 5% triggers root-cause review.

## SLA-2 — EDD escalation decision
- **Target:** ≤ 5 business days from EDD branch entry to MLRO decision.
- **Scope:** P-2 cases.
- **Measurement:** as SLA-1, including customer-wait pause.
- **Breach behavior:** message event to MLRO direct + Compliance Officer.
  At breach + 10 business days, P-4 off-boarding is auto-triggered unless
  MLRO explicitly extends.

## SLA-3 — Regulator information request acknowledgement
- **Target:** ≤ 4 hours (clock time, 24/7) to *acknowledge*; substantive
  response per request letter terms (typically 5–10 business days).
- **Scope:** any inbound regulator request flagged via `regulator_intake`.
- **Measurement:** unconditional clock time from intake timestamp.
- **Breach behavior:** PagerDuty to MLRO + on-call engineering lead.
- **Note:** there is no "waiting on customer" concept here.

## SLA-4 — DSAR fulfilment (informational; legal floor in NFR-2)
- **Internal target:** ≤ 14 calendar days. Legal cap: 30 days (GDPR).
- **Breach behavior:** DPO notified at internal target; auto-escalation to
  MLRO if internal target + 7 days passes.
