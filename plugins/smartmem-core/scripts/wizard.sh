#!/usr/bin/env bash
# smartmem wizard (bash). Most logic delegates to python heredocs; PowerShell version is canonical.
# Usage: bash wizard.sh --config '<json>' --path <project-dir> [--update] [--overlay <name>]
set -euo pipefail

CONFIG=""; PATH_ARG=""; UPDATE=0; OVERLAY=""
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

export SMARTMEM_CFG="$CONFIG"
export SMARTMEM_PATH="$PATH_ARG"
export SMARTMEM_PLUGIN_ROOT="$PLUGIN_ROOT"
export SMARTMEM_TODAY="$TODAY"
export SMARTMEM_OVERLAY="$OVERLAY"
export SMARTMEM_UPDATE="$UPDATE"

python3 - <<'PY'
import json, os, re, sys
from pathlib import Path

cfg = json.loads(os.environ['SMARTMEM_CFG'])
target = Path(os.environ['SMARTMEM_PATH'])
plugin_root = Path(os.environ['SMARTMEM_PLUGIN_ROOT'])
today = os.environ['SMARTMEM_TODAY']
overlay = os.environ['SMARTMEM_OVERLAY']
update_flag = os.environ['SMARTMEM_UPDATE'] == '1'

REGISTRY = {
  'project_brief':       ('Project brief',        'What this project is and why it exists.'),
  'product_context':     ('Product context',      'Users, problems being solved, success criteria.'),
  'design_goals':        ('Design goals',         'Priorities and trade-off rules.'),
  'system_requirements': ('System requirements',  'Functional (FR-) and non-functional (NFR-) requirements.'),
  'glossary':            ('Glossary',             'Project-specific terms.'),
  'architecture':        ('Architecture',         'High-level system architecture and component layout.'),
  'code_structure':      ('Code structure',       'Where code lives in the repo.'),
  'system_patterns':     ('System patterns',      'Code conventions and recurring patterns.'),
  'tech_context':        ('Tech context',         'Stack, versions, build/test/run commands.'),
  'db_structure':        ('Database structure',   'Schema, migrations, key tables.'),
  'ui_structure':        ('UI structure',         'Routes, screens, component tree, design system.'),
  'api_surface':         ('API surface',          'Endpoints, contracts, RPC methods.'),
  'active_context':      ('Active context',       'Current focus, recent decisions, open threads.'),
  'tasks':               ('Tasks',                'Open / blocked / done.'),
  'progress':            ('Progress',             'Append-only milestone log.'),
  'commands':            ('Commands',             'Frequently-used shell command bookmarks.'),
  'decisions':           ('Decisions',            'Local mirror of docs/DECISIONS.md (ADR-lite).'),
  'stakeholders':        ('Stakeholders',         'Who cares, what they care about, escalation paths.'),
  'processes':           ('Processes',            'Business workflows / BPMN summaries.'),
  'slas':                ('SLAs',                 'Service-level agreements and timeliness targets.'),
  'datasets':            ('Datasets',             'Source data, versions, splits.'),
  'experiments':         ('Experiments',          'Recent experiment register.'),
  'model_registry':      ('Model registry',       'Production + candidate models.'),
}

TYPE_DEFAULTS = {
  'software-library':  ['project_brief','design_goals','architecture','code_structure','system_patterns','tech_context','active_context','tasks','decisions','commands','progress'],
  'cli-tool':          ['project_brief','design_goals','architecture','code_structure','system_patterns','tech_context','active_context','tasks','decisions','commands','progress'],
  'fullstack-web':     ['project_brief','product_context','design_goals','system_requirements','architecture','code_structure','system_patterns','tech_context','db_structure','ui_structure','api_surface','active_context','tasks','decisions','commands','progress'],
  'business-workflow': ['project_brief','product_context','design_goals','system_requirements','stakeholders','processes','slas','active_context','tasks','decisions','progress'],
  'data-ml':           ['project_brief','design_goals','architecture','datasets','experiments','model_registry','tech_context','system_patterns','active_context','tasks','decisions','commands','progress'],
  'other':             ['project_brief','design_goals','active_context','tasks','decisions','progress'],
}

ALWAYS_DEFAULT = ['active_context','tasks']

