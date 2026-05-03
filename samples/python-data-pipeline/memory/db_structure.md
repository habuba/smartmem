# DB structure (Snowflake)

## Database / schema layout
```
MARKETWATCH (database)
  RAW           -- 1:1 vendor files, no transforms
  STAGING       -- typed, deduplicated, canonical column names
  INTERMEDIATE  -- joins, reconciliation
  MARTS         -- business-facing
  OPS           -- pipeline metadata (watermarks, run metrics)
```

## Key tables

### `RAW.BLOOMBERG_PRICING`
```
business_date     DATE
instrument_id_raw VARCHAR     -- vendor's id, not mastered
ticker            VARCHAR
close_price       NUMBER(18,6)
volume            NUMBER(38,0)
currency          VARCHAR(3)
_meta_loaded_at   TIMESTAMP_NTZ
_meta_file_hash   VARCHAR(64)
_meta_file_name   VARCHAR
```
Clustered by `business_date`. Retention: 90 days hot, then auto-tiered to S3 external table.

### `MARTS.FCT_PRICING_DAILY`
```
instrument_id     VARCHAR    -- mastered, FK -> dim_instrument
business_date     DATE
open_price        NUMBER(18,6)
high_price        NUMBER(18,6)
low_price         NUMBER(18,6)
close_price       NUMBER(18,6)
volume            NUMBER(38,0)
vendor_source     VARCHAR    -- which vendor won the priority rule
is_correction     BOOLEAN
valid_from        TIMESTAMP_NTZ
loaded_at         TIMESTAMP_NTZ
```
Grain: 1 row per (instrument_id, business_date). PK enforced via dbt unique test.
Clustered by `(business_date, instrument_id)`.

### `MARTS.DIM_INSTRUMENT` (SCD2)
```
instrument_id, ticker, name, asset_class, exchange, currency,
valid_from, valid_to, is_current
```

### `OPS.INGEST_WATERMARK`
```
vendor, feed, last_business_date, last_run_id, last_updated_at
```

## Migrations
Flyway. `migrations/V0042__add_is_correction_flag.sql` style. Forward-only; rollback via new migration. Never edit applied migrations.

## Vendor priority
When same `(instrument_id, business_date)` arrives from multiple vendors, priority: Bloomberg > Refinitiv > ICE. Logic in `int_pricing_reconciled.sql`.
