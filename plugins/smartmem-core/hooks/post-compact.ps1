param()
$proj = $env:CLAUDE_PROJECT_DIR
if (-not $proj) { exit 0 }
$idx = Join-Path $proj 'memory/MEMORY.md'
$active = Join-Path $proj '.claude/smartmem/v1/active_context.md'
$msg = "## smartmem post-compact reload`n"
if (Test-Path $idx)    { $msg += (Get-Content $idx -Raw) + "`n" }
if (Test-Path $active) { $msg += "`n### active_context`n" + (Get-Content $active -Raw) }
$json = @{ continue = $true; systemMessage = $msg } | ConvertTo-Json -Compress
Write-Output $json
exit 0
