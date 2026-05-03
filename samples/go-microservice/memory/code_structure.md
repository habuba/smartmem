# Code structure

```
cmd/
  ledgerd/main.go           // wire deps, start gRPC server + outbox relay
  ledgerctl/main.go         // ops CLI: replay outbox, dump chain, verify hash
internal/
  domain/                   // pure types: Entry, Leg, Account. No I/O.
  service/                  // business logic. Depends on repo + producer interfaces.
    ledger.go
    ledger_test.go          // table-driven, uses fakes from internal/testing.
  repo/
    queries.sql             // hand-written SQL, sqlc input
    sqlc.yaml
    gen/                    // sqlc-generated. Do not edit by hand.
    entry_repo.go           // thin adapter over sqlc.gen
  transport/grpc/
    server.go               // wires interceptors
    handler_entry.go        // proto <-> domain mapping
    interceptors/
  outbox/
    relay.go                // poll-and-publish loop
  hashchain/                // sha256 chain helpers, isolated for fuzzing
  obs/                      // OTel + Prom setup, single source of truth
  config/                   // env loading, validation. No init() reads of env.
api/
  proto/ledger/v1/*.proto   // public contract; buf-managed
  gen/                      // protoc-gen-go output
db/
  migrations/               // golang-migrate, NNNN_*.up.sql / .down.sql
deploy/
  k8s/                      // base + overlays (dev/stg/prod) via kustomize
  skaffold.yaml
test/
  e2e/                      // spins up testcontainers Postgres+Kafka
  load/                     // k6 scripts for NFR-LAT-1 verification
```

## Where to look first
- New RPC: `api/proto/ledger/v1/`, then `transport/grpc/handler_*.go`, then `service/`.
- Schema change: `db/migrations/`, then `internal/repo/queries.sql`, run `sqlc generate`.
- Latency regression: `internal/obs/` + Grafana dashboard `ledgerd-rpc`.
