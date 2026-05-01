#!/usr/bin/env bash
set -e
raw="$(cat)"
[ -z "$raw" ] && exit 0
content="$(printf '%s' "$raw" | python3 -c 'import json,sys
try:
  d=json.loads(sys.stdin.read())
  ti=d.get("tool_input",{})
  print((ti.get("content") or "") + (ti.get("new_string") or ""))
except Exception: pass' 2>/dev/null)"
[ -z "$content" ] && exit 0
patterns=(
  'AKIA[0-9A-Z]{16}'
  '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
  'ghp_[A-Za-z0-9]{30,}'
  'sk-(ant|proj|live)-[A-Za-z0-9_-]{20,}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
)
for p in "${patterns[@]}"; do
  if printf '%s' "$content" | grep -Eq "$p"; then
    echo "smartmem block-secrets: matched '$p'. Refusing." >&2
    exit 2
  fi
done
exit 0
