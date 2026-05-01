param()
$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }
$content = ''
if ($payload.tool_input.content)     { $content += $payload.tool_input.content }
if ($payload.tool_input.new_string)  { $content += $payload.tool_input.new_string }
if (-not $content) { exit 0 }

$patterns = @(
  'AKIA[0-9A-Z]{16}',
  'aws_secret_access_key\s*=\s*[A-Za-z0-9/+=]{30,}',
  '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----',
  'ghp_[A-Za-z0-9]{30,}',
  'sk-(ant|proj|live)-[A-Za-z0-9_-]{20,}',
  'xox[baprs]-[A-Za-z0-9-]{10,}',
  'eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}'
)
foreach ($p in $patterns) {
  if ($content -match $p) {
    [Console]::Error.WriteLine("smartmem block-secrets: matched pattern '$p' in proposed write. Refusing.")
    exit 2
  }
}
exit 0
