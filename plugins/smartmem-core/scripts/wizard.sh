#!/usr/bin/env bash
# smartmem wizard (bash) — minimal port. For full features (json-merge, prepend-once with marker logic) prefer wizard.ps1.
# Usage: bash wizard.sh --config '<json>' --path <project-dir> [--update] [--overlay <name>]
set -euo pipefail

CONFIG=""
PATH_ARG=""
UPDATE=0
OVERLAY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --config)  CONFIG="$2"; shift 2 ;;
    --path)    PATH_ARG="$2"; shift 2 ;;
    --update)  UPDATE=1; shift ;;
    --overlay) OVERLAY="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done
[ -z "$CONFIG" ] && { echo "missing --config" >&2; exit 1; }
[ -z "$PATH_ARG" ] && { echo "missing --path" >&2; exit 1; }

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
TODAY="$(date +%Y-%m-%d)"

# parse config via python (universally available enough for our targets)
read NAME DESCRIPTION TYPE TIER HOOKMODE CAVEMAN < <(python3 - <<PY
import json,sys
c=json.loads('''$CONFIG''')
print(c.get('name',''), c.get('description',''), c.get('type',''), c.get('modelTier','balanced'), c.get('hookMode','full'), c.get('caveman','off'))
PY
)

case "$TIER" in
  frugal)  M_FIN=haiku;  M_TT=haiku;  M_EXP=haiku;  M_PLAN=haiku;  M_REV=haiku ;;
  premium) M_FIN=sonnet; M_TT=sonnet; M_EXP=sonnet; M_PLAN=opus;   M_REV=sonnet ;;
  *)       M_FIN=haiku;  M_TT=haiku;  M_EXP=sonnet; M_PLAN=opus;   M_REV=sonnet ;;
esac

render() {
  sed -e "s|{{name}}|$NAME|g" \
      -e "s|{{description}}|$DESCRIPTION|g" \
      -e "s|{{type}}|$TYPE|g" \
      -e "s|{{date}}|$TODAY|g" \
      -e "s|{{modelTier}}|$TIER|g" \
      -e "s|{{hookMode}}|$HOOKMODE|g" \
      -e "s|{{caveman}}|$CAVEMAN|g" \
      -e "s|{{MODEL_FINALIZER}}|$M_FIN|g" \
      -e "s|{{MODEL_TASK_TRACKER}}|$M_TT|g" \
      -e "s|{{MODEL_EXPLORER}}|$M_EXP|g" \
      -e "s|{{MODEL_PLANNER}}|$M_PLAN|g" \
      -e "s|{{MODEL_REVIEWER}}|$M_REV|g"
}

apply_file() {
  local src="$1" dst="$2" merge="$3" marker="${4:-}"
  mkdir -p "$(dirname "$dst")"
  if [ "$merge" = "create-only" ] && [ -e "$dst" ]; then
    echo "skip (exists): $dst"; return
  fi
  if [ "$merge" = "prepend-once" ] && [ -e "$dst" ] && grep -qF "$marker" "$dst"; then
    echo "skip (marker present): $dst"; return
  fi
  if [ "$merge" = "append-once" ] && [ -e "$dst" ] && grep -qF "$marker" "$dst"; then
    echo "skip (marker present): $dst"; return
  fi
  local content
  content="$(render < "$src")"
  case "$merge" in
    prepend-once)
      { printf '%s\n%s\n<!-- smartmem:end -->\n\n' "$marker" "$content"; cat "$dst" 2>/dev/null || true; } > "$dst.tmp"
      mv "$dst.tmp" "$dst"
      echo "prepended: $dst" ;;
    append-once)
      printf '\n%s\n' "$content" >> "$dst"
      echo "appended: $dst" ;;
    json-merge)
      if [ -e "$dst" ]; then
        python3 - "$dst" <<PY
import json,sys
old=json.load(open(sys.argv[1]))
new=json.loads('''$content''')
old.setdefault('permissions',{}).setdefault('allow',[])
old['permissions']['allow']=sorted(set(old['permissions']['allow']+new.get('permissions',{}).get('allow',[])))
e=old.setdefault('env',{}); e.update({k:v for k,v in new.get('env',{}).items() if k not in e})
json.dump(old, open(sys.argv[1],'w'), indent=2)
PY
        echo "json-merged: $dst"
      else
        printf '%s' "$content" > "$dst"
        echo "wrote: $dst"
      fi ;;
    *)
      printf '%s' "$content" > "$dst"
      echo "wrote: $dst" ;;
  esac
}

apply_manifest() {
  local manifest="$1" tpl_root="$2"
  [ -f "$manifest" ] || return 0
  python3 - "$manifest" <<'PY' | while IFS=$'\t' read -r src dst merge marker; do
import json,sys
m=json.load(open(sys.argv[1]))
for f in m['files']:
  print('\t'.join([f['src'], f['dst'], f['merge'], f.get('marker','')]))
PY
    apply_file "$tpl_root/$src" "$PATH_ARG/$dst" "$merge" "$marker"
  done
}

echo "smartmem wizard: project=$NAME type=$TYPE tier=$TIER hookMode=$HOOKMODE caveman=$CAVEMAN"
# Overlay first so specialized files win over generic base (create-only semantics).
if [ -n "$OVERLAY" ]; then
  OV_ROOT="$(dirname "$PLUGIN_ROOT")/smartmem-$OVERLAY/templates"
  if [ -d "$OV_ROOT" ]; then
    apply_manifest "$OV_ROOT/manifest.json" "$OV_ROOT"
  else
    echo "overlay not found: $OVERLAY"
  fi
fi
apply_manifest "$PLUGIN_ROOT/templates/manifest.json" "$PLUGIN_ROOT/templates"

case "$CAVEMAN" in
  caveman-plugin) echo; echo "Caveman concise mode selected. Run:"; echo "  claude plugin marketplace add JuliusBrussee/caveman"; echo "  claude plugin install caveman@caveman" ;;
  our-concise)    echo; echo "Our-concise mode: the 'concise' skill from smartmem-core is now active." ;;
esac

cat <<EOF

smartmem ready. Next:
  /status        - briefing
  /prd <slug>    - draft a feature PRD
  /tasks <slug>  - expand PRD into tasks
  /process       - work the next task
EOF
