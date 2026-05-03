# commands

Cargo invocations actually used during development. Copy-paste safe.

## Build / run
```
cargo build                                       # debug, fastest iter
cargo build --release                             # what benches/CI use
cargo run -- '.level=="error"' < fixtures/small/app.ndjson
cargo run --release -- -w app.log '.duration_ms > 1000'
```

## Test
```
cargo nextest run                                 # all crates
cargo nextest run -p logslice-core                # core only
cargo nextest run -p logslice-cli e2e             # CLI integration
cargo test --doc                                  # doctests (nextest skips these)
cargo test --test alloc_budget --release          # dhat budget test (release-only)
```

## Lint / format
```
cargo fmt --all
cargo fmt --all -- --check                        # CI mode
cargo clippy --workspace --all-targets -- -D warnings
cargo clippy --workspace --all-targets --all-features -- -D warnings
```

## Bench
```
cargo bench --bench parse                         # ~90s, run before any parser.rs change
cargo bench --bench pipeline                      # ~3 min
cargo bench --bench parse -- --save-baseline pre
# ...make change...
cargo bench --bench parse -- --baseline pre       # diff against saved
```

## Audit / deps
```
cargo audit
cargo deny check
cargo msrv verify
cargo update -p <crate>                           # never `cargo update` blanket
```

## Release (xtask)
```
cargo xtask dist                                  # builds release bins for 4 targets
cargo xtask fixtures                              # download large fixtures
cargo xtask bump --minor                          # version bump + changelog scaffold
```
