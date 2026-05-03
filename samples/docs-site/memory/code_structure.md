# Code structure

```
.
├── docs/                       # all MDX content lives here
│   ├── get-started/            # tutorials (~6 pages, high-touch)
│   ├── how-to/                 # task-oriented guides
│   ├── reference/              # tables and specs
│   │   ├── api/                # GENERATED from TSDoc — do not edit
│   │   ├── cli/                # GENERATED from `dx --help` JSON
│   │   └── config/             # hand-written YAML schema docs
│   ├── explanation/            # architecture and rationale
│   └── runbooks/               # platform-team runbooks
├── src/
│   ├── components/             # MDX components used in pages
│   │   ├── CodeFromFile.tsx    # imports a file from samples/ as a code block
│   │   ├── EnvVar.tsx          # renders an env var with description + default
│   │   ├── ServiceCard.tsx     # used on overview pages
│   │   └── VersionBadge.tsx    # pulls dx CLI version from package.json
│   ├── css/                    # custom.css only; theme overrides minimal
│   └── theme/                  # Docusaurus swizzles (footer, nav)
├── samples/                    # runnable snippets imported by <CodeFromFile>
├── scripts/
│   ├── extract-samples.ts      # pulls fenced blocks for CI execution
│   ├── gen-api-ref.ts          # api-extractor → MDX
│   └── gen-cli-ref.ts          # `dx --help --json` → MDX
├── static/                     # images, openapi.yaml downloads
├── sidebars.ts                 # hand-curated IA — DO NOT auto-sort
├── docusaurus.config.ts
└── package.json
```

## Where to add a new page
- New how-to: `docs/how-to/<verb-noun>.mdx`, add to `sidebars.ts` under "How-to".
- New reference: only if it documents a platform-owned surface. Otherwise link out.
- New explanation: requires an issue with the `explainer` label and a reviewer from `@platform-architecture`.
