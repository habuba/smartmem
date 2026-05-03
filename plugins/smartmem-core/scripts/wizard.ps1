<#
smartmem wizard — renders templates into a target project.

Usage:
  pwsh wizard.ps1 -ConfigJson '<json>' -Path <project-dir> [-Update] [-Overlay <name>]

ConfigJson fields:
  name, type, description, modelTier, hookMode, caveman, memoryLanguage,
  autoMemory, updateMode, memoryFiles[], alwaysLoaded[]
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

# --- canonical memory file registry ---
# Single source of truth for known memory files. /memory-files command uses the same names.
$FILE_REGISTRY = @{
  'project_brief'       = @{ title = 'Project brief';        purpose = 'What this project is and why it exists.' }
  'product_context'     = @{ title = 'Product context';      purpose = 'Users, problems being solved, success criteria.' }
  'design_goals'        = @{ title = 'Design goals';         purpose = 'Priorities and trade-off rules.' }
  'system_requirements' = @{ title = 'System requirements';  purpose = 'Functional (FR-) and non-functional (NFR-) requirements.' }
  'glossary'            = @{ title = 'Glossary';             purpose = 'Project-specific terms.' }
  'architecture'        = @{ title = 'Architecture';         purpose = 'High-level system architecture and component layout.' }
  'code_structure'      = @{ title = 'Code structure';       purpose = 'Where code lives in the repo.' }
  'system_patterns'     = @{ title = 'System patterns';      purpose = 'Code conventions and recurring patterns.' }
  'tech_context'        = @{ title = 'Tech context';         purpose = 'Stack, versions, build/test/run commands.' }
  'db_structure'        = @{ title = 'Database structure';   purpose = 'Schema, migrations, key tables.' }
  'ui_structure'        = @{ title = 'UI structure';         purpose = 'Routes, screens, component tree, design system.' }
  'api_surface'         = @{ title = 'API surface';          purpose = 'Endpoints, contracts, RPC methods.' }
  'active_context'      = @{ title = 'Active context';       purpose = 'Current focus, recent decisions, open threads.' }
  'tasks'               = @{ title = 'Tasks';                purpose = 'Open / blocked / done.' }
  'progress'            = @{ title = 'Progress';             purpose = 'Append-only milestone log.' }
  'commands'            = @{ title = 'Commands';             purpose = 'Frequently-used shell command bookmarks.' }
  'decisions'           = @{ title = 'Decisions';            purpose = 'Local mirror of docs/DECISIONS.md (ADR-lite).' }
  'stakeholders'        = @{ title = 'Stakeholders';         purpose = 'Who cares, what they care about, escalation paths.' }
  'processes'           = @{ title = 'Processes';            purpose = 'Business workflows / BPMN summaries.' }
  'slas'                = @{ title = 'SLAs';                 purpose = 'Service-level agreements and timeliness targets.' }
  'datasets'            = @{ title = 'Datasets';             purpose = 'Source data, versions, splits.' }
  'experiments'         = @{ title = 'Experiments';          purpose = 'Recent experiment register.' }
  'model_registry'      = @{ title = 'Model registry';       purpose = 'Production + candidate models.' }
}

# --- type-based defaults (which files to include if user did not pick) ---
$TYPE_DEFAULTS = @{
  'software-library'   = @('project_brief','design_goals','architecture','code_structure','system_patterns','tech_context','active_context','tasks','decisions','commands','progress')
  'cli-tool'           = @('project_brief','design_goals','architecture','code_structure','system_patterns','tech_context','active_context','tasks','decisions','commands','progress')
  'fullstack-web'      = @('project_brief','product_context','design_goals','system_requirements','architecture','code_structure','system_patterns','tech_context','db_structure','ui_structure','api_surface','active_context','tasks','decisions','commands','progress')
  'business-workflow'  = @('project_brief','product_context','design_goals','system_requirements','stakeholders','processes','slas','active_context','tasks','decisions','progress')
  'data-ml'            = @('project_brief','design_goals','architecture','datasets','experiments','model_registry','tech_context','system_patterns','active_context','tasks','decisions','commands','progress')
  'other'              = @('project_brief','design_goals','active_context','tasks','decisions','progress')
}

