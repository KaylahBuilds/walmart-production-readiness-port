# Port Setup Plan: Walmart Production Readiness

## Overview

This guide walks through setting up a working Port prototype for the Walmart Production Readiness use case. The setup includes: a GitHub integration, a Production Readiness scorecard, a self-service action, and a dashboard.

---

## 1. Blueprint: Service (Microservice)

Create a blueprint called `service` to represent Walmart's microservices.

### Blueprint JSON

```json
{
  "identifier": "service",
  "title": "Service",
  "icon": "Microservice",
  "schema": {
    "properties": {
      "language": {
        "type": "string",
        "title": "Language",
        "enum": ["Python", "Java", "Go", "Node.js", "TypeScript", ".NET"],
        "enumColors": {
          "Python": "blue",
          "Java": "orange",
          "Go": "turquoise",
          "Node.js": "green",
          "TypeScript": "darkBlue",
          ".NET": "purple"
        }
      },
      "url": {
        "type": "string",
        "title": "Repository URL",
        "format": "url"
      },
      "defaultBranch": {
        "type": "string",
        "title": "Default Branch"
      },
      "hasReadme": {
        "type": "boolean",
        "title": "Has README",
        "description": "Whether the service has a README file"
      },
      "hasCICD": {
        "type": "boolean",
        "title": "Has CI/CD Pipeline",
        "description": "Whether GitHub Actions or equivalent CI/CD is configured"
      },
      "hasMonitoring": {
        "type": "boolean",
        "title": "Has Monitoring",
        "description": "Whether Datadog monitoring is configured"
      },
      "hasRunbook": {
        "type": "boolean",
        "title": "Has Runbook",
        "description": "Whether an on-call runbook is documented"
      },
      "hasOwner": {
        "type": "boolean",
        "title": "Has Owner",
        "description": "Whether a CODEOWNERS file designates ownership"
      },
      "criticalVulns": {
        "type": "number",
        "title": "Critical Vulnerabilities",
        "description": "Number of critical Snyk vulnerabilities"
      },
      "lifecycle": {
        "type": "string",
        "title": "Lifecycle",
        "enum": ["Development", "Staging", "Production", "Deprecated"],
        "enumColors": {
          "Development": "blue",
          "Staging": "orange",
          "Production": "green",
          "Deprecated": "red"
        }
      },
      "hub": {
        "type": "string",
        "title": "Hub",
        "enum": ["US-Bentonville", "US-Sunnyvale", "India-Bangalore", "Mexico-CDMX", "Chile-Santiago", "China-Shenzhen", "UK-London", "Canada-Toronto", "Israel-TLV", "Costa Rica-SJ"],
        "description": "The global hub this service belongs to"
      },
      "reviewRequested": {
        "type": "boolean",
        "title": "Review Requested",
        "description": "Whether a production readiness review has been requested"
      },
      "targetLevel": {
        "type": "string",
        "title": "Target Level",
        "enum": ["Bronze", "Silver", "Gold"]
      },
      "reviewNotes": {
        "type": "string",
        "title": "Review Notes"
      }
    },
    "required": []
  },
  "relations": {
    "team": {
      "title": "Owning Team",
      "target": "team",
      "required": false
    }
  }
}
```

### Optional: Team Blueprint

```json
{
  "identifier": "team",
  "title": "Team",
  "icon": "Team",
  "schema": {
    "properties": {
      "hub": {
        "type": "string",
        "title": "Hub"
      },
      "slackChannel": {
        "type": "string",
        "title": "Slack Channel"
      }
    }
  }
}
```

---

## 2. Integration: GitHub

Connect your GitHub organization (or a demo repo) to Port.

### Steps

1. Go to **Port > Settings > Data Sources > + Data Source**
2. Select **GitHub**
3. Install the Port GitHub App on your repo/org
4. Configure the mapping to populate `service` entities

### Recommended Mapping (port-app-config.yml)

