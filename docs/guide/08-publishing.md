# Publishing your own fork

You can fork smartmem, customize it, and publish your own marketplace.

## Fork & rename

1. Fork on GitHub.
2. Search-and-replace `smartmem` → `<your-name>` (or keep the family name).
3. Edit `.claude-plugin/marketplace.json` `owner` field.
4. Bump every plugin's `version` to `0.1.0`.
5. Commit + push.

## Publish a release

```bash
# bump versions in plugin.json files
git add -A
git commit -m "v0.x.y"
git tag v0.x.y
git push --tags
```

Users install with:
```
claude plugin marketplace add <you>/<your-fork>
claude plugin install smartmem-core@<your-fork>
```

Updates ride on:
```
claude plugin update --all
```

## Adding a custom project-type template

Inside the cloned repo, run Claude Code:
```
/smartmem-new-template
```

Answer:
- New template name (e.g. `mobile-app`, `firmware`)
- Base to fork from (an existing overlay or `_base`)
- One-line description
- Extra memory files (comma-separated)
- Extra subagents (becomes stub `.md` files)
- Extra slash commands

The skill writes `plugins/smartmem-<name>/`, registers it in `marketplace.json`, and prints a test-install command.

## Adding a language pack

See [language-packs.md § Adding your own language pack](06-language-packs.md#adding-your-own-language-pack).

## Versioning policy

- **Patch** (`0.x.Y`) — bug fixes, doc updates, no schema changes.
- **Minor** (`0.X.y`) — new memory files, new commands, new overlays. Backward-compatible re-init via `/project-update`.
- **Major** (`X.y.z`) — schema changes that break existing projects. Provide migration notes in `docs/CHANGELOG.md`.
