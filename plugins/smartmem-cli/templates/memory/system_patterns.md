# System patterns — CLI tool

## Argument design
- One verb per subcommand. Use noun-verb naming (`smartmem init`, not `smartmem-init`).
- Flags have both short and long form for top-3 commands.
- `--help` is exhaustive. `--version` prints semver.

## I/O
- Read from stdin if no file arg; write to stdout. Errors to stderr.
- Exit 0 on success, 1 on user error, 2 on internal error.
- Respect `NO_COLOR`, `--json` for machine output.

## Distribution
- Single-binary or single-script preferred.
- Shell completions ship with the package.
