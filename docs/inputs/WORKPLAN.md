# Implementation Workplan
**Use with:** `/plan docs/inputs/WORKPLAN.md`

**Timeline:** 20 weeks | **Team:** 7 (4-6 engineers + PM + designer) | **Budget:** $50k dev + $15k/month infra

---

## Phases Overview

| Phase | Weeks | Goal | Milestone |
|-------|-------|------|-----------|
| **0: Foundation** | 1-2 | Infrastructure + API access | CI/CD + DB + APIs ready |
| **1: Core MVP** | 3-8 | Working discussion (3+ agents) | End-to-end discussion <5 min |
| **2: Socratic + Judges** | 9-12 | Socratic method + judge panel | >70% consensus, CARE >10% better |
| **3: Advanced** | 13-16 | 7+ LLMs + polish + security | <60s first round, audit passed |
| **4: Beta Launch** | 17-20 | 50+ users, iteration | NPS >40, launch ready |

---

## Phase 0: Foundation (Weeks 1-2)

### Week 1: Infrastructure

| Task | Owner | Deliverable |
|------|-------|-------------|
| Git repo + CI/CD (GitHub Actions) | DevOps | Pipeline operational |
| Docker dev environment | DevOps | docker-compose.yml |
| Staging/prod environments (AWS/GCP) | DevOps | Deployed |
| Monitoring (Datadog/Prometheus) | DevOps | Dashboards configured |
| Monorepo structure (backend, frontend, shared) | Backend Lead | Project scaffolding |

### Week 2: API Access & Database

| Task | Owner | Deliverable |
|------|-------|-------------|
| LLM APIs: OpenAI, Claude, Perplexity | Backend Lead | Keys + LiteLLM integration |
| Tool APIs: Alpha Vantage, Wolfram | Backend Lead | Keys + test calls |
| Code sandbox (E2B/Modal) | Backend Lead | Sandbox operational |
| PostgreSQL 15+ + Redis 7.2+ | Backend Lead | Provisioned |
| Database schema v1.0 | Backend Lead | Migrations working |
| Secrets management (AWS Secrets Manager) | DevOps | All keys secured |

**Success Criteria:**
- ✅ CI/CD pipeline operational
- ✅ All API keys secured and tested
- ✅ Database schema v1.0 deployed
- ✅ Local dev environment functional

---

## Phase 1: Core MVP (Weeks 3-8)

### Sprint 1 (Weeks 3-4): Agent Runtime

**Tasks:**
- [ ] Agent base class + AgentPool (3-10 agents)
- [ ] LiteLLM integration (OpenAI, Claude, Perplexity)
- [ ] Agent config (model, temperature, max_tokens)
- [ ] Contribution formatting + validation
- [ ] Token counting + budget (2K/contribution, 50K/discussion)
- [ ] Agent state management
- [ ] System prompts for roles
- [ ] Prompt injection prevention
- [ ] Unit tests (>80% coverage)
- [ ] Integration tests with real LLM APIs

**Deliverables:** `agents/base.py`, `agents/pool.py`, `agents/prompts/`

**Acceptance:**
- Create 5 agents with diverse providers
- Each agent generates valid contribution (<2K tokens)
- Token budget enforced
- Prompt injection blocked

**Team:** Backend #1 (lead), Backend #2

---

### Sprint 2 (Weeks 5-6): Tool Integration

**Tasks:**
- [ ] Tool interface + registry (MCP standard)
- [ ] Tool result caching (Redis, 15min TTL)
- [ ] Timeout handling (30s)
- [ ] "Explain before calling" pattern
- [ ] Security layer (input sanitization)
- [ ] **Tools:** Perplexity Sonar Pro, Alpha Vantage, Code Sandbox, Wolfram Alpha
- [ ] Tool calling in agent workflow
- [ ] Result parsing
- [ ] Retry logic (2× exponential backoff)
- [ ] Usage logging
- [ ] Unit + integration tests

