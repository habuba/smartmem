#!/usr/bin/env bash
set -e
proj="${CLAUDE_PROJECT_DIR:-}"
[ -z "$proj" ] && exit 0
msg="## smartmem briefing"$'\n'
[ -f "$proj/.claude/smartmem/v1/active_context.md" ] && msg+="$(cat "$proj/.claude/smartmem/v1/active_context.md")"$'\n'
[ -f "$proj/memory/tasks.md" ] && msg+=$'\n### Open tasks\n'"$(awk '/^## Done/{exit} {print}' "$proj/memory/tasks.md")"
printf '{"continue":true,"systemMessage":%s}\n' "$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '"%s"' "${msg//\"/\\\"}")"
