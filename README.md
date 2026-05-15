# Walmart Production Readiness — Port Demo

**TSM / TSE Home Assignment** | Platform Engineering & Developer Experience

## Overview

This project demonstrates how [Port](https://www.getport.io/) can solve **inconsistent production readiness standards** across Walmart's 12,000 developers and 10 global engineering hubs.

### Customer Profile

| Attribute | Detail |
|-----------|--------|
| **Customer** | Walmart |
| **Industry** | Retail & E-commerce |
| **Developers** | 12,000 |
| **Hubs** | 10 global |
| **Stack** | Cloud-native, GitHub, K8s, CI/CD, Jira, Snyk, Datadog, Terraform |

### Use Case

**Production Readiness** — Each hub has evolved its own definition of "production ready," leading to inconsistent standards, incident spikes during peak retail events, and platform teams bottlenecked on manual reviews.

## Solution

A working Port prototype with four components:

| Component | Description |
|-----------|-------------|
| **GitHub Integration** | Auto-ingest repositories as Service entities |
| **Production Readiness Scorecard** | 3-tier evaluation (Bronze / Silver / Gold) with 6 rules |
| **Self-Service Action** | "Request Production Readiness Review" — DAY-2 action using UPSERT_ENTITY |
| **Dashboard** | Org-wide readiness posture by team and hub |

## Repository Structure

```
walmart-production-readiness-port/
├── README.md
├── port-config/
│   ├── blueprint-service.json        # Service blueprint definition
│   ├── scorecard-production-readiness.json  # Scorecard with 6 rules
│   └── action-request-prod-review.json     # Self-service action config
├── scripts/
│   ├── seed-mock-data.sh             # Populate Port with 6 demo services
│   └── get-token.sh                  # Authenticate with Port API
├── flowchart/
│   └── flowchart.html                # Current vs proposed workflow diagram
└── docs/
    ├── setup-guide.md                # Step-by-step Port setup instructions
    └── talking-points.md             # Speaker notes for the presentation
```

## Quick Start

### 1. Set up Port

```bash
# Sign up at https://app.getport.io
# Get your Client ID and Client Secret from Settings > Credentials
export PORT_CLIENT_ID="your-client-id"
export PORT_CLIENT_SECRET="your-client-secret"
```

### 2. Get API Token

```bash
./scripts/get-token.sh
```

### 3. Create Blueprint & Seed Data

Import `port-config/blueprint-service.json` via the Port UI (Builder > + Blueprint > JSON mode), then:

```bash
./scripts/seed-mock-data.sh
```

### 4. Create Scorecard

Import `port-config/scorecard-production-readiness.json` via the Port UI (Service blueprint > Scorecards > + New Scorecard > JSON mode).

### 5. Create Self-Service Action

Import `port-config/action-request-prod-review.json` via the Port UI (Self-Service > + New Action).

### 6. Build Dashboard

See `docs/setup-guide.md` for dashboard widget configuration.

## Scorecard Tiers

| Level | Rules | What It Means |
|-------|-------|---------------|
| **Bronze** | Has README, Has CI/CD | Minimum viable production |
| **Silver** | Has Monitoring (Datadog), No Critical Vulns (Snyk) | Operationally sound |
| **Gold** | Has Runbook, Has Owner (CODEOWNERS) | Excellence |

## Demo Services

| Service | Hub | Level | Notes |
|---------|-----|-------|-------|
| checkout-service | US-Bentonville | Gold | All checks pass |
| inventory-api | India-Bangalore | Silver | Missing runbook |
| notification-worker | UK-London | Silver | Missing owner |
| payment-gateway | US-Sunnyvale | Bronze | No monitoring, has vulns |
| user-auth | Mexico-CDMX | Basic | Missing CI/CD |
| search-service | Chile-Santiago | Basic | Missing everything |

## Resources

- [Port Documentation](https://docs.port.io)
- [Port Demo Portal](https://demo.port.io)
- [Port AI Assistant](https://docs.port.io/ai-interfaces/port-ai-assistant)
