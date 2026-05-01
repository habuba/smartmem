<#
Install a language pack into a smartmem project.

Usage:
  pwsh install-lang-pack.ps1 -Lang python -Path C:\my-proj [-WithMcp]
#>
param(
  [Parameter(Mandatory=$true)][string]$Lang,
  [Parameter(Mandatory=$true)][string]$Path,
  [switch]$WithMcp
)
$ErrorActionPreference = 'Stop'
$pluginRoot = if ($env:CLAUDE_PLUGIN_ROOT) { $env:CLAUDE_PLUGIN_ROOT } else { Split-Path $PSScriptRoot -Parent }
$packRoot = Join-Path $pluginRoot "language-packs/$Lang"
if (-not (Test-Path $packRoot)) { Write-Error "language pack not found: $Lang at $packRoot"; exit 1 }

# 1. copy skills
$srcSkills = Join-Path $packRoot 'skills'
if (Test-Path $srcSkills) {
  Get-ChildItem $srcSkills -Directory | ForEach-Object {
    $dstSkill = Join-Path $Path ".claude/skills/$($_.Name)"
    if (Test-Path $dstSkill) { Write-Host "skip skill (exists): $($_.Name)"; return }
    New-Item -ItemType Directory -Force -Path $dstSkill | Out-Null
    Copy-Item -Recurse -Force "$($_.FullName)/*" $dstSkill
    Write-Host "installed skill: $($_.Name)"
  }
}

# 2. append tech_context snippet (guarded by marker)
$techSnippetSrc = Join-Path $packRoot 'tech_context.snippet.md'
$techDst = Join-Path $Path 'memory/tech_context.md'
if ((Test-Path $techSnippetSrc) -and (Test-Path $techDst)) {
  $marker = "<!-- smartmem:lang:$Lang -->"
  $cur = Get-Content $techDst -Raw
  if ($cur -and $cur -match [regex]::Escape($marker)) {
    Write-Host "tech_context already has $Lang section, skipping"
  } else {
    $snippet = Get-Content $techSnippetSrc -Raw
    Add-Content -Path $techDst -Value "`n$marker`n$snippet`n<!-- smartmem:lang:$Lang:end -->`n" -Encoding UTF8
    Write-Host "appended $Lang section to memory/tech_context.md"
  }
}

# 3. mcp suggestions
if ($WithMcp) {
  $mcpSrc = Join-Path $packRoot 'mcp_suggestions.md'
  $mcpDst = Join-Path $Path 'memory/mcp_suggestions.md'
  if (Test-Path $mcpSrc) {
    $marker = "<!-- smartmem:lang:$Lang -->"
    if (Test-Path $mcpDst) {
      $cur = Get-Content $mcpDst -Raw
      if ($cur -and $cur -match [regex]::Escape($marker)) { Write-Host "mcp_suggestions already has $Lang, skipping"; }
      else {
        Add-Content -Path $mcpDst -Value "`n$marker`n$(Get-Content $mcpSrc -Raw)`n" -Encoding UTF8
        Write-Host "appended MCP suggestions for $Lang"
      }
    } else {
      $body = "# MCP suggestions`n`n$marker`n$(Get-Content $mcpSrc -Raw)`n"
      New-Item -ItemType Directory -Force -Path (Split-Path $mcpDst -Parent) | Out-Null
      Set-Content -Path $mcpDst -Value $body -Encoding UTF8
      Write-Host "wrote memory/mcp_suggestions.md"
    }
    Write-Host ""
    Write-Host "Next: edit your project's .mcp.json with the snippet from memory/mcp_suggestions.md, then restart Claude Code."
  }
}

# 4. record in config
$cfgPath = Join-Path $Path '.claude/smartmem/v1/config.json'
if (Test-Path $cfgPath) {
  $cfg = Get-Content $cfgPath -Raw | ConvertFrom-Json
  if (-not $cfg.PSObject.Properties['languages']) { $cfg | Add-Member -NotePropertyName languages -NotePropertyValue @() }
  if (-not ($cfg.languages -contains $Lang)) {
    $cfg.languages = @($cfg.languages + $Lang)
    Set-Content -Path $cfgPath -Value ($cfg | ConvertTo-Json -Depth 10) -Encoding UTF8
    Write-Host "recorded language=$Lang in config"
  }
}

Write-Host ""
Write-Host "Language pack '$Lang' installed."
