# Tech context — smartmem repo

## Stack
- No build step. Pure markdown + JSON + PowerShell + bash.
- Wizard in PowerShell (`wizard.ps1`) and bash (`wizard.sh`).
- Hook scripts in PowerShell with bash fallbacks for cross-platform.

## Commands
- Local plugin install (no marketplace): `pwsh scripts\install.ps1` or `bash scripts/install.sh`
- Marketplace install: `claude plugin marketplace add file://<repo-abs-path>` then `claude plugin install smartmem-core@smartmem`
- Test wizard standalone: `pwsh plugins\smartmem-core\scripts\wizard.ps1 -ConfigJson '{"name":"x","type":"software-library","description":"d","modelTier":"balanced","hookMode":"full","caveman":"off"}' -Path C:\tmp\test-proj -Overlay software`

## Verification checklist
1. Wizard produces all expected files in a clean target dir.
2. Re-running wizard does not overwrite memory/* or docs/*.
3. `block-secrets` hook returns exit 2 when fed a fake AWS key.
4. PreCompact hook spawns memory-finalizer (manual smoke).
