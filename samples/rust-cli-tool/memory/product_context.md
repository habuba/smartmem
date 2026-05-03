# product_context

## Who uses it
- SREs / platform engineers debugging production with `kubectl logs | logslice`.
- Data engineers doing ad-hoc slicing of S3-exported ndjson dumps.
- A handful of security folks running it over auth logs (low priority — they
  mostly want regex on raw text, which we don't optimize for).

## Primary workflows
1. Tail-and-filter: `kubectl logs -f svc | logslice '.level=="error"'`
2. Bulk slice: `zcat *.ndjson.gz | logslice -q query.lsq -o tsv > out.tsv`
3. Watch mode on a rotating file: `logslice -w app.log '.duration_ms > 1000'`

## What they care about
- Throughput. They will benchmark us against `jq` on day one.
- Sane error messages on malformed lines (skip + count, not abort — see ADR-003).
- Stable exit codes for shell pipelines (0 ok, 1 query error, 2 IO, 64 usage).

## What they don't care about
- Pretty TUI. They pipe into `less`.
- Config files. Everything is flags + optional `.lsqrc` for aliases.
- Windows. We support it but nobody runs production logs through Windows pipes.
