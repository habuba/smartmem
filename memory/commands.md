# Commands — smartmem

## install
### marketplace
`claude plugin marketplace add habuba/smartmem`

### marketplace-install-core
`claude plugin install smartmem-core@smartmem`

### local-marketplace
`claude plugin marketplace add file:///absolute/path/to/smartmem`

### symlink-fallback-windows
`pwsh scripts\install.ps1`

### symlink-fallback-unix
`bash scripts/install.sh`

## smoke-test
### wizard-en
`pwsh plugins\smartmem-core\scripts\wizard.ps1 -ConfigJson '{"name":"smoke","type":"software-library","description":"smoke","modelTier":"balanced","hookMode":"full","caveman":"off","memoryLanguage":"en","autoMemory":"keep"}' -Path C:\tmp\smoke -Overlay software`

### wizard-he
`pwsh plugins\smartmem-core\scripts\wizard.ps1 -ConfigJson '{"name":"smoke-he","type":"software-library","description":"smoke","modelTier":"balanced","hookMode":"full","caveman":"off","memoryLanguage":"he","autoMemory":"keep"}' -Path C:\tmp\smoke-he`

### lang-pack-python
`pwsh plugins\smartmem-core\scripts\install-lang-pack.ps1 -Lang python -Path C:\tmp\smoke -WithMcp`

## release
### tag
`git tag v0.x.y && git push --tags`

### gh-release
`gh release create v0.x.y --title "v0.x.y — <subject>" --notes "..."`

## misc
### show-tree
`git ls-files | head -120`
