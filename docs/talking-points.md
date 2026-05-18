# Speaker Notes & Talking Points

## Walmart Production Readiness — Port Presentation (14 slides)

Total runtime: ~30 minutes presentation + 10 min live demo + Q&A

---

## Slide 1: Title (30 seconds)

> "Good [morning/afternoon]. Today I'm going to walk you through how Port can help Walmart standardize production readiness across 12,000 developers and 10 global engineering hubs.
>
> This is a real, high-stakes pain point at Walmart's scale — and I'll show you a working prototype I built in Port that demonstrates the approach.
>
> Quick agenda: Platform Engineering and DevEx, the specific Walmart use case, current vs. proposed workflow, then a live demo of the Port environment, and we'll close with expected business outcomes."

**Delivery tips:**
- Speak slowly and confidently
- Make eye contact across the room
- Don't rush

---

## Slide 2: Platform Engineering & DevEx (5 min)

> "Before diving into the specific use case, let's align on what platform engineering actually is and why it matters at scale."

**Key points:**
- **Platform Engineering** = building internal golden paths. Paved roads that let developers ship faster with built-in guardrails — not gatekeepers.
- **Internal Developer Portals** like Port are the interface layer. One place for services, ownership, standards, actions — instead of 10 disjointed tools.
- **Developer Experience** is the metric we're optimizing. Can a developer discover, build, deploy, operate easily?
- **Gartner**: orgs with mature platform engineering see 30% faster lead time and 60% fewer incidents.

**Transition:** "So with that context, let's look at the specific problem Walmart faces."

---

## Slide 3: The Problem (3 min)

> "Walmart is one of the largest engineering organizations in the world. 12,000 developers across 10 global hubs — from Bentonville to Bangalore to Santiago."

**Key points:**
- Each hub has organically evolved its own standards
- No centralized visibility — VP can't answer "how prod-ready are we?"
- Incidents spike during Black Friday and holiday peaks
- MTTR varies 3-5× across hubs
- Platform team spends 40%+ of time on manual reviews

**Transition:** "Let's look at who specifically feels this pain."

---

## Slide 4: Stakeholders (2 min)

> "This isn't just a platform team problem — it touches every layer of the organization."

**Walk through each role quickly:**

| Role | Pain Point |
|------|-----------|
| Developers | Don't know what's expected — different hubs, different checklists |
| Team Leads | Subjective enforcement — not trained reviewers but the gatekeepers |
| Platform Engineers | Bottleneck — 50 engineers can't review services for 12,000 devs |
| VP Engineering | Zero visibility — can't answer board-level questions |
| SREs / On-Call | Paged at 3am for services that shouldn't have shipped |

**Transition:** "And when you look at the numbers, the business case makes itself."

---

## Slide 5: Business Case (2 min)

> "Let me put real numbers to this."

**Key stats:**
- **$13M+/hour of downtime** during peak retail events (industry estimate)
- **40% of platform team capacity** consumed by manual reviews — reclaimable engineering time
- **3× incident rate variation** between strong and weak standards hubs — proves standards work
- **1% reliability improvement** = measurable revenue protection

**Landing line:** "Production readiness isn't a nice-to-have. It's revenue protection. One avoided outage during Black Friday pays for the entire platform."

**Transition:** "So let me show you how this process works today versus what it looks like with Port."

---

## Slide 6: From Manual to Automated (2-3 min)

> "Here's the simplified side-by-side. Today on the left, Port on the right."

**Walk through both columns quickly:**

**Today (left, coral-bordered):**
1. Developer asks team lead
2. Lead checks hub-specific wiki
3. Manual review, ad hoc tools
4. Subjective approval
5. Deploy → gaps in production
6. Retrospective → ad hoc fix

**With Port (right, navy-bordered):**
1. Auto-ingested from GitHub
2. Scorecard evaluates 24/7
3. Developer sees gaps in real time
4. Self-service action requests review
5. Dashboard shows org-wide posture
6. CI/CD gating enforces standards

**Transition:** "Now let's zoom into the detailed flow with all the actors and tools."

---

