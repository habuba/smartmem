# Architecture

## Data flow

```
  vendor SFTP/API
        |
        v
  +-----------+        +-----------+        +-----------+
  | S3 raw    | -----> | Snowflake | -----> | Snowflake |
  | landing   |  COPY  | raw.*     |  dbt   | staging.* |
  +-----------+        +-----------+        +-----------+
                                                  |
                                                  v dbt run
                                            +-----------+
                                            | marts.*   |
                                            +-----------+
                                                  |
                                       Looker / Risk jobs / Quant
```

## DAG topology (Airflow)
- `vendor_csv_ingest` (per vendor, hourly during market hours): SFTP -> S3 -> Snowflake `raw.<vendor>_<feed>`.
- `normalize_pricing` (daily 05:30 UTC): runs dbt staging models. Depends on all `vendor_csv_ingest` of the day.
- `build_marts` (daily 06:00 UTC): runs dbt marts + tests. Depends on normalize.
- `freeze_eod` (daily 23:30 UTC): writes immutable T+1 snapshot to `marts.fct_pricing_daily_frozen`.

## Components
- **Airflow 2.9** on MWAA (managed). DAG code in `dags/`.
- **dbt-snowflake 1.7** for transformations. Project in `transform/`.
- **Snowflake** warehouses: `INGEST_WH` (xs, auto-suspend 60s), `TRANSFORM_WH` (m), `BI_WH` (l, used by Looker).
- **Great Expectations** for raw-layer validation (schema, null rate, range).

## Cross-cutting
- Secrets in AWS Secrets Manager, fetched via Airflow connection backend.
- All DAGs use a shared `with_default_args()` helper enforcing retries=2, sla=2h, on_failure=pagerduty.
