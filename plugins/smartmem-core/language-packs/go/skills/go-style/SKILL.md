---
name: go-style
description: Go coding rules — error handling, package layout, naming. Apply when writing or reviewing Go in this project.
---

# Go style

- Errors: return `error`, never panic for expected failures. Wrap with `fmt.Errorf("...: %w", err)` to preserve chain.
- No naked returns in long functions. Name returned values only when a defer needs them.
- Package names: short, lowercase, no underscores or camelCase. One word ideal.
- Interfaces: define at the **consumer**, not the producer.
- `context.Context` is the first arg of any function that does I/O or might be cancelled.
- Avoid `init()`. Initialize explicitly in `main` or constructors.
- `gofmt` (or `goimports`) is non-negotiable. CI rejects unformatted code.
- Lint with `golangci-lint` (run `errcheck`, `staticcheck`, `gosimple`, `govet` at minimum).
- Tests: `*_test.go` next to code. Table-driven tests for multiple cases. Use `t.Run` for sub-tests.
- Avoid generics until you've written the same code 3 times concretely.
