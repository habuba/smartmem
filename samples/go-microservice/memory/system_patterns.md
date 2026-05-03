# System patterns

## Context propagation
Every function that does I/O — DB, Kafka, RPC, HTTP — takes `ctx context.Context`
as its first arg. No exceptions. `context.Background()` appears only in `main`
and inside tests. Background goroutines (outbox relay, metrics flush) get a
context derived from `main`'s context and respect cancellation on shutdown.

## Error wrapping
- Always wrap with `fmt.Errorf("doing X: %w", err)`. The verb names the
  operation, not the type ("inserting entry" not "EntryRepo.Insert").
- Sentinel errors live in `internal/domain/errors.go`: `ErrDuplicateKey`,
  `ErrChainBroken`, `ErrLegsUnbalanced`. Compare with `errors.Is`.
- Domain errors map to gRPC codes in one place: `transport/grpc/errmap.go`.
  No `status.Error` calls outside that file.

## No global state
- No package-level `var db *sql.DB`, no `var producer *kafka.Producer`.
- Dependencies flow in via constructors. `main` wires the graph.
- The one allowed exception: `internal/obs` registers Prom collectors at init.
  Documented and contained.

## Testing
- Table-driven tests are the default. Each row has a name, inputs, expected
  output, expected error. Use `t.Run(tc.name, ...)`.
- `-race` is mandatory in CI. PRs that fail race don't merge.
- Fakes over mocks. Hand-written fakes in `internal/testing/fakes/` implement
  the same interfaces as real adapters. No gomock.
- Integration tests use testcontainers. No "if integration { skip }" gating —
  they run by default in `go test ./...`. Slow but real.

## Concurrency
- Channels for ownership transfer, mutexes for shared state, never both for
  the same data.
- Every goroutine started by ledgerd has an owner that waits for it on
  shutdown. No fire-and-forget.

## SQL
- All queries go through sqlc. No `db.QueryContext` in service code.
- Migrations are forward-only in production. `down.sql` exists for local rollback.
