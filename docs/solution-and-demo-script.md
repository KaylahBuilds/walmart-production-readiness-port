# Walmart Production Readiness — Solution & Demo Script

> **TSM/TSE Home Assignment** | Customer: Walmart | Use Case: Production Readiness

---

## Part 1: The Solution

### The Problem We're Solving

Walmart's engineering organization spans **12,000 developers across 10 global hubs** (US-Bentonville, US-Sunnyvale, India-Bangalore, Mexico-CDMX, Chile-Santiago, UK-London, etc.).

Each hub has organically evolved its own definition of "production ready":

- **No standard checklist** — Bentonville uses Confluence, Bangalore uses Notion, Sunnyvale uses internal wikis
- **Subjective reviews** — outcomes depend on who reviews and when
- **Manual gatekeeping** — platform team spends 40%+ of capacity on reviews
- **Reactive failure mode** — gaps discovered after incidents, especially during Black Friday and holiday peaks
- **Zero org-wide visibility** — VPs can't answer "how production-ready are we?"

**Industry estimate: $13M+ per hour of downtime during peak retail events.**

### The Solution: A 4-Component Port Prototype

| Component | What It Does |
|-----------|--------------|
| **1. GitHub Integration** | Auto-syncs 5 Walmart microservices from GitHub into Port's catalog with README, CODEOWNERS, CI/CD metadata |
| **2. Walmart Production Readiness Scorecard** | Continuously evaluates each service against 3 rules tied to Walmart's stack |
| **3. Self-Service Action** | "Request Production Readiness Review" — a Day-2 action using `UPSERT_ENTITY` to update the catalog directly (no backend) |
| **4. Dashboard** | Org-wide view with three tables (All Services, Needs Attention, Gold Path) + embedded action card |

### Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                       Walmart Developers                        │
│              (12,000 across 10 global hubs)                     │
└────────────────────────────────────────────────────────────────┘
                            │
                            ▼  view + self-serve
┌────────────────────────────────────────────────────────────────┐
│                         PORT PORTAL                             │
│                                                                 │
│  ┌──────────────┐  ┌──────────────────┐  ┌────────────────┐   │
│  │   Catalog    │  │    Scorecard     │  │   Dashboard    │   │
│  │              │  │                  │  │                │   │
│  │  5 services  │  │  3 Walmart rules │  │  All Services  │   │
│  │  with custom │  │  Silver: 2 rules │  │  Gold Path     │   │
│  │  properties  │  │  Gold:   1 rule  │  │  Needs Atten.  │   │
│  └──────┬───────┘  └──────────────────┘  └────────────────┘   │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  Self-Service Action: Request Production Readiness Review │ │
│  │  Day-2 → UPSERT_ENTITY → updates catalog directly         │ │
│  └──────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────┘
                            ▲
                            │  ingests
