# Backend

@../memory/api_context.md
@../memory/system_patterns.md

## Rules
- HTTP handlers stay thin. Business logic lives in service modules; persistence in repositories.
- Validate input at the handler boundary; trust internals.
- Every new endpoint: add an integration test against a real (containerized) database, not a mock.
