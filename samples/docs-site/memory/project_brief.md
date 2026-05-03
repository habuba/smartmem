# Project brief

dx-docs is the single source of truth for the internal developer platform: auth, service templates, CI/CD pipelines, observability, the deploy CLI, and golden-path tutorials.

## Why this exists
Before dx-docs (consolidated 2025-Q3), platform docs were scattered across 9 Confluence spaces, 3 Notion workspaces, and READMEs in 200+ repos. New-hire ramp time to first production deploy was 14 days. Goal: cut that to 3 days and keep it there.

## Scope
- Platform services: auth, secrets, feature flags, eventing, scheduler.
- Tooling: `dx` CLI, service templates, CI workflows, deploy primitives.
- Runbooks owned by the platform team (not product runbooks).
- Architecture explainers for cross-cutting concerns (multi-tenancy, regional failover).

## Out of scope
- Product-team-owned API docs (those live in each product repo and are aggregated, not authored, here).
- Customer-facing docs (different repo, different audience, different legal review).
- Internal HR/ops content.

## Success metrics
- Time-to-first-deploy for a new hire: target 3 days, measured monthly.
- DocSearch satisfaction (thumbs up rate): target >= 75%.
- Stale-page rate (pages untouched > 180 days with traffic > 50/wk): target < 5%.
