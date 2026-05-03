# decisions

ADR-lite. New entries on top.

## ADR-007 — 2026-04-22 — Drop `--jsonl` alias
Users were reporting "jsonl vs ndjson, what's the difference?" three times a
month. They're the same format. Keeping one name (`--ndjson`) plus an
alias-deprecation warning for one minor version, then removed in v0.8.

## ADR-006 — 2026-04-15 — Hand-rolled Pratt parser, not chumsky
Tried `chumsky` 0.10 for the query DSL parser. Compile time on `logslice-core`
went from 4.1s to 11.7s clean release. Error messages were good but our DSL is
~12 productions — overkill. Replaced with ~250 LOC hand-rolled lexer + Pratt
parser. Saves a dep, halves compile time, on-par error quality after a day of
polishing.

## ADR-005 — 2026-04-08 — Single-threaded default, `--parallel` opt-in
Benchmarked rayon-parallel pipeline against single-threaded across 2/4/8/16
cores on the 1G nginx fixture. Below 8 cores the channel + ordering overhead
ate the parallelism win. Default stays single-threaded; `--parallel N` exposed
for users with expensive filters (regex-heavy) or 16+ core boxes.

## ADR-003 — 2026-03-12 — Skip malformed lines, never abort
Production logs have garbage. Aborting on the first bad line makes us useless
as a tail filter. Skip + count + stderr summary on EOF. Strict mode (`--strict`)
opt-in for batch jobs that need to fail loudly.

## ADR-002 — 2026-03-05 — Two-valued null semantics in DSL
Tried three-valued (SQL-style: `null && false = null`). Users wrote
`.svc == "api" && .latency > 200` expecting "filter out missing svc" and got
zero rows because every comparison short-circuited to `null`. Reverted to
two-valued: missing/null compares as false, except `== null` works literally.

## ADR-001 — 2026-02-08 — Replace jq-style query syntax with our own DSL
Started by embedding `jaq` (jq-in-Rust). Two problems: (1) jq's lazy null
propagation produced surprising results in streaming mode where partial errors
matter; (2) we wanted infix `&&`/`||`/`==` because that's what SREs expect from
`awk`/`promql`, not jq's pipeline-of-filters model. Wrote our own small DSL.
Tradeoff: users who know jq have to learn ours. Mitigated by a `--from-jq`
translation cheatsheet in the README.
