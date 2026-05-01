<#
smartmem wizard — renders templates into a target project.

Usage:
  pwsh wizard.ps1 -ConfigJson '<json>' -Path <project-dir> [-Update] [-Overlay <name>]

ConfigJson fields: name, type, description, modelTier, hookMode, caveman
#>
param(
  [Parameter(Mandatory=$true)][string]$ConfigJson,
  [Parameter(Mandatory=$true)][string]$Path,
  [switch]$Update,
  [string]$Overlay
)
$ErrorActionPreference = 'Stop'
$cfg = $ConfigJson | ConvertFrom-Json
$pluginRoot = if ($env:CLAUDE_PLUGIN_ROOT) { $env:CLAUDE_PLUGIN_ROOT } else { Split-Path $PSScriptRoot -Parent }
$today = Get-Date -Format 'yyyy-MM-dd'

# --- model tier resolution ---
$tier = if ($cfg.modelTier) { $cfg.modelTier } else { 'balanced' }
$models = switch ($tier) {
  'frugal'   { @{ FINALIZER='haiku'; TASK_TRACKER='haiku'; EXPLORER='haiku';  PLANNER='haiku';  REVIEWER='haiku'  } }
  'premium'  { @{ FINALIZER='sonnet';TASK_TRACKER='sonnet';EXPLORER='sonnet'; PLANNER='opus';   REVIEWER='sonnet' } }
  default    { @{ FINALIZER='haiku'; TASK_TRACKER='haiku'; EXPLORER='sonnet'; PLANNER='opus';   REVIEWER='sonnet' } }
}

# --- substitution map ---
$vars = @{
  '{{name}}'                 = [string]$cfg.name
  '{{description}}'          = [string]$cfg.description
  '{{type}}'                 = [string]$cfg.type
  '{{date}}'                 = $today
  '{{modelTier}}'            = $tier
  '{{hookMode}}'             = if ($cfg.hookMode) { [string]$cfg.hookMode } else { 'full' }
  '{{caveman}}'              = if ($cfg.caveman) { [string]$cfg.caveman } else { 'off' }
  '{{MODEL_FINALIZER}}'      = $models.FINALIZER
  '{{MODEL_TASK_TRACKER}}'   = $models.TASK_TRACKER
  '{{MODEL_EXPLORER}}'       = $models.EXPLORER
  '{{MODEL_PLANNER}}'        = $models.PLANNER
  '{{MODEL_REVIEWER}}'       = $models.REVIEWER
}

function Render-String($s) {
  foreach ($k in $vars.Keys) { $s = $s.Replace($k, $vars[$k]) }
  return $s
}