```yaml
resources:
  - kind: repository
    selector:
      query: "true"
    port:
      entity:
        mappings:
          identifier: .repo.name
          title: .repo.name
          blueprint: '"service"'
          properties:
            url: .repo.html_url
            defaultBranch: .repo.default_branch
            language: .repo.language
            hasReadme: .repo.description != null
            hasCICD: .repo.has_actions // true
```

> **Tip for demo**: If using a personal GitHub account, create 4-6 demo repositories with names like `checkout-service`, `inventory-api`, `payment-gateway`, `user-auth`, `search-service`, `notification-worker`. Add README files, GitHub Actions workflows, and CODEOWNERS files to some (but not all) to create realistic scorecard variation.

### Enriching with Mock Data

After GitHub ingests the repos, use the Port API or UI to manually set boolean properties that GitHub doesn't directly provide:

```bash
# Example: Update a service entity via Port API
curl -X PATCH "https://api.getport.io/v1/blueprints/service/entities/checkout-service" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "properties": {
      "hasMonitoring": true,
      "hasRunbook": true,
      "hasOwner": true,
      "criticalVulns": 0,
      "hub": "US-Bentonville",
      "lifecycle": "Production"
    }
  }'
```

Create a mix:
| Service | hasReadme | hasCICD | hasMonitoring | hasRunbook | hasOwner | criticalVulns | Expected Level |
|---------|-----------|---------|---------------|------------|----------|---------------|----------------|
| checkout-service | true | true | true | true | true | 0 | Gold |
| inventory-api | true | true | true | false | true | 0 | Silver |
| payment-gateway | true | true | false | false | false | 2 | Bronze |
| user-auth | true | false | false | false | false | 5 | Basic |
| search-service | false | false | false | false | false | 0 | Basic |
| notification-worker | true | true | true | true | false | 0 | Silver |

---

## 3. Scorecard: Production Readiness

### Steps

1. Go to the **Service** blueprint page
2. Click the **Scorecards** tab
3. Click **+ New Scorecard**

### Scorecard Configuration

```json
{
  "identifier": "productionReadiness",
  "title": "Production Readiness",
  "levels": [
    {
      "color": "paleBlue",
      "title": "Basic"
    },
    {
      "color": "bronze",
      "title": "Bronze"
    },
    {
      "color": "silver",
      "title": "Silver"
    },
    {
      "color": "gold",
      "title": "Gold"
    }
  ],
  "rules": [
    {
      "identifier": "hasReadme",
      "title": "Has README Documentation",
      "level": "Bronze",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "=",
            "property": "hasReadme",
            "value": true
          }
        ]
      }
    },
    {
      "identifier": "hasCICD",
      "title": "Has CI/CD Pipeline",
      "level": "Bronze",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "=",
            "property": "hasCICD",
            "value": true
          }
        ]
      }
    },
    {
      "identifier": "hasMonitoring",
      "title": "Has Monitoring (Datadog)",
      "level": "Silver",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "=",
            "property": "hasMonitoring",
            "value": true
          }
        ]
      }
    },
    {
      "identifier": "noVulns",
      "title": "No Critical Vulnerabilities (Snyk)",
      "level": "Silver",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "<=",
            "property": "criticalVulns",
            "value": 0
          }
        ]
      }
    },
    {
      "identifier": "hasRunbook",
      "title": "Has On-Call Runbook",
      "level": "Gold",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "=",
            "property": "hasRunbook",
            "value": true
          }
        ]
      }
    },
    {
      "identifier": "hasOwner",
      "title": "Has Designated Owner",
      "level": "Gold",
      "query": {
        "combinator": "and",
        "conditions": [
          {
            "operator": "=",
            "property": "hasOwner",
            "value": true
          }
        ]
      }
    }
  ]
}
```

---

## 4. Self-Service Action: Request Production Readiness Review

### Steps

1. Go to **Self-Service > + New Action**
2. Configure as follows:

### Action Configuration