**Deliverables:** `tools/base.py`, `tools/{perplexity,alpha_vantage,code_sandbox,wolfram}.py`, `tools/registry.py`

**Acceptance:**
- Agent calls Perplexity and receives results
- Agent fetches stock data from Alpha Vantage
- Agent executes Python code in sandbox
- Tool failures handled gracefully

**Team:** Backend #2 (lead), Backend #1

---

### Sprint 3 (Weeks 7-8): Orchestration + UI

**Backend Tasks:**
- [ ] DiscussionWorkspace model
- [ ] Discussion lifecycle (4 phases)
- [ ] Turn-taking logic (round-robin)
- [ ] State management
- [ ] Simple consensus detection (keyword overlap >80%)
- [ ] Termination conditions (consensus, max rounds, stable state)
- [ ] History tracking
- [ ] Context window management (truncation, summarization)
- [ ] Evidence repository
- [ ] Database models (Discussion, Contribution, ToolCall, Citation)
- [ ] Orchestration tests
- [ ] Full discussion integration test

**Frontend Tasks:**
- [ ] Next.js 14+ project (App Router, TypeScript)
- [ ] shadcn/ui + Tailwind CSS
- [ ] Home page (discussion input)
- [ ] Progress page with SSE
- [ ] Agent contribution cards (expandable)
- [ ] Progress indicator (round counter, consensus %)
- [ ] Results page (summary display)
- [ ] Loading states
- [ ] Routing
- [ ] E2E tests (Playwright)

**API Tasks:**
- [ ] FastAPI app structure
- [ ] `/discussions` POST (start discussion)
- [ ] `/discussions/{id}` GET (get discussion)
- [ ] `/discussions/{id}/stream` SSE (real-time updates)
- [ ] JWT auth middleware
- [ ] Rate limiting (100 req/min)
- [ ] API integration tests

**Deliverables:**
- `orchestration/discussion_manager.py`, `orchestration/phase_controller.py`, `orchestration/consensus_tracker.py`
- `models/discussion.py`, `models/contribution.py`
- `api/main.py`, `api/routes/discussions.py`
- `frontend/` - Full Next.js app

**Acceptance:**
- User enters question → discussion starts (5 agents, 5 rounds)
- Discussion progresses through 4 phases
- Agents make tool calls successfully
- Simple consensus detected (>80%)
- Discussion terminates correctly
- User sees real-time updates (SSE)
- Results page shows summary + evidence + transcript
- Discussion <5 min

**Team:** All engineers, Frontend (lead for UI), Designer

**Phase 1 Success Criteria:**
- ✅ End-to-end discussion with 3+ agents
- ✅ 2+ tools functional
- ✅ Basic UI working
- ✅ Unit >80%, integration >70%
- ✅ Discussion <5 min (p95)

---

## Phase 2: Socratic + Judges (Weeks 9-12)

### Sprint 4 (Weeks 9-10): Socratic Framework

**Tasks:**
- [ ] IntelliChain question reformulation
- [ ] Assumption identification prompts
- [ ] Clarification question templates
- [ ] Logical consistency checking
- [ ] Evidence demand patterns
- [ ] Strategic engagement (agents choose responses)
- [ ] Position updating (agents change views)
- [ ] Confidence scoring (0-1)
- [ ] Chain-of-thought reasoning
- [ ] CONSENSAGENT sycophancy mitigation
  - Independent analysis phase
  - Conformity bias detection
  - Diverse perspective enforcement
- [ ] Devil's advocate role
- [ ] Vector DB (Pinecone/Weaviate)
- [ ] Knowledge graph (concepts, relationships)
- [ ] Semantic search for context
- [ ] Link related discussions
- [ ] Update agent prompts
- [ ] Manual evaluation (10 discussions)

**Deliverables:**
- `agents/socratic_prompts.py`, `agents/socratic_engine.py`, `agents/position_tracker.py`
- `knowledge_graph/vector_store.py`, `knowledge_graph/semantic_search.py`

