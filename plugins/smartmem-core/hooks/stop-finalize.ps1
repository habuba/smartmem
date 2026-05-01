param()
$proj = $env:CLAUDE_PROJECT_DIR
if (-not $proj) { exit 0 }
$cfg = Join-Path $proj '.claude/smartmem/v1/config.json'
$mode = 'full'
if (Test-Path $cfg) {
  try { $mode = (Get-Content $cfg -Raw | ConvertFrom-Json).hookMode } catch { }
}
if ($mode -ne 'full') { exit 0 }
$json = @{ continue = $true; systemMessage = "Run the memory-finalizer agent now to distill MEMORY_NOTES into project memory before this turn ends." } | ConvertTo-Json -Compress
Write-Output $json
exit 0
