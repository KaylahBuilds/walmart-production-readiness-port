#!/usr/bin/env bash
# Seed Port with 5 additional Walmart demo services + update the existing walmart service.
# Works with Port's DEFAULT Service blueprint (adds custom properties only).
#
# Usage:
#   export PORT_CLIENT_ID="your-client-id"
#   export PORT_CLIENT_SECRET="your-client-secret"
#   ./scripts/seed-mock-data.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Fetching Port API token..."
TOKEN=$("${SCRIPT_DIR}/get-token.sh")
echo "    Token acquired."

API="https://api.getport.io/v1/blueprints/service/entities?upsert=true"
AUTH="Authorization: Bearer ${TOKEN}"
CT="Content-Type: application/json"

create_entity() {
  local name="$1"
  local payload="$2"

  local status
  status=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$API" \
    -H "$AUTH" -H "$CT" -d "$payload")

  if [[ "$status" =~ ^2 ]]; then
    echo "    [OK]  ${name}"
  else
    echo "    [ERR] ${name} (HTTP ${status})"
  fi
}

echo ""
echo "==> Updating existing walmart service..."
echo ""

create_entity "walmart (update)" '{
  "identifier": "walmart",
  "title": "walmart",
  "properties": {
    "hub": "US-Bentonville",
    "hasMonitoring": true,
    "hasRunbook": true,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

echo ""
echo "==> Creating 5 Walmart demo services..."
echo ""

# 1. Checkout Service — targets GOLD
create_entity "checkout-service" '{
  "identifier": "checkout-service",
  "title": "Checkout Service",
  "properties": {
    "hub": "US-Bentonville",
    "hasMonitoring": true,
    "hasRunbook": true,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

# 2. Inventory API — targets SILVER
create_entity "inventory-api" '{
  "identifier": "inventory-api",
  "title": "Inventory API",
  "properties": {
    "hub": "India-Bangalore",
    "hasMonitoring": true,
    "hasRunbook": false,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

# 3. Payment Gateway — targets BRONZE
create_entity "payment-gateway" '{
  "identifier": "payment-gateway",
  "title": "Payment Gateway",
  "properties": {
    "hub": "US-Sunnyvale",
    "hasMonitoring": false,
    "hasRunbook": false,
    "criticalVulns": 3,
    "reviewRequested": false
  }
}'

# 4. User Auth — targets BASIC
create_entity "user-auth" '{
  "identifier": "user-auth",
  "title": "User Auth Service",
  "properties": {
    "hub": "Mexico-CDMX",
    "hasMonitoring": false,
    "hasRunbook": false,
    "criticalVulns": 5,
    "reviewRequested": false
  }
}'

# 5. Search Service — targets BASIC
create_entity "search-service" '{
  "identifier": "search-service",
  "title": "Search Service",
  "properties": {
    "hub": "Chile-Santiago",
    "hasMonitoring": false,
    "hasRunbook": false,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

echo ""
echo "==> Done! Expected scorecard levels (with custom rules):"
echo ""
echo "    walmart              Gold   (if default rules also pass)"
echo "    checkout-service     Gold   (if default rules also pass)"
echo "    inventory-api        Silver (missing runbook)"
echo "    payment-gateway      Bronze (no monitoring + has vulns)"
echo "    user-auth            Basic  (no monitoring + has vulns)"
echo "    search-service       Basic  (missing most requirements)"
echo ""
echo "    Verify at: https://app.getport.io"
