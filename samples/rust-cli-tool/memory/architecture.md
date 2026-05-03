# architecture

## Pipeline

```
  stdin / file / watch
        │
        ▼
   ┌─────────┐    line bytes (&[u8], no copy)
   │ Reader  │───────────────────┐
   │ (tokio) │                   │
   └─────────┘                   ▼
                           ┌──────────┐    BorrowedValue<'a>
                           │  Parser  │────────────────┐
                           │ (serde)  │                │
                           └──────────┘                ▼
                                                 ┌──────────┐    bool + value
                                                 │  Filter  │────────────┐
                                                 │  (DSL)   │            │
                                                 └──────────┘            ▼
                                                                  ┌───────────┐
                                                                  │ Projector │
                                                                  │ (columns) │
                                                                  └─────┬─────┘
                                                                        ▼
                                                                  ┌──────────┐
                                                                  │  Writer  │
                                                                  │ ndjson/  │
                                                                  │  tsv/    │
                                                                  │  tmpl    │
                                                                  └──────────┘
```

## Threading model
- Single-threaded by default. Parsing JSON is CPU-bound and `serde_json` is
  fast enough that pipeline overhead beats `rayon` for typical line sizes.
- `--parallel N` flag uses `crossbeam` channels: 1 reader → N parser/filter
  workers → 1 ordered writer. Used when filter is expensive (regex, deep paths).
  Tested but rarely a win below 8 cores (see decisions.md ADR-005).

## Watch mode
`notify` crate on the file path. On modify event, seek to last position and
read forward. Truncation = re-open from 0. State is just `(inode, offset)`.

## Crate split
- `logslice-core` (lib): parser, filter, projector, query DSL.
- `logslice-cli` (bin): clap parsing, IO wiring, watch mode.
- Keeping core lib-only so `logslice-bench` and future WASM port can reuse it.