function Apply-File($srcAbs, $dstAbs, $merge, $marker) {
  $exists = Test-Path $dstAbs
  $content = Render-String (Get-Content $srcAbs -Raw)
  $dstDir = Split-Path $dstAbs -Parent
  if ($dstDir -and -not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force -Path $dstDir | Out-Null }

  switch ($merge) {
    'create-only' {
      if ($exists) { Write-Host "skip (exists): $dstAbs"; return }
      Set-Content -Path $dstAbs -Value $content -Encoding UTF8
      Write-Host "wrote: $dstAbs"
    }
    'overwrite-runtime' {
      if ($Update -and $exists) {
        # merge JSON if both look like JSON
        try {
          $old = Get-Content $dstAbs -Raw | ConvertFrom-Json
          $new = $content | ConvertFrom-Json
          foreach ($p in $new.PSObject.Properties) {
            if (-not $old.PSObject.Properties[$p.Name]) {
              $old | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value
            }
          }
          $merged = $old | ConvertTo-Json -Depth 10
          Set-Content -Path $dstAbs -Value $merged -Encoding UTF8
          Write-Host "merged-runtime: $dstAbs"
          return
        } catch { }
      }
      Set-Content -Path $dstAbs -Value $content -Encoding UTF8
      Write-Host "wrote: $dstAbs"
    }
    'prepend-once' {
      if ($exists) {
        $cur = Get-Content $dstAbs -Raw
        if ($cur -match [regex]::Escape($marker)) { Write-Host "skip (marker present): $dstAbs"; return }
        $block = "$marker`n$content`n<!-- smartmem:end -->`n`n"
        Set-Content -Path $dstAbs -Value ($block + $cur) -Encoding UTF8
        Write-Host "prepended: $dstAbs"
      } else {
        Set-Content -Path $dstAbs -Value $content -Encoding UTF8
        Write-Host "wrote: $dstAbs"
      }
    }
    'append-once' {
      if ($exists) {
        $cur = Get-Content $dstAbs -Raw
        if ($cur -match [regex]::Escape($marker)) { Write-Host "skip (marker present): $dstAbs"; return }
        Add-Content -Path $dstAbs -Value "`n$content" -Encoding UTF8
        Write-Host "appended: $dstAbs"
      } else {
        Set-Content -Path $dstAbs -Value $content -Encoding UTF8
        Write-Host "wrote: $dstAbs"
      }
    }
    'json-merge' {
      $new = $content | ConvertFrom-Json
      if ($exists) {
        try {
          $old = Get-Content $dstAbs -Raw | ConvertFrom-Json
          # merge permissions.allow array (union)
          if ($new.permissions -and $new.permissions.allow) {
            if (-not $old.permissions) { $old | Add-Member -NotePropertyName permissions -NotePropertyValue ([pscustomobject]@{ allow = @() }) }
            if (-not $old.permissions.allow) { $old.permissions | Add-Member -NotePropertyName allow -NotePropertyValue @() }
            $merged = @($old.permissions.allow + $new.permissions.allow | Select-Object -Unique)
            $old.permissions.allow = $merged
          }
          if ($new.env) {
            if (-not $old.env) { $old | Add-Member -NotePropertyName env -NotePropertyValue ([pscustomobject]@{}) }
            foreach ($p in $new.env.PSObject.Properties) {
              if (-not $old.env.PSObject.Properties[$p.Name]) { $old.env | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value }
            }
          }
          Set-Content -Path $dstAbs -Value ($old | ConvertTo-Json -Depth 10) -Encoding UTF8
          Write-Host "json-merged: $dstAbs"
          return
        } catch { Write-Host "json-merge failed, leaving file alone: $dstAbs"; return }
      }
      Set-Content -Path $dstAbs -Value $content -Encoding UTF8
      Write-Host "wrote: $dstAbs"
    }
    default {
      if ($exists -and -not $Update) { Write-Host "skip (exists): $dstAbs"; return }
      Set-Content -Path $dstAbs -Value $content -Encoding UTF8
      Write-Host "wrote: $dstAbs"
    }
  }
}

function Apply-Manifest($manifestPath, $tplRoot) {
  if (-not (Test-Path $manifestPath)) { return }
  $m = Get-Content $manifestPath -Raw | ConvertFrom-Json
  foreach ($f in $m.files) {
    $src = Join-Path $tplRoot $f.src
    $dst = Join-Path $Path $f.dst
    Apply-File $src $dst $f.merge $f.marker
  }
}

# --- run ---
Write-Host "smartmem wizard: project=$($cfg.name) type=$($cfg.type) tier=$tier hookMode=$($vars['{{hookMode}}']) caveman=$($vars['{{caveman}}'])"
Apply-Manifest (Join-Path $pluginRoot 'templates/manifest.json') (Join-Path $pluginRoot 'templates')

if ($Overlay) {
  $overlayRoot = Join-Path (Split-Path $pluginRoot -Parent) "smartmem-$Overlay/templates"
  if (Test-Path $overlayRoot) {
    Apply-Manifest (Join-Path $overlayRoot 'manifest.json') $overlayRoot
  } else {
    Write-Host "overlay not found: $Overlay (looked at $overlayRoot)"
  }
}

# --- caveman handling ---
switch ($vars['{{caveman}}']) {
  'caveman-plugin' {
    Write-Host ""
    Write-Host "Caveman concise mode selected. Run:"
    Write-Host "  claude plugin marketplace add JuliusBrussee/caveman"
    Write-Host "  claude plugin install caveman@caveman"
  }
  'our-concise' {
    Write-Host ""
    Write-Host "Our-concise mode: the 'concise' skill from smartmem-core is now active."
  }
  default { }
}

Write-Host ""
Write-Host "smartmem ready. Next:"
Write-Host "  /status        - briefing"
Write-Host "  /prd <slug>    - draft a feature PRD"
Write-Host "  /tasks <slug>  - expand PRD into tasks"
Write-Host "  /process       - work the next task"
