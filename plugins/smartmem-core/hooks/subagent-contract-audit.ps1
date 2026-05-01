param()
$proj = $env:CLAUDE_PROJECT_DIR
if (-not $proj) { exit 0 }
$transcript = $env:CLAUDE_TRANSCRIPT
if (-not $transcript -or -not (Test-Path $transcript)) { exit 0 }
$tail = Get-Content $transcript -Tail 200 -Raw -ErrorAction SilentlyContinue
if (-not $tail) { exit 0 }
if ($tail -notmatch 'MEMORY_NOTES\s*:') {
  $json = @{ continue = $true; systemMessage = 'smartmem contract audit: subagent did not emit MEMORY_NOTES. If anything memorable happened, add a block before the next turn.' } | ConvertTo-Json -Compress
  Write-Output $json
}
exit 0