$ALWAYS_LOADED_DEFAULT = @('active_context','tasks')

# --- model tier resolution ---
$tier = if ($cfg.modelTier) { $cfg.modelTier } else { 'balanced' }
$models = switch ($tier) {
  'frugal'   { @{ FINALIZER='haiku'; TASK_TRACKER='haiku'; EXPLORER='haiku';  PLANNER='haiku';  REVIEWER='haiku'  } }
  'premium'  { @{ FINALIZER='sonnet';TASK_TRACKER='sonnet';EXPLORER='sonnet'; PLANNER='opus';   REVIEWER='sonnet' } }
  default    { @{ FINALIZER='haiku'; TASK_TRACKER='haiku'; EXPLORER='sonnet'; PLANNER='opus';   REVIEWER='sonnet' } }
}

# --- resolve selectedFiles + alwaysLoaded + updateMode ---
$type = if ($cfg.type) { [string]$cfg.type } else { 'other' }
$selectedFiles = if ($cfg.memoryFiles -and $cfg.memoryFiles.Count -gt 0) {
  @($cfg.memoryFiles | ForEach-Object { [string]$_ })
} elseif ($TYPE_DEFAULTS.ContainsKey($type)) {
  $TYPE_DEFAULTS[$type]
} else {
  $TYPE_DEFAULTS['other']
}
$alwaysLoaded = if ($cfg.alwaysLoaded -and $cfg.alwaysLoaded.Count -gt 0) {
  @($cfg.alwaysLoaded | ForEach-Object { [string]$_ })
} else {
  @($ALWAYS_LOADED_DEFAULT | Where-Object { $selectedFiles -contains $_ })
}
$updateMode = if ($cfg.updateMode) { [string]$cfg.updateMode } else { 'auto' }
$updateModeRule = switch ($updateMode) {
  'manual' { 'manual — run `/memory-sync` when ready; nothing writes memory until you approve the proposed diff.' }
  default  { 'automatic — `memory-finalizer` runs on Stop and PreCompact, applying scratch notes without prompting.' }
}

# --- memoryImports block for CLAUDE.md ---
$importLines = @('@memory/MEMORY.md')
foreach ($f in $alwaysLoaded) {
  if ($selectedFiles -contains $f) { $importLines += "@memory/$f.md" }
}
$memoryImports = ($importLines -join "`n")

# --- substitution map ---
$vars = @{
  '{{name}}'                 = [string]$cfg.name
  '{{description}}'          = [string]$cfg.description
  '{{type}}'                 = $type
  '{{date}}'                 = $today
  '{{modelTier}}'            = $tier
  '{{hookMode}}'             = if ($cfg.hookMode) { [string]$cfg.hookMode } else { 'full' }
  '{{caveman}}'              = if ($cfg.caveman) { [string]$cfg.caveman } else { 'off' }
  '{{updateMode}}'           = $updateMode
  '{{updateModeRule}}'       = $updateModeRule
  '{{memoryImports}}'        = $memoryImports
  '{{memoryFilesJson}}'      = ($selectedFiles | ConvertTo-Json -Compress)
  '{{alwaysLoadedJson}}'     = ($alwaysLoaded | ConvertTo-Json -Compress)
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

function Generate-MemoryFile($name, $dstAbs) {
  if (Test-Path $dstAbs) { Write-Host "skip (exists): $dstAbs"; return }
  $entry = $FILE_REGISTRY[$name]
  $title = if ($entry) { $entry.title } else { ($name -replace '_',' ').Substring(0,1).ToUpper() + ($name -replace '_',' ').Substring(1) }
  $purpose = if ($entry) { $entry.purpose } else { '' }
  $body = "# $title`n"
  if ($purpose) { $body += "<!-- Purpose: $purpose -->`n" }
  $body += "`n"
  $dstDir = Split-Path $dstAbs -Parent
  if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force -Path $dstDir | Out-Null }
  Set-Content -Path $dstAbs -Value $body -Encoding UTF8
  Write-Host "wrote: $dstAbs"
}

