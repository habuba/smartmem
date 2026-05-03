# Project brief

## What
marketwatch-etl ingests vendor pricing CSVs (equities, FX, fixed income) from S3, normalizes to a canonical schema, loads into Snowflake, and exposes curated dbt marts to the analytics and risk teams.

## Why
Before this pipeline, each desk parsed vendor files in Excel/ad-hoc Python. Same file parsed 4 ways, 4 different EOD prices in 4 different reports. This pipeline is the single source of truth for "what was the close price of X on day Y."

## Scope
- IN: vendor file ingest (Bloomberg, Refinitiv, ICE), normalization, Snowflake load, dbt marts, Airflow orchestration, monitoring.
- OUT: real-time tick data (separate Kafka pipeline), trade/order data (OMS team owns), reference data mastering (EDM team owns — we consume their feed).

## Consumers
- Risk team (VaR jobs, daily 18:00 UTC)
- Analytics team (Looker dashboards)
- Quant research (Snowflake direct, ad-hoc)
- Regulatory reporting (T+1 EOD prices, MiFID/Dodd-Frank)
