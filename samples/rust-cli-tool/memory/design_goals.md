# design_goals

## Hard constraints
- **Streaming**: constant memory regardless of input size. No buffering whole
  file. Watch mode must not retain parsed history.
- **Zero-alloc hot path**: per-line parse + filter must not allocate for the
  common case (filter rejects line). Use `serde_json::from_slice` with borrowed
  `&RawValue` where possible. Verified by `dhat` heap profile in CI (T-008).
- **No panics on input**: malformed line = skip + increment counter, never abort.
  Panics are reserved for programmer errors (invariant violations).

## Soft goals
- Single static binary, <5 MB stripped. Currently 4.1 MB.
- MSRV stability: pin to current stable -2 (today: 1.81). Don't chase nightly.
- Predictable CLI: flags follow GNU conventions, query DSL has one syntax — no
  shell-style and Python-style aliases for the same thing.

## Explicit non-goals
- Not a replacement for `jq` on arbitrary JSON. We require ndjson.
- Not a log shipper. No network sinks. Pipe to `vector` or `fluentbit`.
- Not a SIEM. No alerting, no state across runs.
