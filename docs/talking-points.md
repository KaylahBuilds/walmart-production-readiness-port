# Speaker Notes & Talking Points

## Walmart Production Readiness — Port Presentation

---

## Slide 1: Title (30 seconds)

> "Good [morning/afternoon]. Today I'm going to walk you through how Port can help Walmart standardize production readiness across 12,000 developers and 10 global engineering hubs. This is a real pain point at scale — and I'll show you a working prototype that demonstrates the approach."

---

## Slide 2: Platform Engineering & DevEx (5 minutes)

> "Before diving into the specific use case, let's align on what platform engineering is and why it matters."

**Key points to hit:**

- **Platform Engineering** is about building internal golden paths — paved roads that let developers ship faster while staying within guardrails. It's not about gatekeeping; it's about making the right thing the easy thing.
- **Internal Developer Portals** like Port are the interface layer. They give developers one place to see their services, understand ownership, check compliance status, and take actions — instead of bouncing between 10 different tools.
- **Developer Experience** is the metric we're optimizing. Can a developer discover what they need, build confidently, deploy safely, and operate effectively? If any of those steps are painful, velocity drops.
- **The business impact is real**: Gartner research shows organizations with mature platform engineering see significantly faster lead times and fewer production incidents.

**Transition:** "So with that context, let's look at the specific problem Walmart faces."

---

## Slide 3: The Problem (3 minutes)

> "Walmart is one of the largest engineering organizations in the world. 12,000 developers across 10 global hubs — from Bentonville to Bangalore to Santiago."

**Key points to hit:**

- Each hub has organically evolved its own standards. What "production ready" means in Sunnyvale might be completely different from what it means in Bangalore.
- There's no centralized visibility. If you're a VP of Engineering asking "how production-ready are we?" — nobody can answer that question confidently.
- The impact is tangible: incidents spike during the moments that matter most — Black Friday, Holiday Season. MTTR varies wildly across hubs.
- Platform teams are drowning — spending 40%+ of their time on manual reviews that don't scale.

**Transition:** "Let's look at who specifically feels this pain."

---

## Slide 4: Stakeholders (2 minutes)

> "This isn't just a platform team problem — it touches every layer of the organization."

**Key points to hit:**

- Walk through each stakeholder quickly — the point is to show this is an org-wide problem, not a niche concern.
- Emphasize the developer perspective: they genuinely don't know what's expected of them. Different hubs, different checklists, different reviewers.
- The VP/leadership angle is important for business value: they have zero visibility into readiness posture.

**Transition:** "And when you look at the numbers, the business case makes itself."

---

## Slide 5: Business Case (2 minutes)

> "Let me put some numbers to this."

**Key points to hit:**

- $13M+ per hour of downtime is an industry estimate for large retailers during peak events. Even a fraction of that justifies investment in production readiness tooling.
- 40% of platform team capacity is a huge number — that's almost half their team doing work that could be automated.
- The 3x variation in incident rates is the killer stat: it proves that standards work when they're enforced, and the gap is massive when they're not.
- Close with the revenue protection framing — this is a business investment, not a developer tools purchase.

**Transition:** "So let me show you how this process works today, and then what it looks like with Port."

---

## Slide 6: Current State (3 minutes)

> "Here's the workflow today. I want you to notice how many manual, subjective steps are involved."

**Key points to hit:**

- Walk through the six steps sequentially. Emphasize that at every step, there's human judgment and variability.
- Step 2 is the critical weakness: the checklist varies by hub. There's no single standard.
- Step 4: approval depends on *who* reviews. A senior engineer might catch issues a junior misses.
- Step 5 is the failure mode: problems discovered in production, not before deployment.
- Land on the callout: no single source of truth, no automation, no enforcement.

**Transition:** "Now here's what this looks like with Port."

---

## Slide 7: Proposed State (3 minutes)

> "Same six steps, completely different approach."

**Key points to hit:**

- Step 1: services are automatically ingested — no manual catalog maintenance.
- Step 2: the scorecard runs continuously. It's not a one-time review; it's always evaluating.
- Step 3: developers see their own score. This is the key shift — from "ask someone" to "I can see it myself."
- Step 4: self-service means developers fix gaps proactively, without waiting for platform team bandwidth.
- Step 5: leadership gets dashboards — the VP can finally answer "how ready are we?"
- Step 6: you can even enforce minimums — no deployment without Bronze.

**Contrast with the callout:** single source of truth, automated evaluation, developer autonomy.

**Transition:** "Let me show you what I actually built in Port."

---

## Slide 8: Solution Architecture (2 minutes)

> "Here's the architecture. Four components, all working together."

**Key points to hit:**

- **GitHub integration** pulls in the service catalog automatically. Properties like README existence, CI/CD workflows, and CODEOWNERS come straight from the repo.
- **Scorecard** evaluates every service against Bronze/Silver/Gold criteria continuously.
- **Self-service action** lets developers request reviews without Slack DMs or emails.
- **Dashboard** ties it all together with an org-wide view.

**Transition:** "Let me go deeper on the scorecard, since that's the heart of the solution."

---

## Slide 9: Scorecard Deep Dive (3 minutes)

> "The scorecard has three tiers, each building on the last."

**Key points to hit:**

- **Bronze is the floor** — every service in production must have a README and CI/CD. These are non-negotiable basics.
- **Silver adds operational maturity** — monitoring via Datadog and clean security scans via Snyk. This is where you prevent incidents.
- **Gold is excellence** — runbooks and designated ownership. This is where you reduce MTTR when incidents *do* happen.
- Emphasize that these rules are based on real, queryable properties — not subjective judgment.
- Mention that the levels are customizable — Walmart could add their own criteria or adjust thresholds.

