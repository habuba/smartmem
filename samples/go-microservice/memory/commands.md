# Commands

## Build & verify
```
go build ./...
go vet ./... && staticcheck ./...
buf lint && buf breaking --against '.git#branch=main'
```

## Test
```
go test -race ./...                                    # gate
go test -race -count=10 ./internal/service/...         # flake hunt
go test -tags=integration ./test/e2e/...               # testcontainers
go test -fuzz=FuzzHashChain -fuzztime=10m ./internal/hashchain
```

## Local dev
```
make dev                          # pg + kafka + otel-collector via compose
make seed                         # 10k synthetic entries
skaffold dev --port-forward       # hot reload into kind
make tear                         # bring it all down
```

## Code gen (run after pulling main if .proto or queries.sql changed)
```
sqlc generate
buf generate
```

## Migrations
```
migrate -path db/migrations -database "$DB_URL" up
migrate -path db/migrations -database "$DB_URL" down 1     # local only
migrate create -ext sql -dir db/migrations -seq add_xxx
```

## Ops CLI
```
ledgerctl outbox replay --since 2026-04-28T00:00:00Z
ledgerctl chain verify --account <uuid> --from <ts> --to <ts>
ledgerctl partitions list
ledgerctl partitions archive --month 2024-10
```

## Profiling
```
go test -bench=. -benchmem -cpuprofile=cpu.out ./internal/service
go tool pprof -http=:8080 cpu.out
curl -s localhost:6060/debug/pprof/heap > heap.out      # dev only
```

## Load test (verifies NFR-LAT-1)
```
k6 run test/load/post_entry.js -e RPS=5000 -e DURATION=10m
```
