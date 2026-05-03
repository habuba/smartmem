# Tech context

## Stack
- Go 1.23 (toolchain pinned in `go.mod`).
- gRPC + protobuf, `buf` for lint/breaking checks.
- Postgres 15, sqlc for query gen, golang-migrate for schema.
- Kafka (Confluent client), transactional outbox pattern.
- OpenTelemetry SDK + OTLP exporter -> collector -> Tempo.
- Prometheus client_golang, exposed at `:9090/metrics`.
- Docker, Kubernetes, Skaffold for inner-loop, Kustomize for overlays.

## Build
```
go build ./...                      # full build, must stay clean
go build -o bin/ledgerd ./cmd/ledgerd
go vet ./... && staticcheck ./...   # both must be clean
buf lint && buf breaking --against '.git#branch=main'
```

## Test
```
go test -race ./...                 # all tests, race detector. CI gate.
go test -race -run TestLedger_Post -count=10 ./internal/service
go test -tags=integration ./test/e2e/...   # testcontainers, ~45s
go test -fuzz=FuzzHashChain ./internal/hashchain  # fuzz before any chain change
```

## Local dev
```
make dev                            # docker compose up: pg + kafka + otel-collector
skaffold dev --port-forward         # hot-reload into local k8s (kind)
make seed                           # load 10k synthetic entries
```

## Profiling
```
go test -bench=. -benchmem -cpuprofile=cpu.out ./internal/service
go tool pprof -http=:8080 cpu.out
curl -s localhost:6060/debug/pprof/heap > heap.out   # ledgerd exposes pprof on :6060 in dev only
go tool pprof -alloc_objects heap.out
```

## Load test
```
k6 run test/load/post_entry.js -e RPS=5000 -e DURATION=10m
# verifies NFR-LAT-1
```

## Code generation
```
sqlc generate                       # regen internal/repo/gen/
buf generate                        # regen api/gen/
```
Run both after pulling main if `queries.sql` or `*.proto` changed.