**Acceptance:**
- Agents pose probing questions (>1 per contribution)
- Agents identify assumptions explicitly
- Agents update positions with better evidence
- Sycophancy mitigation prevents premature consensus
- Devil's advocate challenges majority
- Knowledge graph stores/retrieves concepts

**Team:** Backend #1 (lead), Backend #2

---

### Sprint 5 (Weeks 11-12): Judge Panel + CARE + Parlant

**Judge Panel Tasks:**
- [ ] Judge agent subclass
- [ ] 5-dimension evaluation criteria (factual, logical, novel, engagement, consensus)
- [ ] Structured judge output (JSON schema)
- [ ] Quality scoring per contribution
- [ ] JudgePanel class (3-5 judges)
- [ ] Judge rotation (diverse providers)
- [ ] CARE aggregation algorithm (NeurIPS 2025)
- [ ] Judge correlation matrix (historical data)
- [ ] Systematic bias detection (verbosity, position)
- [ ] Adaptive weighting
- [ ] Replace keyword consensus with judge-based
- [ ] Consensus level calculation (0-1, weighted)
- [ ] Agreed/debated points extraction
- [ ] Confidence intervals
- [ ] Judge feedback integration into next round
- [ ] Judge disagreement handling
- [ ] Unit tests (CARE algorithm)
- [ ] Integration tests (judge panel)
- [ ] Benchmark: CARE vs. majority vote (>10% target)
- [ ] UI: Judge feedback display, consensus chart

**Parlant Tasks:**
- [ ] Install Parlant 3.0+
- [ ] Behavioral guidelines (Rigorous Analyst, Critical Challenger, Evidence-Focused Researcher)
- [ ] Journey templates (discussion phases)
- [ ] Tool orchestration via Parlant
- [ ] Canned responses (evidence request, assumption challenge, position update, consensus proposal)
- [ ] Integrate into agent workflow
- [ ] Test guideline enforcement
- [ ] Validate journey flow
- [ ] Measure quality improvement (manual)

**Deliverables:**
- `judges/base.py`, `judges/panel.py`, `judges/care_aggregation.py`, `judges/schemas.py`
- `parlant/guidelines/`, `parlant/journeys/`, `parlant/responses/`
- Frontend: Judge feedback UI, consensus chart

**Acceptance:**
- Judge panel (3-5) evaluates each round
- Judges score across 5 dimensions
- CARE aggregation with bias mitigation
- Consensus detection improved (>70% reach >80%)
- CARE outperforms majority vote by >10%
- Judge feedback influences next round
- UI shows scores + consensus evolution
- Agents follow behavioral guidelines
- Quality improvement >20% (manual review)

**Team:** Backend #2 (lead - judges), Backend #1 (CARE + Parlant), Frontend (UI)

**Phase 2 Success Criteria:**
- ✅ Socratic questioning evident
- ✅ Judge panel operational
- ✅ CARE >10% better than baseline
- ✅ Consensus rate >70%
- ✅ Parlant integrated
- ✅ Quality improvement >30% vs. Phase 1

---

## Phase 3: Advanced Features (Weeks 13-16)

### Sprint 6 (Weeks 13-14): Extended LLM + Tools

**Tasks:**
- [ ] Gemini 2.0 integration
- [ ] DeepSeek V3/Reasoner integration
- [ ] Kimi K2 integration
- [ ] Llama integration (via Together AI/Replicate)
- [ ] Update LiteLLM config
- [ ] Handle varying context windows (8K-200K)
- [ ] Adapt to different tool calling formats
- [ ] Provider-specific prompt optimization
- [ ] Provider fallbacks
- [ ] Yahoo Finance API (fallback)
- [ ] Brave Search API (fallback)
- [ ] Code sandbox: add matplotlib, seaborn
- [ ] Visualization generation
- [ ] Cross-provider compatibility tests
- [ ] Performance benchmarking per provider
- [ ] Cost analysis per provider

