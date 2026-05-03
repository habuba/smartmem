# Architecture

## Request path (write)
```
gRPC client (mTLS)
  -> grpc.Server (interceptors: auth, otel, recovery, ratelimit)
  -> handler.PostEntry          // proto<->domain mapping, validation
  -> service.Ledger.Post        // business rules, idempotency check, hash chain
  -> repo.EntryRepo.Insert      // sqlc-generated, single TX
       |-- INSERT ledger_entry
       |-- INSERT idempotency_key
       |-- INSERT outbox_event   // same TX = atomic with the entry
  -> TX COMMIT (sync replica ack)
  -> respond to client
```
Kafka publish is **not** in the request path. A separate `outbox-relay` goroutine
polls `outbox_event WHERE published_at IS NULL`, publishes to Kafka, marks
`published_at`. This is the transactional outbox pattern. It costs us a few
hundred ms of publish lag, buys us atomicity between DB commit and event emit.

## Read path
```
gRPC -> handler -> service -> repo -> Postgres read replica (LB'd)
```
GetBalance hits a materialized `account_balance` view refreshed every 30s for
hot accounts, computed on-the-fly for cold ones.

## Deployment topology
- Kubernetes, 3 replicas minimum, HPA on CPU + custom `inflight_requests` metric.
- PodDisruptionBudget: maxUnavailable=1.
- Postgres: managed (Cloud SQL HA), 1 primary + 1 sync standby + 2 async read replicas.
- Kafka: 3 brokers, RF=3, min.insync.replicas=2, `acks=all` from producer.
- Ingress: internal-only gRPC LB. No public exposure. SPIFFE for caller identity.

## Failure modes we plan for
- Postgres primary loss: app retries with backoff during failover (~30s window).
- Kafka broker loss: outbox-relay backs off, entries pile up in `outbox_event`,
  drained when broker returns. No data loss; only publish lag.
- Network partition between app and DB: writes fail closed. Better than splitting.
