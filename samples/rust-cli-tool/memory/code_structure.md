# code_structure

```
logslice/
├── Cargo.toml                 # workspace
├── crates/
│   ├── logslice-core/
│   │   ├── src/
│   │   │   ├── lib.rs
│   │   │   ├── parser.rs      # ndjson → BorrowedValue
│   │   │   ├── filter.rs      # DSL evaluator
│   │   │   ├── projector.rs   # column extraction
│   │   │   ├── query/
│   │   │   │   ├── mod.rs
│   │   │   │   ├── lexer.rs   # hand-written, no pest/nom
│   │   │   │   ├── parser.rs  # Pratt parser
│   │   │   │   └── ast.rs
│   │   │   └── error.rs       # thiserror Error enum
│   │   └── tests/
│   │       ├── filter_smoke.rs
│   │       └── fixtures/
│   ├── logslice-cli/
│   │   ├── src/
│   │   │   ├── main.rs        # entry, only place unwrap/expect lives
│   │   │   ├── args.rs        # clap derive
│   │   │   ├── watch.rs       # notify-based tail
│   │   │   └── output.rs      # writer impls
│   │   └── tests/
│   │       └── cli_e2e.rs     # assert_cmd
│   └── logslice-bench/
│       └── benches/
│           ├── parse.rs       # criterion
│           └── pipeline.rs
├── fixtures/
│   ├── nginx-access-1g.ndjson      # gitignored, downloaded by xtask
│   └── small/                       # checked-in, <100 KB total
└── xtask/                     # cargo xtask: fixtures, dist, audit
```

## Where to look
- Adding a query operator: `crates/logslice-core/src/query/{lexer,parser,ast}.rs` then `filter.rs`.
- New output format: `crates/logslice-cli/src/output.rs`, add variant + match arm.
- Parser perf work: `parser.rs` + run `cargo bench --bench parse`.
