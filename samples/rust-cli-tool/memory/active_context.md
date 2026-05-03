# Active context

## Now
- Benchmarks regressed 18% on v0.7 (`parse_ndjson` bench: 740 MB/s vs 905 MB/s
  on v0.6.4). Bisected to commit `a3f1e02` — switching default allocator from
  system to `mimalloc`. mimalloc helps `pipeline` bench (+6%) but hurts the
  pure-parse hot loop because of larger TLS init cost per worker.
- Working theory: keep mimalloc but only when `--parallel` is set. Single-thread
  default goes back to system allocator. PoC branch: `perf/alloc-conditional`.
- Need to redo the `dhat` alloc-budget test — mimalloc reports differently and
  the assertion is currently disabled on that branch.

## Open threads
- T-014 (logfmt support) — design doc draft in `docs/rfcs/0003-logfmt.md`.
  Open question: do we share the filter DSL or fork? Leaning shared, with logfmt
  parser producing the same `BorrowedValue` shape.
- Watch mode on Linux misses events when editor writes via rename+replace
  (vim default). Need to handle `Remove` followed by `Create` on same path.
- `cargo deny` flagged `idna` 0.4 transitive — upstream `notify` PR open.

## Recently decided
- 2026-04-22: Drop the `--jsonl` alias. Was confusing alongside `--ndjson`. Just `--ndjson`.
- 2026-04-15: Pratt parser hand-rolled, not `chumsky`. Faster compile, fewer deps. (ADR-006)
- 2026-04-02: `null` semantics stay two-valued. Three-valued logic broke users. (ADR-002)
