# Product context

## Stakeholders
- **Risk** (primary): needs `pricing_daily` populated by 07:00 UTC. Hard SLA.
- **Analytics**: consumes `marts/fct_pricing_daily`, `marts/dim_instrument`. Soft SLA 09:00 UTC.
- **Quant research**: read-only on `raw.*` and `staging.*`. No SLA but expects schema stability.
- **Reg reporting**: T+1 EOD snapshot frozen by 23:59 UTC of trade date+1.

## Data contracts
- `pricing_daily` columns are versioned. Breaking changes require 30-day deprecation notice via #data-platform Slack.
- `instrument_id` is the canonical join key (issued by EDM team's mastering service).
- All timestamps in UTC. All prices in instrument's quote currency; FX conversion is downstream.

## SLAs
- Freshness: 95% of trading days, `pricing_daily` available by 07:00 UTC.
- Completeness: <0.1% null rate on `close_price` for liquid universe (top 5000 equities).
- Correctness: vendor reconciliation diff <$0.01 for 99% of rows.

## On-call
- Page rotates weekly. Runbook in `docs/runbook.md` (not in memory — too volatile).
