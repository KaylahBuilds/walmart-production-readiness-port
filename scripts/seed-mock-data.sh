#!/usr/bin/env bash
# Seed Port with 6 demo services for the Walmart Production Readiness demo.
# Usage: export PORT_CLIENT_ID="..." PORT_CLIENT_SECRET="..." && ./scripts/seed-mock-data.sh

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
echo "==> Creating 6 demo services..."
echo ""

# 1. checkout-service — GOLD
create_entity "checkout-service" '{
  "identifier": "checkout-service",
  "title": "Checkout Service",
  "properties": {
    "language": "Java",
    "url": "https://github.com/walmart/checkout-service",
    "lifecycle": "Production",
    "hub": "US-Bentonville",
    "hasReadme": true,
    "hasCICD": true,
    "hasMonitoring": true,
    "hasRunbook": true,
    "hasOwner": true,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

# 2. inventory-api — SILVER
create_entity "inventory-api" '{
  "identifier": "inventory-api",
  "title": "Inventory API",
  "properties": {
    "language": "Go",
    "url": "https://github.com/walmart/inventory-api",
    "lifecycle": "Production",
    "hub": "India-Bangalore",
    "hasReadme": true,
    "hasCICD": true,
    "hasMonitoring": true,
    "hasRunbook": false,
    "hasOwner": true,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

# 3. notification-worker — SILVER
create_entity "notification-worker" '{
  "identifier": "notification-worker",
  "title": "Notification Worker",
  "properties": {
    "language": ".NET",
    "url": "https://github.com/walmart/notification-worker",
    "lifecycle": "Production",
    "hub": "UK-London",
    "hasReadme": true,
    "hasCICD": true,
    "hasMonitoring": true,
    "hasRunbook": true,
    "hasOwner": false,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

# 4. payment-gateway — BRONZE
create_entity "payment-gateway" '{
  "identifier": "payment-gateway",
  "title": "Payment Gateway",
  "properties": {
    "language": "Node.js",
    "url": "https://github.com/walmart/payment-gateway",
    "lifecycle": "Production",
    "hub": "US-Sunnyvale",
    "hasReadme": true,
    "hasCICD": true,
    "hasMonitoring": false,
    "hasRunbook": false,
    "hasOwner": false,
    "criticalVulns": 2,
    "reviewRequested": false
  }
}'

# 5. user-auth — BASIC
create_entity "user-auth" '{
  "identifier": "user-auth",
  "title": "User Auth Service",
  "properties": {
    "language": "Python",
    "url": "https://github.com/walmart/user-auth",
    "lifecycle": "Production",
    "hub": "Mexico-CDMX",
    "hasReadme": true,
    "hasCICD": false,
    "hasMonitoring": false,
    "hasRunbook": false,
    "hasOwner": false,
    "criticalVulns": 5,
    "reviewRequested": false
  }
}'

# 6. search-service — BASIC
create_entity "search-service" '{
  "identifier": "search-service",
  "title": "Search Service",
  "properties": {
    "language": "TypeScript",
    "url": "https://github.com/walmart/search-service",
    "lifecycle": "Development",
    "hub": "Chile-Santiago",
    "hasReadme": false,
    "hasCICD": false,
    "hasMonitoring": false,
    "hasRunbook": false,
    "hasOwner": false,
    "criticalVulns": 0,
    "reviewRequested": false
  }
}'

echo ""
echo "==> Done! Expected scorecard levels:"
echo "    checkout-service     Gold"
echo "    inventory-api        Silver"
echo "    notification-worker  Silver"
echo "    payment-gateway      Bronze"
echo "    user-auth            Basic"
echo "    search-service       Basic"
echo ""
echo "    Verify at: https://app.getport.io"