ptype = cfg.get('type','other')
selected = cfg.get('memoryFiles') or TYPE_DEFAULTS.get(ptype, TYPE_DEFAULTS['other'])
always = cfg.get('alwaysLoaded') or [f for f in ALWAYS_DEFAULT if f in selected]
update_mode = cfg.get('updateMode','auto')
mem_lang = cfg.get('memoryLanguage','en')
auto_mem = cfg.get('autoMemory','keep')
tier = cfg.get('modelTier','balanced')

models = {
  'frugal':  dict(F='haiku',T='haiku',E='haiku',P='haiku',R='haiku'),
  'premium': dict(F='sonnet',T='sonnet',E='sonnet',P='opus',R='sonnet'),
}.get(tier, dict(F='haiku',T='haiku',E='sonnet',P='opus',R='sonnet'))

update_rule = ('manual — run `/memory-sync` when ready; nothing writes memory until you approve the proposed diff.'
               if update_mode == 'manual'
               else 'automatic — `memory-finalizer` runs on Stop and PreCompact, applying scratch notes without prompting.')

import_lines = ['@memory/MEMORY.md'] + [f'@memory/{f}.md' for f in always if f in selected]
memory_imports = '\n'.join(import_lines)

vars_ = {
  '{{name}}': cfg.get('name',''),
  '{{description}}': cfg.get('description',''),
  '{{type}}': ptype,
  '{{date}}': today,
  '{{modelTier}}': tier,
  '{{hookMode}}': cfg.get('hookMode','full'),
  '{{caveman}}': cfg.get('caveman','off'),
  '{{updateMode}}': update_mode,
  '{{updateModeRule}}': update_rule,
  '{{memoryImports}}': memory_imports,
  '{{memoryFilesJson}}': json.dumps(selected),
  '{{alwaysLoadedJson}}': json.dumps(always),
  '{{memoryLanguage}}': mem_lang,
  '{{autoMemory}}': auto_mem,
  '{{autoMemoryEnabled}}': 'false' if auto_mem == 'off' else 'true',
  '{{MODEL_FINALIZER}}': models['F'],
  '{{MODEL_TASK_TRACKER}}': models['T'],
  '{{MODEL_EXPLORER}}': models['E'],
  '{{MODEL_PLANNER}}': models['P'],
  '{{MODEL_REVIEWER}}': models['R'],
}

def render(s):
  if not s: return ''
  for k, v in vars_.items(): s = s.replace(k, str(v))
  return s

def apply_file(src, dst, merge, marker=''):
  dst.parent.mkdir(parents=True, exist_ok=True)
  exists = dst.exists()
  raw = src.read_text(encoding='utf-8') if src.exists() else ''
  content = render(raw)
  if merge == 'create-only':
    if exists: print(f'skip (exists): {dst}'); return
    dst.write_text(content, encoding='utf-8'); print(f'wrote: {dst}'); return
  if merge == 'prepend-once':
    if exists:
      cur = dst.read_text(encoding='utf-8')
      if marker in cur: print(f'skip (marker present): {dst}'); return
      dst.write_text(f'{marker}\n{content}\n<!-- smartmem:end -->\n\n' + cur, encoding='utf-8')
      print(f'prepended: {dst}'); return
    dst.write_text(f'{marker}\n{content}\n<!-- smartmem:end -->\n', encoding='utf-8')
    print(f'wrote: {dst}'); return
  if merge == 'append-once':
    if exists:
      cur = dst.read_text(encoding='utf-8')
      if marker in cur: print(f'skip (marker present): {dst}'); return
      with dst.open('a', encoding='utf-8') as fh: fh.write('\n' + content)
      print(f'appended: {dst}'); return
    dst.write_text(content, encoding='utf-8'); print(f'wrote: {dst}'); return
  if merge == 'json-merge':
    new = json.loads(content)
    if exists:
      try:
        old = json.loads(dst.read_text(encoding='utf-8'))
        if 'permissions' in new and 'allow' in new['permissions']:
          old.setdefault('permissions', {}).setdefault('allow', [])
          old['permissions']['allow'] = sorted(set(old['permissions']['allow'] + new['permissions']['allow']))
        if 'env' in new:
          e = old.setdefault('env', {})
          for k, v in new['env'].items():
            if k not in e: e[k] = v
        dst.write_text(json.dumps(old, indent=2), encoding='utf-8')
        print(f'json-merged: {dst}'); return
      except Exception:
        print(f'json-merge failed, leaving alone: {dst}'); return
    dst.write_text(content, encoding='utf-8'); print(f'wrote: {dst}'); return
  if merge == 'overwrite-runtime':
    if exists:
      try:
        old = json.loads(dst.read_text(encoding='utf-8'))
        new = json.loads(content)
        for k, v in new.items():
          if k not in old or update_flag: old[k] = v
        dst.write_text(json.dumps(old, indent=2), encoding='utf-8')
        print(f'merged-runtime: {dst}'); return
      except Exception: pass
    dst.write_text(content, encoding='utf-8'); print(f'wrote: {dst}'); return
  # default
  if exists and not update_flag: print(f'skip (exists): {dst}'); return
  dst.write_text(content, encoding='utf-8'); print(f'wrote: {dst}')