**Deliverables:** 7+ LLM providers, enhanced tools (6+), visualizations, cost tracking

**Acceptance:**
- All 7 providers interchangeable
- Graceful fallback when provider unavailable
- Visualizations generated and embedded
- Cost tracked accurately

**Team:** Backend #1 (lead), Backend #2

---

### Sprint 7 (Weeks 15-16): Advanced UI + Performance + Security

**Frontend Tasks:**
- [ ] Advanced config modal (agents, LLMs, tools, style, rounds)
- [ ] Discussion templates (Investment, Research, Geopolitical, Tech) + custom builder
- [ ] Enhanced view (collapsible contributions, inline citations, evidence sidebar, consensus chart)
- [ ] Result enhancements (exec summary, key insights, visual evolution, dissenting views, export PDF/MD/JSON)
- [ ] User features (history, saved templates, favorites, share links)
- [ ] Mobile responsive (bonus)

**Performance Tasks:**
- [ ] Parallel agent execution (asyncio)
- [ ] Aggressive caching (Redis: tool results 15min, LLM responses 1h)
- [ ] Optimize DB queries (indexes, connection pooling)
- [ ] Request batching for LLM APIs
- [ ] CDN for static assets
- [ ] Lazy load UI components
- [ ] Code splitting
- [ ] Load testing (100 concurrent discussions)
- [ ] Performance profiling
- [ ] Optimize based on profiling

**Security Tasks:**
- [ ] Rate limiting per user (100 req/min)
- [ ] Prompt injection detection
- [ ] Secure API keys (AWS Secrets Manager)
- [ ] Input sanitization
- [ ] Output content filtering
- [ ] HTTPS enforcement
- [ ] CORS configuration
- [ ] Security headers (HSTS, X-Frame-Options, CSP)
- [ ] Dependency scanning (Dependabot, Snyk)
- [ ] Penetration testing (external audit)
- [ ] Address all P0/P1 findings

**Monitoring Tasks:**
- [ ] Detailed structured logging
- [ ] Distributed tracing (OpenTelemetry)
- [ ] Grafana dashboards (discussion metrics, LLM metrics, tool usage, errors)
- [ ] Alerts (P0: error >5%, P1: latency >2x, P2: cost >$20k/month)
- [ ] User analytics (PostHog/Mixpanel)

**Deliverables:** Advanced UI, templates, performance <60s first round, security audit passed, monitoring operational

**Acceptance:**
- Discussion <60s to first round (p95)
- Total <10 min (p95)
- Lighthouse >90
- Security audit passed (no P0/P1)
- 100 concurrent discussions handled

**Team:** Frontend (lead), Backend #1 (perf), Backend #2 (security), DevOps (monitoring), Designer

**Phase 3 Success Criteria:**
- ✅ 7+ providers
- ✅ Advanced UI functional
- ✅ Templates working
- ✅ Performance: <60s first round
- ✅ Security audit passed
- ✅ Monitoring operational
- ✅ Load test: 100 concurrent

---

## Phase 4: Beta Launch (Weeks 17-20)

### Sprint 8 (Week 17): Beta Prep

**Tasks:**
- [ ] Production environment (Kubernetes/ECS, auto-scaling 2-10, load balancer)
- [ ] Backup/recovery (daily DB backups 30 days, S3 artifacts, recovery playbook)
- [ ] Usage quotas (Free: 5/month, Pro: 50/month, Enterprise: unlimited)
- [ ] Admin dashboard (user mgmt, usage monitoring, cost tracking, feature flags)
- [ ] User documentation (guide, FAQ, troubleshooting, video walkthrough)
- [ ] Onboarding (welcome emails, in-app tutorial, sample discussions)
- [ ] Beta program (recruit 50-100 users, feedback system, user interviews, feature requests)
- [ ] Billing (Stripe, subscription tiers, usage tracking, invoicing)

**Deliverables:** Prod deployed, admin dashboard, docs, onboarding, beta infrastructure, billing

