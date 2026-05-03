# tech_context

## Toolchain
- rustc: stable, currently 1.83.0 (rust-toolchain.toml pins `stable`).
- MSRV: 1.81.0. Enforced by `cargo msrv verify` in CI.
- Edition: 2021. Migrating to 2024 is tracked under T-019 — blocked on a
  `notify` upgrade that re-exports a `?Sized` bound we rely on.

## Key dependencies (versions tracked in Cargo.lock)
- `clap` 4.5 (derive)
- `serde` 1.0 + `serde_json` 1.0 (with `raw_value` feature)
- `tokio` 1.40 (rt + io-util only; we don't need rt-multi-thread)
- `notify` 6.1 (watch mode)
- `anyhow` 1, `thiserror` 1
- `criterion` 0.5 (dev), `assert_cmd` 2 (dev), `dhat` 0.3 (dev)

## Test commands
```
cargo test                       # unit + integration
cargo nextest run                # preferred locally; CI uses this too
cargo nextest run -p logslice-core
cargo test --doc                 # nextest skips doctests; run separately
cargo bench --bench parse        # criterion, ~90s
cargo bench --bench pipeline     # ~3 min, gated behind `--features bench-large`
```

## CI (GitHub Actions)
- `ci.yml`: fmt, clippy (-D warnings), nextest, doctests, msrv. ~4 min.
- `bench.yml`: nightly, runs criterion, posts comparison vs `main` on PRs that
  touch `parser.rs` or `filter.rs`. Threshold for failing the check: 5%.
- `audit.yml`: weekly `cargo audit` + `cargo deny`.

## Local dev quirks
- macOS: `notify` uses FSEvents which coalesces writes — watch mode tests are
  flaky on M1 under load. Mark them `#[ignore]` and run with `--ignored` selectively.
- Windows: `assert_cmd` newline handling. CRLF normalization in test helpers.