function Generate-MemoryIndex($dstAbs, $files, $always) {
  if (Test-Path $dstAbs) { Write-Host "skip (exists): $dstAbs"; return }
  $lines = @('# Memory index','')
  $lines += '## Always-loaded'
  if ($always.Count -eq 0) {
    $lines += '_(none — only this index is always-loaded)_'
  } else {
    foreach ($f in $always) {
      $entry = $FILE_REGISTRY[$f]
      $hook = if ($entry) { $entry.purpose } else { '' }
      $lines += "- [$f]($f.md)$(if ($hook) { ' — ' + $hook })"
    }
  }
  $lines += ''
  $lines += '## On demand'
  $on = $files | Where-Object { $always -notcontains $_ }
  if ($on.Count -eq 0) {
    $lines += '_(none yet — add with `/memory-files add <name>`)_'
  } else {
    foreach ($f in $on) {
      $entry = $FILE_REGISTRY[$f]
      $hook = if ($entry) { $entry.purpose } else { '' }
      $lines += "- [$f]($f.md)$(if ($hook) { ' — ' + $hook })"
    }
  }
  $lines += ''
  $body = ($lines -join "`n") + "`n"
  $dstDir = Split-Path $dstAbs -Parent
  if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Force -Path $dstDir | Out-Null }
  Set-Content -Path $dstAbs -Value $body -Encoding UTF8
  Write-Host "wrote: $dstAbs"
}

# --- run ---
$memLang = if ($cfg.memoryLanguage) { [string]$cfg.memoryLanguage } else { 'en' }
$baseManifest = if ($memLang -eq 'he') { 'templates/manifest_he.json' } else { 'templates/manifest.json' }
$vars['{{memoryLanguage}}'] = $memLang

$autoMem = if ($cfg.autoMemory) { [string]$cfg.autoMemory } else { 'keep' }
$vars['{{autoMemory}}'] = $autoMem
$vars['{{autoMemoryEnabled}}'] = if ($autoMem -eq 'off') { 'false' } else { 'true' }

Write-Host "smartmem wizard: project=$($cfg.name) type=$type tier=$tier hookMode=$($vars['{{hookMode}}']) updateMode=$updateMode files=$($selectedFiles.Count)"

if ($Overlay) {
  $overlayRoot = Join-Path (Split-Path $pluginRoot -Parent) "smartmem-$Overlay/templates"
  if (Test-Path $overlayRoot) {
    Apply-Manifest (Join-Path $overlayRoot 'manifest.json') $overlayRoot
  } else {
    Write-Host "overlay not found: $Overlay (looked at $overlayRoot)"
  }
}
Apply-Manifest (Join-Path $pluginRoot $baseManifest) (Join-Path $pluginRoot 'templates')

# Generate memory/ files based on selectedFiles
foreach ($f in $selectedFiles) {
  Generate-MemoryFile $f (Join-Path $Path "memory/$f.md")
}
Generate-MemoryIndex (Join-Path $Path 'memory/MEMORY.md') $selectedFiles $alwaysLoaded

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
Write-Host "smartmem ready. Selected memory files: $($selectedFiles -join ', ')"
Write-Host "Always-loaded:                          $($alwaysLoaded -join ', ')"
Write-Host "Update mode:                            $updateMode"
Write-Host ""
Write-Host "Next:"
Write-Host "  /status                 - briefing"
Write-Host "  /memory-files list      - show current memory file set"
Write-Host "  /memory-files add <n>   - add a memory file"
Write-Host "  /prd <slug>             - draft a feature PRD"
