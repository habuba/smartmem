# System requirements — kyc-gate

## Functional
- **FR-1** Accept onboarding submissions via REST from the public web app and
  via SFTP batch from partner channels (white-label).
- **FR-2** Run automated screening on every case: sanctions (OFAC, EU, UK,
  UN), PEP, adverse media. Results persisted as evidence, not decisions.
- **FR-3** Route cases to one of: auto-pass (low risk + clean screening),
  T1 review, T2/EDD review. Routing rules expressed in DMN.
- **FR-4** Support an Enhanced Due Diligence (EDD) branch with source-of-funds
  evidence collection and MLRO sign-off.
- **FR-5** Periodic review: re-screen every active customer per their risk
  band cadence (low: 3y, medium: 2y, high: 1y, PEP: 6m).
- **FR-6** Off-boarding flow with mandatory exit reason taxonomy.
- **FR-7** Produce an immutable audit trail per case, exportable as a signed
  PDF + JSON bundle for regulator requests.
- **FR-8** GDPR DSAR (Art. 15) export of all PII for a given subject.
- **FR-9** Regulator information request workflow with 4h acknowledgement
  SLA (see SLA-3).

## Non-functional
- **NFR-1 Retention** Case data retained 7 years post off-boarding (UK MLR
  2017, reg. 40). Hard delete only after retention expiry + DPO sign-off.
- **NFR-2 DSAR latency** ≤ 30 calendar days end-to-end (GDPR Art. 12(3)).
- **NFR-3 Availability** 99.5% during business hours (08:00–20:00 CET, M–F).
  Out-of-hours the queue may pause; submissions must still be accepted.
- **NFR-4 Segregation of duties** No single user role can both submit a case
  and approve its decision. Enforced in IAM, audited quarterly.
- **NFR-5 Encryption** PII fields encrypted at rest with per-tenant KEKs;
  customer-supplied documents stored in object store with SSE-KMS.
- **NFR-6 Audit integrity** Audit rows hash-chained; daily Merkle root
  published to internal WORM bucket.