## Slide 7: The Workflow in Detail (3 min)

> "This is the same transformation, but with actors and tools called out."

**Walk through the left side (Current State):**
- Each step shows WHO is involved and WHAT tools they touch
- Tool sprawl: Confluence, Google Docs, Notion for checklists
- Datadog, Snyk, GitHub, Jira for review
- CI/CD and K8s for deploy
- Six handoffs across multiple humans and multiple tools
- "This is chaos at scale"

**Walk through the right side (With Port):**
- Same six conceptual steps, but actors collapse to mostly "Automated" or "Port"
- Tool sprawl collapses: GitHub → Port → CI/CD enforcement
- One source of truth instead of ten
- Only steps 3 and 4 need human (developer) input

**Key points to call out:**
- Point to monitoring tool tags: "See how it lives across Datadog AND Snyk AND GitHub on the left? On the right, those signals flow INTO Port."
- Point to the green callout: "Single source of truth, automated evaluation, developer autonomy"
- Point to the legend: "Notice how much shifts from humans to automation"

**Transition:** "Let me show you what I actually built in Port."

---

## Slide 8: Solution Architecture (2 min)

> "Four components, all working together."

**Walk through each numbered card:**

1. **GitHub Integration** — 5 microservice repos auto-synced. README, CODEOWNERS, CI workflows ingested.
2. **Walmart Production Readiness Scorecard** — 3 custom rules across Silver and Gold tiers. Continuously evaluated.
3. **Request Prod Review Action** — Day-2 self-service action using UPSERT_ENTITY. No backend required.
4. **Production Readiness Dashboard** — All services, Gold path, and Needs Attention with embedded action card.

**Mention:** "I created 5 actual Walmart-themed GitHub repos — checkout, inventory, payment, notification, search — each with realistic variation in README, CODEOWNERS, and CI workflow files. This is real GitHub data, not mocked."

**Transition:** "Let me go deeper on the scorecard, since that's the heart of the solution."

---

## Slide 9: Scorecard Deep Dive (3 min)

> "The scorecard has three tiers tied directly to Walmart's stack."

- **BASIC** — Default. Every new service starts here. No Walmart rules passed yet.
- **SILVER** (2 rules):
  - **Has Monitoring (Datadog)** — Walmart's stack explicitly includes Datadog. Maps to their real tooling.
  - **No Critical Vulnerabilities (Snyk)** — Snyk is also in Walmart's stack. Prevents incidents.
- **GOLD** (1 rule):
  - **Has On-Call Runbook** — Separates services that recover quickly from services with hour-long outages. Directly reduces MTTR.

**Emphasize:**
- "These are based on real, queryable properties — not subjective judgment."
- "Walmart could easily customize: data residency rules for India, GDPR rules for Europe. The model is flexible."

**Transition:** "And when a developer sees they're not at their target level, here's what they can do about it."

---

## Slide 10: Self-Service Action (2 min)

> "Developers go to their service and click 'Request Production Readiness Review.'"

**Action details:**
- **Type:** Day-2 — operates on an existing service
- **Inputs:** Target Level (Bronze/Silver/Gold) + optional notes

**What happens:**
- Entity updated: `reviewRequested = true`
- `targetLevel` and `reviewNotes` stored
- In our POC, that's enough — the catalog IS the system of record
- In production, you'd add a webhook → Slack notification + Jira ticket

**Key benefit:** "Developers get autonomy. Platform teams get structured requests instead of random Slack DMs."

**Transition:** "Let me switch to the live environment and show you all of this in action."

---

## Slide 11: Live Demo (10 minutes)

> "I'm going to walk through five things in Port."

### Pre-demo checklist (do BEFORE the slide goes up)
- Have **app.getport.io** open
- Land on the **Walmart Production Readiness** dashboard
- Reset `reviewRequested = false` on Search Service for clean demo
- Have notes pane open on a second screen

### Scene 1: Catalog (2 min)

> **Say:** "Let me start by showing you the Walmart service catalog."

1. Click **Catalog > Services**
2. Point to column headers: Title, Owning Teams, Hub, Has Monitoring, Has Runbook, Critical Vulns
3. Point to the variation across services

