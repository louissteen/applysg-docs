#!/usr/bin/env bash
# Apply the ApplySG branding to a GitBook site via the REST API.
#
# Usage:
#   export GITBOOK_TOKEN=$(op read "op://…")   # never commit the token
#   ./branding/apply-branding.sh <orgId> <siteId>
#
# The script GETs the current customization, deep-merges customization.json
# over it with jq, and PUTs the result back. Deprecated fields that GitBook
# still returns (header.preset, internationalization) are left untouched.
set -euo pipefail

ORG_ID="${1:?orgId required}"
SITE_ID="${2:?siteId required}"
: "${GITBOOK_TOKEN:?GITBOOK_TOKEN must be set}"

HERE="$(cd "$(dirname "$0")" && pwd)"
URL="https://api.gitbook.com/v1/orgs/${ORG_ID}/sites/${SITE_ID}/customization"

CURRENT="$(curl -sf -H "Authorization: Bearer ${GITBOOK_TOKEN}" "$URL")"
NEW="$(jq -s '.[0] * .[1]' <(echo "$CURRENT") "$HERE/customization.json")"

curl -sf -X PUT "$URL" \
  -H "Authorization: Bearer ${GITBOOK_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$NEW" | jq '{title, primary: .styling.primaryColor, font: .styling.font, logo: .header.logo}'

echo "Branding applied to site ${SITE_ID}."