**Transition:** "And when a developer sees they're not at their target level, here's what they can do about it."

---

## Slide 10: Self-Service Action (2 minutes)

> "This is the self-service action I built. A developer clicks 'Request Prod Review' on their service in Port."

**Key points to hit:**

- It's a DAY-2 action — it operates on an existing service, not creating a new one.
- The inputs are simple: which level are you targeting, and any notes for context.
- In the POC, it updates the catalog directly. In production, you'd wire this to a webhook that creates a Jira ticket and sends a Slack notification.
- The key benefit: developers get autonomy, platform teams get structured requests instead of random Slack DMs.

**Transition:** "Let me switch to the live environment and show you this in action."

---

## Slide 11: Live Demo (10 minutes)

> "I'm going to walk through four things in Port: the catalog, the scorecard, the action, and the dashboard."

**Demo script:**

1. **Catalog**: "Here are our services, ingested from GitHub. You can see each one has properties like language, hub, lifecycle, and our production readiness booleans."

2. **Gold service**: "Let's click into checkout-service. This is a Gold-level service — all rules passing. README, CI/CD, monitoring, security, runbook, and owner all present."

3. **Basic service**: "Now look at search-service. It's at Basic — missing almost everything. The scorecard clearly shows what's missing and what level each rule belongs to."

4. **Trigger action**: "As a developer, I can click 'Request Production Readiness Review', select Gold as my target, add a note, and submit. Watch the entity update — reviewRequested is now true."

5. **Dashboard**: "Finally, the dashboard. Here's the org-wide view — pie chart showing distribution across levels, table of services needing attention, and breakdown by hub."

**If asked questions during demo:**

- *"Can you customize the scorecard rules?"* — Yes, rules are fully configurable. You can add, remove, or modify rules and levels.
- *"What if we want to add more integrations?"* — Absolutely. Snyk, Datadog, K8s, Jira all have native integrations.
- *"How does this scale to 12,000 developers?"* — Port's catalog is designed for enterprise scale. RBAC lets you scope visibility by team/hub.

---

## Slide 12: Expected Outcomes (3 minutes)

> "Here's what we'd expect to see within six months of rolling this out."

**Key points to hit:**

- Walk through the table row by row. The "After Port" column represents realistic targets, not aspirational ones.
- **Compliance 35% to 80%+**: Most services are Basic today because there's no visibility. Once developers can see their score, they fix gaps proactively.
- **Review time 2-4 hours to 15 min**: The scorecard automates what a human reviewer does manually today.
- **Platform team capacity 40% to <10%**: This is the capacity story — reclaimed engineering time that can go toward building new capabilities.
- **50% incident reduction**: Services that meet Silver+ standards have monitoring and clean security scans — the top two causes of preventable incidents.
- **Days to hours**: Self-service means no more waiting on platform team bandwidth.

**Transition:** "And this is just the starting point."

---

## Slide 13: Extending the POC (2 minutes)

> "What I showed today is a focused POC — a slice of the full solution. Here's how you'd extend it."

**Key points to hit:**

- Kubernetes integration would map real cluster resources — not just services in a catalog, but actual running deployments, pods, namespaces.
- Snyk and Datadog integrations would make scorecard rules dynamic — instead of manually setting hasMonitoring, Port would check Datadog directly.
- Deployment gating is the enforcement layer — CI/CD pipelines check the scorecard level before allowing deployment to production.
- You could expand to other scorecards beyond production readiness: security, cost, documentation.
- Hub-specific dashboards would let regional leads see their own posture.

**Transition:** "Thank you — I'd love to take your questions."

---

## Slide 14: Q&A

> "Thank you for your time. I'm happy to discuss any aspect of this — the use case, the technical implementation, or how this could be extended."

---

## Anticipated Questions & Answers

### Q: "How long would a full implementation take?"

> "For a team of 2-3 platform engineers, you could have the core setup (catalog + scorecard + dashboard) running in 2-3 weeks. The integrations are the variable — GitHub is quick, K8s and Snyk may take longer depending on their infrastructure. A phased rollout across hubs over 2-3 months would be realistic."

### Q: "How does Port handle RBAC at Walmart's scale?"

> "Port supports team-based permissions. You can scope visibility so developers only see their own services, team leads see their team's services, and leadership sees everything. This maps naturally to Walmart's hub structure."

### Q: "What if different hubs need different standards?"

> "You can create multiple scorecards or customize rules per team. For example, the India hub might have additional compliance requirements. Port's model is flexible enough to handle variation while maintaining a baseline standard."

### Q: "How does this compare to Backstage?"

> "Backstage is open-source and requires significant engineering investment to build and maintain — it's essentially a framework you build on. Port is a managed platform with native features like scorecards, self-service actions, and integrations out of the box. For an organization like Walmart that wants time-to-value, Port removes the build-and-maintain burden."

### Q: "Can the scorecard block deployments?"

> "Not directly in Port — but Port integrates with CI/CD systems. You can add a step in your GitHub Actions or Jenkins pipeline that queries the Port API to check a service's scorecard level. If it's below Bronze, the pipeline fails. This gives you enforcement without changing Port itself."

### Q: "What's the cost impact?"

> "The ROI model centers on three things: reduced incident cost (even preventing one major incident during Black Friday pays for the platform), reclaimed platform team capacity (40% of their time back), and faster developer velocity. The platform practically pays for itself with one avoided outage."
