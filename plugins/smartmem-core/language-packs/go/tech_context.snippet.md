## Go toolchain
- Version: _(pin explicitly in `go.mod`)_
- Lint: `golangci-lint`
- Test: `go test ./...`
- LSP: `gopls`

## Commands
- Build: `go build ./...`
- Test: `go test ./... -race`
- Lint: `golangci-lint run`
- Format: `gofmt -w .` (or `goimports -w .`)
- Tidy: `go mod tidy`
