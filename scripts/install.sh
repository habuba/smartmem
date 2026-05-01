#!/usr/bin/env bash
# smartmem non-marketplace install — symlinks plugin sources into ~/.claude/plugins/.
# Usage: bash scripts/install.sh [plugin ...]   default: all 6
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/plugins"
mkdir -p "$DEST"
PLUGINS=("$@")
[ "${#PLUGINS[@]}" -eq 0 ] && PLUGINS=(core software fullstack business data cli)
for p in "${PLUGINS[@]}"; do
  name="smartmem-$p"
  src="$REPO/plugins/$name"
  dst="$DEST/$name"
  [ -d "$src" ] || { echo "skip (no source): $name"; continue; }
  [ -L "$dst" ] && rm "$dst"
  [ -e "$dst" ] && { echo "exists (not a link): $dst — leaving alone"; continue; }
  ln -s "$src" "$dst"
  echo "linked: $name"
done
echo
echo "Installed plugins to: $DEST"
echo "Restart Claude Code, then run: /smartmem-init"
