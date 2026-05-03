# Tech context

## Stack
- Docusaurus 3.5, MDX 3, React 18, TypeScript strict.
- Node 20 LTS, pnpm 9 (corepack-pinned in `package.json`).
- Algolia DocSearch (crawler config in `.algolia/config.json`).
- Vercel for hosting; preview deploy per PR, production on merge to `main`.
- Lychee for link checking; api-extractor for API ref generation.

## Local commands
```
pnpm install          # corepack auto-pins pnpm version
pnpm start            # dev server, http://localhost:3000, hot reload
pnpm build            # production build into build/, fails on broken internal links
pnpm serve            # serve the production build locally
pnpm typecheck        # tsc --noEmit, strict
pnpm lint             # eslint + prettier --check
pnpm format           # prettier --write
pnpm test:samples     # extract and execute every fenced sample
pnpm check:links      # lychee against built site, external + internal
pnpm gen:ref          # regenerate /docs/reference/api and /docs/reference/cli
pnpm algolia:reindex  # POST to crawler API; requires ALGOLIA_ADMIN_KEY
```

## CI gates (GitHub Actions, `.github/workflows/ci.yml`)
1. `pnpm install --frozen-lockfile`
2. `pnpm typecheck`
3. `pnpm lint`
4. `pnpm build`
5. `pnpm test:samples` (matrix: Node 20, dx CLI pinned version)
6. `pnpm check:links --offline` on PRs; full external check nightly via `link-check.yml`.
7. Frontmatter validator (`scripts/check-frontmatter.ts`): rejects missing `owner` or `last_reviewed`.

## Deploy
- PR → Vercel preview, URL posted by bot.
- Merge to `main` → production deploy + Algolia reindex via post-deploy hook.
- Rollback: redeploy previous Vercel deployment from dashboard; no DB to migrate.

## Secrets
- `ALGOLIA_ADMIN_KEY`, `VERCEL_TOKEN`: GitHub Actions secrets, scoped to this repo.
- No secrets in MDX. Pre-commit hook scans for likely tokens.
