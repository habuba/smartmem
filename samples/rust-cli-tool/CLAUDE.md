# logslice

Structured-log slicer for ndjson — jq-like queries, streaming, watch mode.

## Memory pointers
@memory/MEMORY.md
@memory/active_context.md

## Rules
- Be concise. No restating files I can read myself.
- Memory is hierarchical: load `MEMORY.md` index first, then only the file(s) you need.
- Auto-update memory at end of work sessions (emit `MEMORY_NOTES:` blocks).
- Only `memory-finalizer` writes to `memory/**`. Every other agent proposes via notes.
- Rust style: `cargo fmt` before commits, `cargo clippy -- -D warnings` must pass.
- No `unwrap()` outside tests and `main.rs` startup. Use `?` with `anyhow` at boundaries, `thiserror` for library errors.
- Benchmarks are load-bearing; if `cargo bench` regresses >5% on `parse_ndjson`, stop and investigate before merging.