> **Say:** "Notice every service has the same set of properties. Same standards across all hubs. That alone is something Walmart doesn't have today."

### Scene 2: Gold Service (1.5 min)

> **Say:** "Let's look at a fully production-ready service — Checkout Service."

1. Click **Checkout Service**
2. Show **Overview** tab — Hub = US-Bentonville, all green
3. Click **Scorecards** tab
4. Point to **Walmart Production Readiness** — all 3 rules passing

> **Say:** "Three Walmart-specific rules: monitoring, no critical vulns, runbook. This service hits Gold because it passes all three. No manual review needed."

### Scene 3: Basic Service (2 min)

> **Say:** "Now let's look at a service that's NOT production-ready. Search Service."

1. Click **Search Service**
2. Show properties — all booleans false
3. Click **Scorecards** tab
4. Point to failing rules with red X marks

> **Say:** "Three rules failing. Today this might deploy anyway. With Port, the gaps are visible immediately."

### Scene 4: Trigger the Action (2 min)

> **Say:** "Here's where developer autonomy kicks in."

1. On Search Service, click **Execute action** (or click the dashboard action card)
2. Fill the form:
   - **Target Level:** Gold
   - **Notes:** "Need to reach Gold before Black Friday — adding Datadog and runbook this sprint"
3. Click **Execute**
4. Refresh — show `reviewRequested = true`, `targetLevel = Gold`, notes saved

> **Say:** "Day-2 action using UPSERT_ENTITY backend. No Lambda, no webhook. In production, this would also notify Slack and create a Jira ticket."

### Scene 5: Dashboard (2 min)

> **Say:** "Finally, the dashboard. VP-level visibility."

1. Click **Walmart Production Readiness** in left sidebar
2. Walk through each table:
   - **All Walmart Services** — complete catalog with scorecard levels
   - **Services Needing Attention** — Payment Gateway, Search Service
   - **Production-Ready Services (Gold Path)** — Checkout, Notification Worker
3. Point to the embedded action card

> **Say:** "A VP can answer 'how production-ready are we?' in under 30 seconds. Today, that question would take weeks of manual surveys."

### Scene 6: Close (30 sec)

> **Say:** "What we showed is a focused POC — one scorecard, one action, one dashboard, five services. Production deployment would extend this to all 12,000 services across 10 hubs, with real-time Datadog and Snyk feeds, and CI/CD gating below Bronze."

**Then switch back to slides for Expected Outcomes.**

### If something breaks
- Stay calm — don't apologize repeatedly
- Show the dashboard — most resilient view
- Say: "Let me show you the dashboard view instead — same story"
- Worst case: return to slides and describe what they would see

---

## Slide 12: Expected Outcomes (3 min)

> "Here's what we'd expect to see within six months of rolling this out."

**Walk through the table:**

| Metric | Before | After |
|--------|--------|-------|
| Production readiness compliance | ~35% | 80%+ |
| Manual review time per service | 2-4 hours | 15 min |
| Platform team review capacity | 40% | <10% |
| Incidents from readiness gaps | Baseline | 50% fewer |
| Developer time-to-deploy | Days | Hours |

**Key callouts:**
- "Most services are Basic today because there's no visibility. Once developers can see their score, they fix gaps proactively. It's a behavior change."
- "The platform team gets 30 percentage points of their week back — that becomes new platform capabilities."
- "Services that meet Silver+ have monitoring and clean security scans — the top two causes of preventable incidents."

**Closing line:** "Fewer incidents, faster deploys, reclaimed capacity. That's the ROI."

**Transition:** "And this is just the starting point."

---

## Slide 13: What's Next (2 min)

> "What I showed today is a focused POC. Here's how you'd extend it."

**Phase 2 roadmap:**
- **Kubernetes integration** — map clusters, namespaces, deployments per hub
- **Snyk integration** — real-time vulnerability scoring in the scorecard
- **Datadog integration** — auto-validate monitoring + alerting coverage
- **CI/CD Gating** — block deploys below Bronze in GitHub Actions
- **More Scorecards** — security, cost, documentation layered on top
- **10-Hub Rollout** — hub-specific dashboards for regional leads

