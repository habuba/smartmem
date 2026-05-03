# project_brief

logslice is a CLI for slicing structured (ndjson) log streams. Think `jq`, but
optimized for the SRE workflow: tail a file or kubectl logs pipe, filter on
nested fields, project a flat row, watch in real time.

## Why it exists
Existing tools fall into two camps:
- `jq` — powerful, but slow on multi-GB streams, awkward DSL for the
  "filter → flatten → tail" loop, no native watch mode.
- `lnav`, `goaccess` — TUI-heavy, opinionated about formats, not pipe-friendly.

logslice is a Unix filter first. It reads ndjson, applies a small query DSL
(`.svc == "api" && .latency_ms > 200`), and writes ndjson, TSV, or a templated
line. Watch mode (`-w`) re-runs against new lines without re-parsing prior input.

## Scope
- ndjson input only. No multiline JSON, no logfmt (yet — see T-014).
- Single-process. No clustering, no remote sources.
- Best-effort schema inference for `--columns auto`; explicit projections preferred.

## Success metric
End-to-end throughput >= 800 MB/s on the `nginx-access-1g.ndjson` fixture, single
core, release build, with a non-trivial filter. Currently 740 MB/s on v0.7.