**Acceptance:**
- Prod stable (>99% uptime)
- 50 beta users invited
- Docs accessible
- Billing processes test payments

**Team:** DevOps (prod), Backend #2 (admin/billing), Frontend (onboarding), Designer, PM (beta), Tech Writer

---

### Sprint 9 (Weeks 18-19): Beta Testing + Iteration

**Tasks:**
- [ ] Monitor activity (DAU/WAU, completion rate, drop-off, tool usage)
- [ ] User interviews (10-15 sessions)
- [ ] Feedback surveys (post-discussion, weekly, NPS)
- [ ] Analyze usage (topics, discussion length, consensus rate, tool patterns, cost/discussion)
- [ ] Prioritize issues (P0: fix immediately, P1: fix in sprint, P2: if time, features: top 3)
- [ ] Implement fixes (bugs, UI/UX refinements, performance, quick features)
- [ ] Iterate on prompts (A/B test, optimize, improve Socratic)
- [ ] Track KPIs (user preference >80%, consensus >70%, accuracy >90%, NPS >40, time <10min)

**Deliverables:** 100+ discussions, interview insights, all P0/P1 fixed, UI refinements, KPI dashboard

**Acceptance:**
- 50+ users active
- 100+ discussions completed
- All critical bugs resolved
- Metrics meet targets
- NPS >40

**Team:** All engineers, PM, Designer

---

### Sprint 10 (Week 20): Launch Prep

**Tasks:**
- [ ] Final bug fixes (P2)
- [ ] UI/UX polish (animations, loading consistency, error clarity, mobile check)
- [ ] Performance tuning (bottlenecks, slow queries, LLM latency optimization)
- [ ] Security audit (re-run pen test, address findings, update dependencies, review access)
- [ ] Documentation updates (user guide, FAQ, API docs)
- [ ] Launch materials (landing page, blog post, demo videos, press kit, social posts)
- [ ] Pricing finalization (Free: 5/month, Pro: $29/month 50 discussions, Enterprise: custom)
- [ ] Marketing (Product Hunt, email list 1000+, community outreach, influencer outreach)
- [ ] Final testing (regression, load 1000 concurrent, chaos engineering)
- [ ] Launch checklist (tests ✓, docs ✓, monitoring ✓, backup ✓, support email ✓, pricing ✓, ToS/privacy ✓, blog ✓, Product Hunt ✓)

**Deliverables:** All bugs fixed, polished UI, security audit passed, launch materials, pricing live, marketing ready, launch checklist 100%

**Acceptance:**
- All critical paths tested
- No P0/P1 bugs
- Security audit passed
- Performance meets targets
- Launch checklist 100%

**Team:** All

**Phase 4 Success Criteria:**
- ✅ 50+ beta users
- ✅ 100+ discussions
- ✅ NPS >40
- ✅ >80% user preference
- ✅ <5% critical bug rate
- ✅ Launch ready

---

## Resource Allocation

| Role | Allocation | Responsibilities |
|------|------------|------------------|
| Backend Lead | Full-time (20w) | Architecture, agents, orchestration, Parlant |
| Backend #1 | Full-time (20w) | Agents, Socratic, judge panel |
| Backend #2 | Full-time (20w) | Tools, CARE, security |
| Frontend | Full-time (W7-20) | UI/UX, real-time, templates |
| DevOps | Part-time 40% (W1-2, 13-20) | Infrastructure, CI/CD, monitoring |
| PM | Full-time (20w) | Roadmap, user research, coordination |
| Designer | Part-time 30% (W1, 7-8, 15-20) | UI design, user flows, polish |

---

## Budget

| Category | Amount | Notes |
|----------|--------|-------|
| **Personnel (20w)** | $285k-345k | 3 backend, 1 frontend, PM, DevOps (pt), Designer (pt) |
| **Infrastructure** | $34k-62k | Dev $4-8k, Staging $15-29k, Beta $15-25k |
| **External Services** | $23k-35k | LLM APIs $20-30k, Domain/SSL/email/tools $3-5k |
| **Total** | **$342k-442k** | Full budget |
| **Constrained** | **$50k** | 4 engineers + PM, extend to 24-26w, ruthless prioritization |

