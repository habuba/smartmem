# API surface — gRPC v1

Package: `ledger.v1`. Proto: `api/proto/ledger/v1/ledger.proto`.
mTLS only, SPIFFE identity required. All timestamps are `google.protobuf.Timestamp`,
all amounts are signed `int64` minor units.

## Service `Ledger`

### Writes

- **`PostEntry(PostEntryRequest) returns (PostEntryResponse)`**
  Posts a multi-leg entry. Legs must sum to zero per currency. Requires
  `idempotency_key`. Returns `entry_id` and `txn_id`. Publishes
  `ledger.entry.committed` to Kafka via outbox.
  Errors: `INVALID_ARGUMENT` (unbalanced legs, unknown account), `ALREADY_EXISTS`
  (idempotency replay — response carries the original `txn_id`),
  `FAILED_PRECONDITION` (account closed).

- **`PostReversal(PostReversalRequest) returns (PostEntryResponse)`**
  Posts a reversing entry against `original_txn_id`. Server inverts amounts;
  caller supplies only `reason` and `idempotency_key`. The original entry is
  never modified.
  Errors: `NOT_FOUND` (unknown txn), `FAILED_PRECONDITION` (already reversed).

### Reads

- **`GetEntry(GetEntryRequest) returns (Entry)`**
  Single entry by `entry_id`. p99 < 10ms (NFR-LAT-2).

- **`GetTransaction(GetTransactionRequest) returns (Transaction)`**
  All legs sharing a `txn_id`, returned in `leg_index` order.

- **`ListEntries(ListEntriesRequest) returns (ListEntriesResponse)`**
  Server-side pagination by `(posted_at, entry_id)` cursor. Filters:
  `account_id` (required), `time_range`, `currency`. Max page size 500.

- **`GetBalance(GetBalanceRequest) returns (BalanceResponse)`**
  Balance for `account_id` as of `as_of` timestamp (default: now). For accounts
  in the hot set, served from materialized view; otherwise computed.
  p99 < 50ms (NFR-LAT-2).

### Admin (separate role required)

- **`VerifyChain(VerifyChainRequest) returns (VerifyChainResponse)`**
  Recomputes hash chain for an account over a time range. Returns first
  divergence if any. Streaming would be nicer; not yet implemented.

## Versioning
v1 is frozen. Additive fields only (new optional proto fields, new RPCs).
Anything breaking goes into a v2 service definition with parallel deployment.
`buf breaking` enforces this in CI.
