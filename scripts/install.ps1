<#
smartmem non-marketplace install — symlinks (or copies) plugin sources into ~/.claude/plugins/.

Use this when you cannot use `claude plugin marketplace add` (offline, restricted env).
Idempotent: re-running upgrades existing links.

Usage:
  pwsh scripts/install.ps1                 # install all 6 plugins
  pwsh scripts/install.ps1 -Plugins core   # install just core
#>
param(
  [string[]]$Plugins = @('core','software','fullstack','business','data','cli'),
  [switch]$Copy
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$dest = Join-Path $env:USERPROFILE '.claude\plugins'
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Force -Path $dest | Out-Null }

foreach ($p in $Plugins) {
  $name = "smartmem-$p"
  $src = Join-Path $repoRoot "plugins\$name"
  $dst = Join-Path $dest $name
  if (-not (Test-Path $src)) { Write-Host "skip (no source): $name"; continue }
  if (Test-Path $dst) {
    if ((Get-Item $dst).LinkType -or $Copy) { Remove-Item $dst -Recurse -Force }
    else { Write-Host "exists (not a link): $dst — leaving alone"; continue }
  }
  if ($Copy) {
    Copy-Item -Recurse -Path $src -Destination $dst
    Write-Host "copied: $name"
  } else {
    try {
      New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
      Write-Host "linked: $name"
    } catch {
      Write-Host "symlink failed (need admin or dev mode), copying: $name"
      Copy-Item -Recurse -Path $src -Destination $dst
    }
  }
}

Write-Host ""
Write-Host "Installed plugins to: $dest"
Write-Host "Restart Claude Code, then run: /smartmem-init"
