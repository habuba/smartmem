param()
$ErrorActionPreference = 'Stop'
$proj = $env:CLAUDE_PROJECT_DIR
if (-not $proj) { exit 0 }
$active = Join-Path $proj '.claude/smartmem/v1/active_context.md'
$tasks  = Join-Path $proj 'memory/tasks.md'
$msg = "## smartmem briefing`n"
if (Test-Path $active) { $msg += (Get-Content $active -Raw -ErrorAction SilentlyContinue) + "`n" }
if (Test-Path $tasks)  { $msg += "`n### Open tasks`n" + ((Get-Content $tasks -Raw) -split "## Done")[0] }
$json = @{ continue = $true; systemMessage = $msg } | ConvertTo-Json -Compress
Write-Output $json
exit 0
