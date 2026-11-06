#!/usr/bin/env bash
# Replace XSPACE_* placeholders with real GitBook space IDs.
# Usage: ./scripts/resolve-xspace.sh <userGuideId> <integratorId> <apiId> <advancedId>
set -euo pipefail
UG="${1:?user guide space id}"; IG="${2:?integrator space id}"; API="${3:?api space id}"; ADV="${4:?advanced space id}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cat > "$ROOT/cross-space-links.yaml" <<Y
XSPACE_USER_GUIDE: $UG
XSPACE_INTEGRATOR: $IG
XSPACE_API: $API
XSPACE_ADVANCED: $ADV
Y
find "$ROOT" -name '*.md' -not -path '*/.git/*' -print0 | xargs -0 sed -i '' \
  -e "s|XSPACE_USER_GUIDE|$UG|g" -e "s|XSPACE_INTEGRATOR|$IG|g" \
  -e "s|XSPACE_API|$API|g" -e "s|XSPACE_ADVANCED|$ADV|g"
echo "Resolved. Remaining placeholders:"; grep -rl "XSPACE_" "$ROOT" --include='*.md' || echo "none"
