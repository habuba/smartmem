# Decisions (ADR-lite)

Append-only. Newest at top. One-line rationale; link to PR/doc for depth.

- 2026-04-28 — Migrate FX feed CSV -> Parquet in Q3. Reason: 6x smaller, schema embedded, 40% faster COPY. Blocked on vendor support confirmation. (PR: #312)
- 2026-04-15 — Drop dbt snapshots for `dim_instrument`; use explicit SCD2 incremental model. Reason: snapshot took 18min on 40M rows; incremental runs in 90s. (PR: #298)
- 2026-04-02 — Adopt `ruff` as sole linter/formatter. Reason: replaces black + isort + flake8 with one tool, ~3x faster on CI. Migration was mechanical. (PR: #285)
- 2026-03-18 — Vendor priority Bloomberg > Refinitiv > ICE for `fct_pricing_daily.vendor_source`. Reason: Bloomberg has lowest reconciliation diff vs exchange tape. Reviewed quarterly.
- 2026-03-12 — Use dbt incremental models over snapshots for pricing facts. Reason: snapshots assume slow-changing; pricing arrives same-day with corrections, snapshot semantics don't fit. Late-arrival handled via window function on `loaded_at`.
- 2026-02-20 — Single-region (us-east-1) deployment. No multi-region failover. Reason: cost vs RPO tradeoff; vendors are us-east-1 anyway. Revisit if regulatory requires.
- 2026-01-30 — All timestamps UTC, no exceptions. Reason: previous mix of ET/UTC caused 4 incidents in 2025. Conversion happens in BI layer.
