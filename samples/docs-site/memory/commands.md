# Commands

## Daily authoring
```
pnpm start                  # dev server with hot reload
pnpm typecheck              # before opening a PR
pnpm test:samples           # if you touched a fenced code block
```

## Before merging
```
pnpm build                  # catches broken internal links
pnpm check:links --offline  # internal-only link sweep
pnpm lint
```

## Reference regeneration
```
pnpm gen:ref                # regenerates /docs/reference/api and /cli
git diff docs/reference/    # review carefully; large diffs are normal after CLI bumps
```

## Search
```
pnpm algolia:reindex        # manual reindex; usually unnecessary, runs post-deploy
```

## Troubleshooting
```
rm -rf .docusaurus build node_modules/.cache
pnpm install
pnpm start
```
Docusaurus cache corruption shows up as "Cannot find module" for files that exist. The above clears it.

## Release / rollback
- Production deploys on merge to `main`. No manual step.
- Rollback: Vercel dashboard → Deployments → previous green deploy → Promote to Production. Then re-trigger Algolia reindex from Actions.
