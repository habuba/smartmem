# System patterns — fullstack web

## Layers
- frontend/ — UI only. No business logic.
- backend/ — HTTP + services + repositories.
- shared/ (optional) — types/contracts.

## Cross-cutting
- Error handling: errors bubble; the boundary (HTTP handler / UI error boundary) formats them.
- Logging: structured, with request ID.
- Auth: enforced at the backend boundary, mirrored in the frontend client only for UX.

## Testing
- Backend: unit + integration with real DB.
- Frontend: component tests + at least one Playwright/Cypress smoke test for the golden path.
