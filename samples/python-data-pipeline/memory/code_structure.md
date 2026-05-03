# Code structure

```
marketwatch-etl/
  dags/                     # Airflow DAG definitions
    vendor_csv_ingest.py    # parameterized, one task group per vendor
    normalize_pricing.py
    build_marts.py
    freeze_eod.py
    common/
      defaults.py           # with_default_args() helper
      sensors.py            # custom S3KeySensor with vendor-aware backoff
  transform/                # dbt project
    models/
      staging/              # 1:1 with raw, light cleanup
      intermediate/         # joins, late-arrival reconciliation
      marts/                # business-facing facts/dims
    tests/                  # custom dbt tests (singular)
    macros/
    dbt_project.yml
  ingest/                   # Python package, vendor adapters
    bloomberg/
    refinitiv/
    ice/
    common/
      schema.py             # canonical pydantic models
      s3_io.py
  tests/                    # pytest
    unit/
    integration/            # uses moto + snowflake-connector-mock
  scripts/
    backfill.py             # one-off backfills, idempotent
    reconcile.py
  pyproject.toml
  ruff.toml
  .github/workflows/        # CI: lint, test, dbt compile, dbt slim CI
```

## Where things go
- New vendor adapter: `ingest/<vendor>/`, register in `dags/vendor_csv_ingest.py` `VENDORS` dict.
- New mart: `transform/models/marts/`, expose in `dbt_project.yml` `models:` config.
- New canonical field: `ingest/common/schema.py` first, then propagate.