---

## Dependencies & Critical Path

### External Dependencies (Due Dates)
- [ ] LLM API access (OpenAI, Claude, Perplexity) - **Week 2**
- [ ] Tool API keys (Alpha Vantage, Wolfram) - **Week 2**
- [ ] Code sandbox (E2B/Modal) - **Week 2**
- [ ] Cloud provider account - **Week 1**
- [ ] Domain registration - **Week 1**

### Critical Path
```
Week 1-2: Infrastructure
    ↓ (BLOCKS ALL)
Week 3-4: Agent Runtime
    ↓ (BLOCKS AGENTS)
Week 5-6: Tool Integration
    ↓ (BLOCKS DISCUSSIONS)
Week 7-8: Orchestration + UI
    ↓ (MILESTONE: MVP)
Week 9-10: Socratic Framework
    ↓ (BLOCKS JUDGES)
Week 11-12: Judge Panel + Parlant
    ↓ (MILESTONE: Core Complete)
Week 13-14: Extended LLM + Tools
    ↓ (PARALLEL WITH UI)
Week 15-16: Advanced UI + Perf + Security
    ↓ (MILESTONE: Prod Ready)
Week 17: Beta Prep
    ↓
Week 18-19: Beta Testing
    ↓
Week 20: Launch Prep
    ↓ (MILESTONE: Public Launch)
```

---

## Risk Management

| Risk | Impact | Prob | Mitigation | Contingency |
|------|--------|------|------------|-------------|
| **LLM API rate limits** | High | High | Queue requests, multiple keys, provider diversity | Add providers, increase limits |
| **High latency (>10min)** | High | Med | Parallel execution, streaming, quick mode | Set expectations, async processing |
| **Cost exceeds budget** | High | High | Token budgets, cheaper models, caching, quotas | Reduce agents, shorter discussions, increase pricing |
| **Security breach** | Critical | Low | Audit, sanitization, secrets mgmt, monitoring | Incident response, insurance, disclosure |
| **Team member leaves** | Med | Med | Documentation, code reviews, knowledge sharing | Cross-train, extend timeline, hire |
| **LLM hallucinations** | Med | Med | Judge filtering, fact-checking, confidence scores | Disclaimer, user challenges, downrank |
| **Tool API failures** | Med | Med | Fallbacks, retry, graceful degradation | Continue without tool data |
| **Low adoption** | Med | Med | Beta testing, user research, iteration, marketing | Pivot features, adjust pricing, retarget |

---

## Milestones & Decision Points

| Milestone | Week | Criteria | Go/No-Go Decision |
|-----------|------|----------|-------------------|
| **Foundation Complete** | 2 | CI/CD + API keys + DB | Go if API access granted |
| **MVP Complete** | 8 | End-to-end discussion, <5 min | Go if >70% user preference |
| **Core Features Complete** | 12 | Socratic + judges, consensus >70%, CARE >10% | Go if judge panel demonstrably better |
| **Production Ready** | 16 | 7+ LLMs, <60s, security audit passed | Go if <5% critical bugs |
| **Launch Ready** | 20 | 50+ users, 100+ discussions, NPS >40 | Go if stable + metrics met |

---

## Success Metrics by Phase

| Phase | Success Criteria |
|-------|------------------|
| **Phase 1 (W8)** | 1 end-to-end discussion, <5 min, 2+ tools, basic UI |
| **Phase 2 (W12)** | Consensus >70%, Socratic evident, CARE >10% better |
| **Phase 3 (W16)** | 7+ providers, <60s first round, security audit passed |
| **Phase 4 (W20)** | 50+ users, 100+ discussions, NPS >40, >80% preference, <5% bugs |

---

**Version:** 1.0 | **Updated:** 2025-11-12
