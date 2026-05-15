#!/usr/bin/env bash
# Get a Port API access token
# Usage: export PORT_CLIENT_ID="..." PORT_CLIENT_SECRET="..." && ./get-token.sh

set -euo pipefail

if [[ -z "${PORT_CLIENT_ID:-}" || -z "${PORT_CLIENT_SECRET:-}" ]]; then
  echo "Error: PORT_CLIENT_ID and PORT_CLIENT_SECRET must be set."
  echo ""
  echo "Usage:"
  echo "  export PORT_CLIENT_ID=\"your-client-id\""
  echo "  export PORT_CLIENT_SECRET=\"your-client-secret\""
  echo "  ./scripts/get-token.sh"
  echo ""
  echo "Find your credentials at: https://app.getport.io → Settings → Credentials"
  exit 1
fi

TOKEN=$(curl -s -X POST "https://api.getport.io/v1/auth/access_token" \
  -H "Content-Type: application/json" \
  -d "{\"clientId\": \"${PORT_CLIENT_ID}\", \"clientSecret\": \"${PORT_CLIENT_SECRET}\"}" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")

if [[ -z "$TOKEN" ]]; then
  echo "Error: Failed to retrieve access token. Check your credentials."
  exit 1
fi

echo "$TOKEN"
