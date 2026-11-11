#!/usr/bin/env bash
# Stamps the version from plugin.json into the pre-flight-check skill marker
# and the Codex manifest.
# Run this after bumping the version in plugin.json.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_JSON="$REPO_DIR/.claude-plugin/plugin.json"
VERSION=$(jq -r .version "$PLUGIN_JSON")
SKILL="$REPO_DIR/skills/cofounder-pre-flight-check/SKILL.md"

# Portable in-place edit: BSD sed (macOS) and GNU sed (Linux CI) disagree on
# the -i flag's syntax, so write through a temp file instead.
tmp=$(mktemp)
sed "s/COFOUNDER_VERSION: .*/COFOUNDER_VERSION: $VERSION -->/" "$SKILL" > "$tmp" && mv "$tmp" "$SKILL"

# The Codex manifest carries its own copy of the version.
CODEX_JSON="$REPO_DIR/.codex-plugin/plugin.json"
tmp=$(mktemp)
jq --arg v "$VERSION" '.version = $v' "$CODEX_JSON" > "$tmp" && mv "$tmp" "$CODEX_JSON"

echo "Stamped version $VERSION into $(basename "$SKILL") and .codex-plugin/plugin.json"