**Transition:** "Thank you — happy to take questions."

---

## Slide 14: Q&A

> "Thank you. Happy to discuss any aspect — use case, technical implementation, or extensions."

---

## Anticipated Q&A

### Q: How does this scale to 12,000 developers?

> Port's catalog is designed for enterprise scale. Walmart Labs-sized orgs use Port at this scale today. RBAC scopes visibility by team and hub — developers only see their services, team leads see their team, leadership sees everything.

### Q: How long would a full Walmart rollout take?

> A 2-3 person platform engineering team could have the core setup running in 2-3 weeks. The integrations are the variable — GitHub is quick, K8s and Snyk depend on their infrastructure. A phased rollout across the 10 hubs over 2-3 months would be realistic. Start with Bentonville, then roll out region by region.

### Q: What if different hubs need different standards?

> Port supports multiple scorecards per blueprint and customizable rules. India might add data residency rules. Europe might add GDPR. The Walmart baseline stays consistent with hub-specific scorecards layered on top.

### Q: Can the scorecard block deployments?

> Not directly in Port — but Port exposes a public API. Add one step to your GitHub Actions or Jenkins pipeline that queries Port for the scorecard level. If below Bronze, the pipeline fails. Hard enforcement without changing Port itself.

### Q: How does this compare to Backstage?

> Backstage is a framework you build on — requires significant engineering investment to build features Port gives you out of the box, plus ongoing maintenance burden. Port is a managed platform with native scorecards, self-service actions, AI assistant, and 50+ integrations. For an org like Walmart that wants time-to-value, Port removes the build-and-maintain burden.

### Q: What's the ROI?

> Three layers: (1) Reduced incident cost — preventing one major incident during Black Friday pays for the platform. (2) Reclaimed platform team capacity — 40% of their time back. (3) Faster developer velocity — no more days-long waits for reviews. The platform pays for itself with one avoided outage.

### Q: How could you extend the demo?

> Phase 2 roadmap: Datadog integration auto-populates hasMonitoring. Snyk integration provides real-time vuln counts. K8s maps clusters per hub. CI/CD gating blocks deploys below Bronze. Additional scorecards for Security Readiness, Cost Optimization, Documentation Coverage. Hub-specific dashboards.

### Closing note

> Thank the audience genuinely. If asked for next steps, offer to share the GitHub repo: **github.com/KaylahBuilds/walmart-production-readiness-port**

---

## Pre-Presentation Checklist

### 1 Hour Before
- [ ] Open Port — verify dashboard loads
- [ ] Verify all 5 services have correct properties
- [ ] Reset `reviewRequested = false` on Search Service
- [ ] Open slides on second screen
- [ ] Charge laptop + bring charger

### 5 Minutes Before
- [ ] Close extra browser tabs
- [ ] Silence notifications
- [ ] Bring up the title slide
- [ ] Deep breath

### During the Demo
- [ ] Speak slowly during transitions
- [ ] Use the audience: "Questions on this part before I move on?"
- [ ] If something breaks: stay calm, show the dashboard

---

## Files & Resources

| File | Location |
|------|----------|
| Slide Deck | `/Users/kaylahgore/Desktop/Walmart_Production_Readiness_Presentation.pptx` |
| Flowchart (image) | `flowchart/flowchart.png` (embedded in slide 7) |
| Flowchart (HTML source) | `flowchart/flowchart.html` |
| Port Configs | `port-config/` in this repo |
| GitHub Repo | https://github.com/KaylahBuilds/walmart-production-readiness-port |
| Port Portal | https://app.getport.io |

### Walmart Demo Repos on GitHub

- https://github.com/KaylahBuilds/checkout-service (Gold)
- https://github.com/KaylahBuilds/inventory-api (Silver)
- https://github.com/KaylahBuilds/notification-worker (Gold)
- https://github.com/KaylahBuilds/payment-gateway (Basic)
- https://github.com/KaylahBuilds/search-service (Basic)
- https://github.com/KaylahBuilds/user-auth
