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
  if ($null -eq $s -or $s -eq '') { return '' }
  foreach ($k in $vars.Keys) { $s = $s.Replace($k, $vars[$k]) }
  return $s
}

function Apply-File($srcAbs, $dstAbs, $merge, $marker) {
  $exists = Test-Path $dstAbs
  $raw = Get-Content $srcAbs -Raw
  if ($null -eq $raw) { $raw = '' }
  $content = Render-String $raw
  $dstDir = Split-Path $dstAbs -Parent
  if ($dstDir -and -not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force -Path $dstDir | Out-Null }

  switch ($merge) {
    'create-only' {
      if ($exists) { Write-Host "skip (exists): $dstAbs"; return }
      Set-Content -Path $dstAbs -Value $content -Encoding UTF8
      Write-Host "wrote: $dstAbs"
    }
    'overwrite-runtime' {
      # On any re-run, preserve user-edited fields by merging: new template fields are added,
      # existing fields keep the user's value (or new value if -Update was passed).
      if ($exists) {
        try {
          $old = Get-Content $dstAbs -Raw | ConvertFrom-Json
          $new = $content | ConvertFrom-Json
          foreach ($p in $new.PSObject.Properties) {
            if (-not $old.PSObject.Properties[$p.Name]) {
              $old | Add-Member -NotePropertyName $p.Name -NotePropertyValue $p.Value
            } elseif ($Update) {
              $old.($p.Name) = $p.Value
            }
          }
          Set-Content -Path $dstAbs -Value ($old | ConvertTo-Json -Depth 10) -Encoding UTF8
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
        if ($null -eq $cur) { $cur = '' }
        if ($cur -match [regex]::Escape($marker)) { Write-Host "skip (marker present): $dstAbs"; return }
        $block = "$marker`n$content`n<!-- smartmem:end -->`n`n"
        Set-Content -Path $dstAbs -Value ($block + $cur) -Encoding UTF8
        Write-Host "prepended: $dstAbs"
      } else {
        $block = "$marker`n$content`n<!-- smartmem:end -->`n"
        Set-Content -Path $dstAbs -Value $block -Encoding UTF8
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
# Memory language: 'en' (default) uses _base; 'he' uses _base_he. Recommend keeping 'en' even if chatting in another language — saves tokens.
$memLang = if ($cfg.memoryLanguage) { [string]$cfg.memoryLanguage } else { 'en' }
$baseManifest = if ($memLang -eq 'he') { 'templates/manifest_he.json' } else { 'templates/manifest.json' }
$vars['{{memoryLanguage}}'] = $memLang

# autoMemory: keep (default) | off (sets autoMemoryEnabled:false) | mirror (finalizer reads auto-memory)
$autoMem = if ($cfg.autoMemory) { [string]$cfg.autoMemory } else { 'keep' }
$vars['{{autoMemory}}'] = $autoMem
$vars['{{autoMemoryEnabled}}'] = if ($autoMem -eq 'off') { 'false' } else { 'true' }

Write-Host "smartmem wizard: project=$($cfg.name) type=$($cfg.type) tier=$tier hookMode=$($vars['{{hookMode}}']) caveman=$($vars['{{caveman}}']) memoryLang=$memLang"
# Overlay first so specialized files win over generic base.
if ($Overlay) {
  $overlayRoot = Join-Path (Split-Path $pluginRoot -Parent) "smartmem-$Overlay/templates"
  if (Test-Path $overlayRoot) {
    Apply-Manifest (Join-Path $overlayRoot 'manifest.json') $overlayRoot
  } else {
    Write-Host "overlay not found: $Overlay (looked at $overlayRoot)"
  }
}
Apply-Manifest (Join-Path $pluginRoot $baseManifest) (Join-Path $pluginRoot 'templates')

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