def apply_manifest(manifest_path, tpl_root):
  if not manifest_path.exists(): return
  m = json.loads(manifest_path.read_text(encoding='utf-8'))
  for f in m['files']:
    apply_file(tpl_root / f['src'], target / f['dst'], f['merge'], f.get('marker',''))

def gen_memory_file(name):
  dst = target / 'memory' / f'{name}.md'
  if dst.exists(): print(f'skip (exists): {dst}'); return
  title, purpose = REGISTRY.get(name, (name.replace('_',' ').title(), ''))
  body = f'# {title}\n'
  if purpose: body += f'<!-- Purpose: {purpose} -->\n'
  body += '\n'
  dst.parent.mkdir(parents=True, exist_ok=True)
  dst.write_text(body, encoding='utf-8'); print(f'wrote: {dst}')

def gen_index():
  dst = target / 'memory' / 'MEMORY.md'
  if dst.exists(): print(f'skip (exists): {dst}'); return
  lines = ['# Memory index','','## Always-loaded']
  if not always:
    lines.append('_(none — only this index is always-loaded)_')
  else:
    for f in always:
      _, p = REGISTRY.get(f, (f, ''))
      lines.append(f'- [{f}]({f}.md)' + (f' — {p}' if p else ''))
  lines.append('')
  lines.append('## On demand')
  rest = [f for f in selected if f not in always]
  if not rest:
    lines.append('_(none yet — add with `/memory-files add <name>`)_')
  else:
    for f in rest:
      _, p = REGISTRY.get(f, (f, ''))
      lines.append(f'- [{f}]({f}.md)' + (f' — {p}' if p else ''))
  lines.append('')
  dst.parent.mkdir(parents=True, exist_ok=True)
  dst.write_text('\n'.join(lines) + '\n', encoding='utf-8'); print(f'wrote: {dst}')

base_manifest = 'templates/manifest_he.json' if mem_lang == 'he' else 'templates/manifest.json'

print(f"smartmem wizard: project={cfg.get('name')} type={ptype} tier={tier} hookMode={vars_['{{hookMode}}']} updateMode={update_mode} files={len(selected)}")

if overlay:
  ov_root = plugin_root.parent / f'smartmem-{overlay}' / 'templates'
  if ov_root.exists():
    apply_manifest(ov_root / 'manifest.json', ov_root)
  else:
    print(f'overlay not found: {overlay}')

apply_manifest(plugin_root / base_manifest, plugin_root / 'templates')

for f in selected:
  gen_memory_file(f)
gen_index()

print()
print(f"smartmem ready. Selected memory files: {', '.join(selected)}")
print(f"Always-loaded:                          {', '.join(always)}")
print(f"Update mode:                            {update_mode}")
PY

case "$(echo "$CONFIG" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("caveman","off"))')" in
  caveman-plugin) echo; echo "Caveman concise mode selected. Run:"; echo "  claude plugin marketplace add JuliusBrussee/caveman"; echo "  claude plugin install caveman@caveman" ;;
  our-concise)    echo; echo "Our-concise mode: the 'concise' skill from smartmem-core is now active." ;;
esac