```json
{
  "identifier": "request_prod_review",
  "title": "Request Production Readiness Review",
  "trigger": {
    "type": "self-service",
    "operation": "DAY-2",
    "blueprintIdentifier": "service",
    "userInputs": {
      "properties": {
        "targetLevel": {
          "type": "string",
          "title": "Target Level",
          "enum": ["Bronze", "Silver", "Gold"],
          "description": "The production readiness level you are targeting"
        },
        "notes": {
          "type": "string",
          "title": "Notes",
          "description": "Any additional context for the review"
        }
      },
      "required": ["targetLevel"]
    }
  },
  "invocationMethod": {
    "type": "UPSERT_ENTITY",
    "blueprintIdentifier": "service",
    "mapping": {
      "identifier": "{{ .entity.identifier }}",
      "properties": {
        "reviewRequested": true,
        "targetLevel": "{{ .inputs.targetLevel }}",
        "reviewNotes": "{{ .inputs.notes }}"
      }
    }
  }
}
```

> **Key insight for the demo**: Using `UPSERT_ENTITY` as the invocation method means this action updates the catalog directly without needing an external backend. This is perfect for a POC. In production, you would swap this for a webhook that triggers a Jira ticket creation + Slack notification.

---

## 5. Dashboard: Production Readiness Overview

### Steps

1. Go to **Home > + New Dashboard**
2. Name it: **Production Readiness Overview**

### Recommended Widgets

| Widget Type | Title | Configuration |
|-------------|-------|---------------|
| **Pie Chart** | Readiness by Level | Group services by scorecard level (Basic/Bronze/Silver/Gold) |
| **Number** | Total Services | Count of all service entities |
| **Number** | Gold Services | Count of services at Gold level |
| **Number** | Below Bronze | Count of services at Basic level (need attention) |
| **Table** | Services Needing Attention | Filter: scorecard level = Basic, show service name, hub, owner |
| **Pie Chart** | Services by Hub | Group services by hub property |
| **Bar Chart** | Readiness by Hub | Group services by hub, stack by scorecard level |

### Dashboard Layout Tips

- Put the 3-4 number widgets across the top row
- Pie chart (readiness by level) on the left, table (needing attention) on the right
- Hub breakdown charts on the bottom row
- Use Port's built-in color coding for scorecard levels

---

## 6. Demo Script / Walkthrough Order

When presenting the live demo, follow this order:

1. **Show the Software Catalog** - Click into the Service blueprint, show the list of services with their properties
2. **Click into a Gold service** (e.g., checkout-service) - Show all properties populated, scorecard passing all rules
3. **Click into a Basic service** (e.g., search-service) - Show missing properties, scorecard showing gaps
4. **Trigger the Self-Service Action** - On the Basic service, click "Request Production Readiness Review", fill in target level and notes, submit
5. **Show the entity updated** - reviewRequested = true, target level set
6. **Navigate to the Dashboard** - Show the org-wide view, point out the distribution across levels and hubs

---

## Quick Reference: Port API

```bash
# Get API token
export PORT_CLIENT_ID="your-client-id"
export PORT_CLIENT_SECRET="your-client-secret"

TOKEN=$(curl -s -X POST "https://api.getport.io/v1/auth/access_token" \
  -H "Content-Type: application/json" \
  -d "{\"clientId\": \"$PORT_CLIENT_ID\", \"clientSecret\": \"$PORT_CLIENT_SECRET\"}" \
  | jq -r '.accessToken')

# Create/update an entity
curl -X POST "https://api.getport.io/v1/blueprints/service/entities?upsert=true" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "checkout-service",
    "title": "Checkout Service",
    "properties": {
      "language": "Java",
      "url": "https://github.com/walmart/checkout-service",
      "hasReadme": true,
      "hasCICD": true,
      "hasMonitoring": true,
      "hasRunbook": true,
      "hasOwner": true,
      "criticalVulns": 0,
      "lifecycle": "Production",
      "hub": "US-Bentonville"
    }
  }'
```