┌────────────────────────────────────────────────────────────────┐
│                          GitHub                                 │
│  6 repos: checkout, inventory, notification, payment, user,    │
│           search (varying levels of README/CODEOWNERS/CI)      │
└────────────────────────────────────────────────────────────────┘
```

### The Scorecard Rules

| Level | Rule | Property | Why It Matters |
|-------|------|----------|----------------|
| **Silver** | Has Monitoring (Datadog) | `hasMonitoring = true` | Can't operate what you can't observe |
| **Silver** | No Critical Vulnerabilities (Snyk) | `criticalVulns <= 0` | Security posture for prod-grade services |
| **Gold** | Has On-Call Runbook | `hasRunbook = true` | Reduces MTTR when (not if) incidents happen |

### The Service Catalog (Demo Data)

| Service | Hub | Has Monitoring | Has Runbook | Critical Vulns | Expected Level |
|---------|-----|:--:|:--:|:--:|---|
| **Checkout Service** | US-Bentonville | ✅ | ✅ | 0 | 🥇 **Gold** |
| **Notification Worker** | UK-London | ✅ | ✅ | 0 | 🥇 **Gold** |
| **Inventory API** | India-Bangalore | ✅ | ❌ | 0 | 🥈 **Silver** |
| **Payment Gateway** | US-Sunnyvale | ❌ | ❌ | 3 | ⚪ **Basic** |
| **Search Service** | Chile-Santiago | ❌ | ❌ | 0 | ⚪ **Basic** |

### Business Impact

| Metric | Before Port | After Port (6 months) |
|--------|-------------|-----------------------|
| Production readiness compliance | ~35% | 80%+ |
| Manual review time per service | 2-4 hours | 15 min (automated) |
| Platform team capacity on reviews | 40% | <10% |
| Incident rate from readiness gaps | Baseline | 50% reduction |
| Time-to-deploy | Days (waiting) | Hours (self-service) |

---

## Part 2: Demo Script (10 min live walkthrough)

### Setup Before the Demo

- [ ] Have **app.getport.io** open in your browser
- [ ] Land on the **Walmart Production Readiness** dashboard
- [ ] Confirm the action card shows "Request Production Readiness Review"
- [ ] Reset `reviewRequested` to `false` on whichever service you plan to demo the action on
- [ ] Open this script on a second screen or phone for reference

### Demo Flow

#### Scene 1: The Catalog (2 min)

> **Say:** "Let me start by showing you the Walmart service catalog. Every microservice across all 10 hubs flows into Port automatically from GitHub."

1. Click **Catalog → Services** in the left sidebar
2. Point to the column headers: Title, Owning Teams, Hub, Criticality, Has Monitoring, Has Runbook, Critical Vulnerabilities
3. Point to the variation in the data:

> **Say:** "Notice every service has the same set of properties. Same standards across Bentonville, Bangalore, Sunnyvale — every hub. That alone is something Walmart doesn't have today."

#### Scene 2: A Gold-Path Service (1.5 min)

> **Say:** "Let's look at a fully production-ready service — Checkout Service. This is critical infrastructure for Walmart."

1. Click **Checkout Service** in the catalog
2. Show the **Overview** tab — point to the properties: Hub = US-Bentonville, Has Monitoring = true, Has Runbook = true, Critical Vulns = 0
3. Click the **Scorecards** tab
4. Point to the **Walmart Production Readiness** scorecard — show all 3 rules passing (green)

> **Say:** "Three Walmart-specific rules: monitoring, no critical vulns, runbook. This service hits Gold because it passes all three. No manual review needed — Port evaluates this continuously."

#### Scene 3: A Service That Needs Work (2 min)

> **Say:** "Now let's look at a service that's NOT production-ready. Search Service."

1. Click **Search Service** in the catalog
2. Show the properties — Hub = Chile-Santiago, all booleans false, 0 vulns
3. Click the **Scorecards** tab
4. Point to failing rules with red X marks

> **Say:** "Three rules failing. Today at Walmart, this service would deploy to production anyway because there's no enforcement. The developer might not even know what 'production-ready' means for their hub. With Port, the gaps are visible immediately."

#### Scene 4: Trigger the Self-Service Action (2 min)

> **Say:** "Here's where developer autonomy kicks in. Instead of pinging the platform team on Slack, the developer can request a readiness review themselves."

1. Still on **Search Service**, click the **⚡ Execute action** button (or the action card on the dashboard)
2. Or navigate: **Self-service** in top nav → **Request Production Readiness Review**
3. In the form:
   - **Target Level:** select `Gold`
   - **Notes:** type `"Need to reach Gold before Black Friday — adding Datadog and runbook this sprint"`
4. Click **Execute**
5. Refresh and show the Search Service entity now has `reviewRequested = true`, `targetLevel = Gold`, and the notes saved

> **Say:** "That's a Day-2 action using Port's UPSERT_ENTITY backend — no Lambda, no webhook, no infrastructure to maintain. In production, this would also kick off a Slack notification to the platform team and create a Jira ticket. For our POC, updating the catalog is enough to prove the workflow."

#### Scene 5: The Dashboard (2 min)

> **Say:** "Finally, let's zoom out. This is what VP-level visibility looks like."

1. Click **Walmart Production Readiness** in the left sidebar
2. Walk through each table:
   - **All Walmart Services** — complete catalog with scorecard levels at a glance
   - **Services Needing Attention** — Payment Gateway (no monitoring + 3 vulns) and Search Service (nothing) — these are the priority queue
   - **Production-Ready Services (Gold Path)** — Checkout Service and Notification Worker — the model services
3. Point to the embedded action card on the right

> **Say:** "A VP of Engineering can look at this dashboard and answer 'How production-ready are we?' in under 30 seconds. They can see exactly which services need attention, by hub, by team. Today, that question would take weeks of manual surveys."

#### Scene 6: Close the Demo (30 sec)

> **Say:** "What we just showed is a focused POC — one scorecard, one action, one dashboard, six services. Production deployment would extend this to all 12,000 services across all 10 hubs, with real-time Datadog and Snyk feeds replacing the mock data, and CI/CD gating preventing deployments below the Bronze tier."

> **Switch back to slides for the Expected Outcomes section.**

---

## Part 3: Anticipated Q&A

### Q: How does this scale to 12,000 developers and thousands of services?

> Port's catalog is designed for enterprise scale. Walmart Labs and similar orgs use Port at this scale today. RBAC scopes visibility by team and hub — developers only see their services, team leads see their team, leadership sees everything. The scorecard evaluation is continuous and runs server-side, so it doesn't degrade as catalog size grows.

### Q: How long would a full Walmart rollout take?

> A 2-3 person platform engineering team could have the core setup (catalog + scorecard + dashboard) running in 2-3 weeks. The integrations are the variable — GitHub is quick, K8s and Snyk take longer based on their infrastructure. A phased rollout across the 10 hubs over 2-3 months would be realistic — start with Bentonville, then roll out region by region.

### Q: What if different hubs need different standards?

> Port supports multiple scorecards per blueprint and customizable rules. India might add data residency rules. Europe might add GDPR compliance rules. The Walmart baseline scorecard stays consistent, with hub-specific scorecards layered on top.

### Q: Can the scorecard block deployments?

> Not directly in Port — but Port exposes a public API. You add one step to your GitHub Actions or Jenkins pipeline that queries Port for the service's scorecard level. If below Bronze, the pipeline fails. This gives you hard enforcement without changing Port itself.

### Q: How does this compare to Backstage?

> Backstage is a framework you build on — it requires significant engineering investment to build features Port gives you out of the box, plus ongoing maintenance burden. Port is a managed platform with native scorecards, self-service actions, AI assistant, and 50+ integrations. For an org like Walmart that wants time-to-value, Port removes the build-and-maintain burden.

### Q: What's the cost impact / ROI?

> Three layers of ROI: **(1) Reduced incident cost** — preventing one major incident during Black Friday pays for the platform. **(2) Reclaimed platform team capacity** — 40% of their time back. **(3) Faster developer velocity** — no more days-long waits for reviews. The platform pays for itself with one avoided outage.

### Q: How could the demo be extended?

> Phase 2 roadmap:
> 1. **Datadog integration** → auto-populate `hasMonitoring` from real Datadog data
> 2. **Snyk integration** → real-time vulnerability counts
> 3. **K8s integration** → map clusters, namespaces, deployments per hub
> 4. **CI/CD gating** → block deploys below Bronze via GitHub Actions
> 5. **Additional scorecards** → Security Readiness, Cost Optimization, Documentation Coverage
> 6. **Hub-specific dashboards** → regional leads get focused views

---

## Part 4: Pre-Presentation Checklist

### 1 Hour Before
- [ ] Open Port in browser, verify dashboard loads
- [ ] Verify all 5 services have correct properties (run validation if unsure)
- [ ] Reset `reviewRequested = false` on Search Service for clean action demo
- [ ] Open slides on second screen / second window
- [ ] Charge laptop + bring charger

### 5 Minutes Before
- [ ] Close all extra browser tabs (just Port + slides)
- [ ] Silence notifications
- [ ] Bring up the title slide
- [ ] Take a deep breath

### During the Demo
- [ ] Speak slowly, especially during transitions
- [ ] Use the audience: "What questions do you have about this part before I move on?"
- [ ] If something breaks: stay calm, show the dashboard instead, return to slides

---

## Part 5: Files & Resources

| File | Location |
|------|----------|
| Slide Deck | `/Users/kaylahgore/Desktop/Walmart_Production_Readiness_Presentation.pptx` |
| Flowchart | `/Users/kaylahgore/Desktop/Flowchart_Production_Readiness.html` |
| Port Configs | `port-config/` in this repo |
| GitHub Repo | https://github.com/KaylahBuilds/walmart-production-readiness-port |
| Port Portal | https://app.getport.io |

### Demo Services on GitHub

- https://github.com/KaylahBuilds/checkout-service
- https://github.com/KaylahBuilds/inventory-api
- https://github.com/KaylahBuilds/notification-worker
- https://github.com/KaylahBuilds/payment-gateway
- https://github.com/KaylahBuilds/user-auth
- https://github.com/KaylahBuilds/search-service
