# Tasks

## Open
- [ ] T-014 (2026-03-30) logfmt input support — RFC draft up, awaiting review
- [ ] T-018 (2026-04-22) Investigate v0.7 parse-bench regression (mimalloc) — in progress, branch `perf/alloc-conditional`
- [ ] T-019 (2026-04-10) Migrate to edition 2024 — blocked on `notify` 7.x
- [ ] T-021 (2026-04-28) Watch mode: handle rename+replace on Linux (vim writes)
- [ ] T-022 (2026-04-29) Re-enable dhat alloc-budget test under mimalloc
- [ ] T-024 (2026-05-01) Document exit codes in README and `--help` epilog
- [ ] T-025 (2026-05-02) `cargo deny` idna transitive — track upstream notify PR

## Done
- [x] T-017 (2026-04-22) Drop `--jsonl` alias (ADR-007)
- [x] T-016 (2026-04-15) Hand-rolled Pratt parser replacing chumsky (ADR-006)
- [x] T-013 (2026-04-08) `--parallel N` flag with ordered writer
- [x] T-012 (2026-04-01) Skip-on-malformed + stderr summary
- [x] T-011 (2026-03-25) Switch from `Value` to `&RawValue` in hot path (~3.2x speedup)
- [x] T-010 (2026-03-18) Watch mode v1 (notify-based)
- [x] T-009 (2026-03-10) Query DSL v1 (replaced jq subset — see ADR-001)
- [x] T-008 (2026-03-02) dhat alloc-budget integration test
- [x] T-005 (2026-02-20) Criterion benches for parse + pipeline
- [x] T-001 (2026-02-01) Initial workspace scaffold + clap CLI skeleton
