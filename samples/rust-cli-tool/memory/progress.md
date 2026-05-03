# progress

## Milestones

### v0.7.0 — 2026-04-22 (current)
- `--parallel N` flag with ordered writer.
- Skip-on-malformed default; `--strict` opt-in.
- Switched default allocator to mimalloc. **Known regression**: -18% on pure
  parse bench. Tracked T-018; conditional fix in flight.
- Dropped `--jsonl` alias (deprecation warning kept until v0.8).

### v0.6.4 — 2026-04-08
- Hand-rolled Pratt parser replaces chumsky. Compile time -54%.
- DSL gains `in` operator: `.code in [500, 502, 503]`.
- Watch mode handles file truncation correctly (re-open from offset 0).

### v0.6.0 — 2026-03-25
- `&RawValue` hot path. 3.2x throughput on `parse_ndjson` bench.
- dhat alloc-budget test in CI. Catches regressions to `serde_json::Value` use.

### v0.5.0 — 2026-03-10
- Query DSL v1 (replaced embedded jaq — ADR-001).
- ndjson and TSV writers. Templated writer (`-t`) deferred.

### v0.4.0 — 2026-02-20
- Watch mode v1 via `notify`.
- Criterion benches checked in. Initial baseline: 410 MB/s parse.

### v0.1.0 — 2026-02-01
- Workspace scaffold, clap skeleton, ndjson read + naive `serde_json::Value`
  filter. Slow (110 MB/s) but correct on fixtures.

## Throughput timeline (parse_ndjson, MB/s, single core)
v0.1 110 → v0.4 410 → v0.6 905 → v0.7 740 (regression, fix in progress)
