#!/usr/bin/env bash
# Install a language pack into a smartmem project.
# Usage: bash install-lang-pack.sh --lang python --path /my/proj [--with-mcp]
set -euo pipefail
LANG_ID=""; PATH_ARG=""; WITH_MCP=0
while [ $# -gt 0 ]; do
  case "$1" in
    --lang) LANG_ID="$2"; shift 2 ;;
    --path) PATH_ARG="$2"; shift 2 ;;
    --with-mcp) WITH_MCP=1; shift ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done
[ -z "$LANG_ID" ] && { echo "missing --lang" >&2; exit 1; }
[ -z "$PATH_ARG" ] && { echo "missing --path" >&2; exit 1; }

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
PACK="$PLUGIN_ROOT/language-packs/$LANG_ID"
[ -d "$PACK" ] || { echo "language pack not found: $LANG_ID" >&2; exit 1; }

# 1. skills
if [ -d "$PACK/skills" ]; then
  for s in "$PACK/skills"/*/; do
    name="$(basename "$s")"
    dst="$PATH_ARG/.claude/skills/$name"
    if [ -e "$dst" ]; then echo "skip skill (exists): $name"; continue; fi
    mkdir -p "$dst"
    cp -r "$s." "$dst/"
    echo "installed skill: $name"
  done
fi

# 2. tech_context snippet
SNIP="$PACK/tech_context.snippet.md"
TECH="$PATH_ARG/memory/tech_context.md"
if [ -f "$SNIP" ] && [ -f "$TECH" ]; then
  MARKER="<!-- smartmem:lang:$LANG_ID -->"
  if grep -qF "$MARKER" "$TECH"; then
    echo "tech_context already has $LANG_ID section, skipping"
  else
    { printf '\n%s\n' "$MARKER"; cat "$SNIP"; printf '\n<!-- smartmem:lang:%s:end -->\n' "$LANG_ID"; } >> "$TECH"
    echo "appended $LANG_ID section to memory/tech_context.md"
  fi
fi

# 3. mcp
if [ "$WITH_MCP" = 1 ]; then
  MCP_SRC="$PACK/mcp_suggestions.md"
  MCP_DST="$PATH_ARG/memory/mcp_suggestions.md"
  if [ -f "$MCP_SRC" ]; then
    MARKER="<!-- smartmem:lang:$LANG_ID -->"
    if [ -f "$MCP_DST" ] && grep -qF "$MARKER" "$MCP_DST"; then
      echo "mcp_suggestions already has $LANG_ID, skipping"
    else
      mkdir -p "$(dirname "$MCP_DST")"
      [ -f "$MCP_DST" ] || printf '# MCP suggestions\n\n' > "$MCP_DST"
      { printf '%s\n' "$MARKER"; cat "$MCP_SRC"; printf '\n'; } >> "$MCP_DST"
      echo "wrote/appended memory/mcp_suggestions.md"
    fi
    echo
    echo "Next: edit .mcp.json with the snippet from memory/mcp_suggestions.md, restart Claude Code, verify with /mcp."
  fi
fi

# 4. record in config
CFG="$PATH_ARG/.claude/smartmem/v1/config.json"
if [ -f "$CFG" ]; then
  python3 - "$CFG" "$LANG_ID" <<'PY'
import json,sys
p,lang=sys.argv[1],sys.argv[2]
c=json.load(open(p))
langs=c.setdefault('languages',[])
if lang not in langs:
  langs.append(lang)
  json.dump(c,open(p,'w'),indent=2)
  print(f"recorded language={lang} in config")
PY
fi

echo
echo "Language pack '$LANG_ID' installed."
