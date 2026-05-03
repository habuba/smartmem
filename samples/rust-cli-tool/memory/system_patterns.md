# system_patterns

## Error handling: anyhow / thiserror split
- `logslice-core` returns `Result<T, logslice_core::Error>` where `Error` is a
  `thiserror`-derived enum. Variants: `Parse { line, source }`, `Query(QueryError)`,
  `Io(io::Error)`. Library consumers can match on these.
- `logslice-cli` (bin) uses `anyhow::Result` everywhere. `main()` returns
  `anyhow::Result<()>` and lets the error fall through with `{:#}` formatting.
- Never `anyhow!` inside `logslice-core`. Never re-export `anyhow::Error` from a lib.

## Zero-alloc parsing rule
Per-line parse must not heap-allocate when the filter rejects the line. Concretely:
- Use `serde_json::from_slice::<&RawValue>` for the borrowed top-level.
- Field access goes through `RawValue` + custom path walker — do **not**
  deserialize into `serde_json::Value` (that's a `BTreeMap`, allocates per line).
- Verified by `dhat-heap` test in `crates/logslice-core/tests/alloc_budget.rs`:
  filtering 100k rejected lines must allocate <= 64 bytes total.

## Skip-on-malformed
Malformed lines never abort. They increment `stats.malformed` and (with `-v`)
print `line N: <reason>` to stderr. Counter reported on EOF.

## Query DSL invariants
- All operators are total: comparing string to number = false, never an error.
- Path access on missing fields = `null`, and `null OP anything = false` except
  `.foo == null` which works as expected. (See ADR-002 for why null isn't
  three-valued — we tried, it broke `&&` short-circuit semantics for users.)

## Clippy / lints
- `#![warn(clippy::pedantic)]` on `logslice-core`, with explicit `allow` list at
  crate root. CLI crate is just `clippy::all` — pedantic on clap-derive code is noisy.
- `#![forbid(unsafe_code)]` everywhere. We have not found a case where unsafe
  beats the borrowed-RawValue approach.
