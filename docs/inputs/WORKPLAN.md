# Implementation Workplan
**Use:** `/plan docs/inputs/WORKPLAN.md`

**Timeline:** 20 weeks | **Team:** 7 | **Budget (constrained):** $50k build (local-only MVP)

---

## Phases

| Phase | Weeks | Milestone |
|-------|-------|-----------|
| Phase 0: Foundation | 1-2 | CI/CD + DB + APIs |
| Phase 1: MVP | 3-8 | End-to-end <5 min |
| Phase 2: Socratic + Judges | 9-12 | Consensus >70%, CARE >10% |
| Phase 3: Advanced | 13-16 | <60s first round, security audit passed |
| Phase 4: Beta | 17-20 | NPS >40, launch ready |

---

## Phase 0 (W1-2)

**W1: Infrastructure**
- [ ] Git + CI/CD (GitHub Actions)
- [ ] Docker dev environment
- [ ] Local monitoring (structured logs)
- [ ] Monorepo (backend, frontend, shared)

**W2: APIs + Database**
- [ ] LLM APIs: OpenAI, Claude, Perplexity
- [ ] Tool APIs: Alpha Vantage, Wolfram
- [ ] Code sandbox (E2B/Modal)
- [ ] PostgreSQL 15+ + Redis 7.2+
- [ ] Schema v1.0 + migrations
- [ ] Secrets via `.env` (local)

**Success:** CI/CD operational; APIs tested; DB deployed

**Team:** DevOps + Backend Lead

---

## Phase 1 (W3-8)

### Sprint 1 (W3-4): Agent Runtime

**Tasks:**
- [ ] Agent base + AgentPool (3-10)
- [ ] LiteLLM (OpenAI, Claude, Perplexity)
- [ ] Token budget (2K/contribution, 50K/discussion)
- [ ] System prompts + injection prevention
- [ ] Unit >80%, integration tests

**Deliverable:** `agents/{base,pool,prompts}.py`
**Accept:** 5 agents (≥3 providers), <2K tokens per contribution, prompt injection blocked
**Team:** Backend #1 + #2

### Sprint 2 (W5-6): Tools

**Tasks:**
- [ ] Tool interface + registry (MCP)
- [ ] Cache (Redis 15min), timeout (30s)
- [ ] Perplexity, Alpha Vantage, Code Sandbox, Wolfram
- [ ] Retry 2×, unit + integration tests

**Deliverable:** `tools/{base,perplexity,alpha_vantage,code_sandbox,wolfram,registry}.py`
**Accept:** Agents call tools, receive results, handle failure (retry + fallback)
**Team:** Backend #2 + #1

### Sprint 3 (W7-8): Orchestration + UI

**Backend:**
- [ ] DiscussionWorkspace, lifecycle (4 phases), turn-taking
- [ ] Consensus (keyword >80%), termination, history
- [ ] Context management, evidence repo
- [ ] Models (Discussion, Contribution, ToolCall)
- [ ] Full integration test

**Frontend:**
- [ ] Next.js 14+ + shadcn/ui + Tailwind
- [ ] Home, progress (SSE), results pages
- [ ] Agent cards, progress indicator
- [ ] E2E tests (Playwright)

**API:**
- [ ] FastAPI: POST `/discussions`, GET `/discussions/{id}`, SSE `/discussions/{id}/stream`
- [ ] JWT auth, rate limit (100 req/min)

**Deliverable:** `orchestration/`, `models/`, `api/`, `frontend/`
**Accept:** User question → 5 agents × 5 rounds → consensus attempt → results in <5 min
**Team:** All engineers, Frontend (UI lead), Designer

**Success:** End-to-end run; ≥2 tools; basic UI streaming; unit >80%, integration >70%

---

## Phase 2 (W9-12)

### Sprint 4 (W9-10): Socratic

**Tasks:**
- [ ] IntelliChain reformulation, assumption ID, clarification templates
- [ ] Strategic engagement, position updates, confidence (0-1)
- [ ] CONSENSAGENT: independent phase, conformity detection, devil's advocate
- [ ] Vector DB (Pinecone/Weaviate), knowledge graph, semantic search
- [ ] Manual eval (10 discussions)

**Deliverable:** `agents/{socratic_prompts,socratic_engine,position_tracker}.py`, `knowledge_graph/`
**Accept:** Agents (each) pose ≥1 question, identify assumptions, update positions with confidence; premature consensus mitigated
**Team:** Backend #1 + #2

### Sprint 5 (W11-12): Judges + Parlant

**Judges:**
- [ ] Judge agent, 5-dimension eval, structured JSON output
- [ ] JudgePanel (3-5), rotation (diverse providers)
- [ ] CARE aggregation, correlation matrix, bias detection
- [ ] Consensus calculation (0-1), agreed/debated extraction
- [ ] Benchmark: CARE vs majority vote (>10%)
- [ ] UI: judge feedback, consensus chart

**Parlant:**
- [ ] Install 3.0+, guidelines (Analyst, Challenger, Researcher)
- [ ] Journey templates, tool orchestration, canned responses
- [ ] Manual quality eval

**Deliverable:** `judges/{base,panel,care_aggregation,schemas}.py`, `parlant/`, UI updates
**Accept:** Judge panel outputs structured JSON; CARE >10% over majority; consensus >70%; quality +≥20%
**Team:** Backend #2 (judges), Backend #1 (CARE + Parlant), Frontend

**Success:** Socratic implemented; judges operational; CARE >10%; consensus >70%; Parlant integrated; quality +≥30% vs Phase 1

---

## Phase 3 (W13-16)

### Sprint 6 (W13-14): Extended LLM + Tools

**Tasks:**
- [ ] Gemini, DeepSeek, Kimi, Llama integrations
- [ ] LiteLLM update, context windows (8K-200K), provider fallbacks
- [ ] Yahoo Finance, Brave Search
- [ ] Code sandbox: matplotlib, seaborn, visualizations
- [ ] Cross-provider tests, cost tracking

**Deliverable:** 7+ providers, 6+ tools, visualizations
**Accept:** Providers interchangeable; fallbacks work; visualizations embedded
**Team:** Backend #1 + #2

### Sprint 7 (W15-16): Advanced UI + Perf + Security

**Frontend:**
- [ ] Advanced config modal, templates (Investment/Research/Geopolitical/Tech)
- [ ] Enhanced view (collapsible, inline citations, sidebar, consensus chart)
- [ ] Result enhancements (summary, insights, evolution, export PDF/MD/JSON)
- [ ] User features (history, templates, favorites, share)

**Performance:**
- [ ] Parallel execution (asyncio), aggressive cache (Redis)
- [ ] DB optimize (indexes, pooling), LLM batching
- [ ] Lazy load, code split
- [ ] Load test (100 concurrent), profiling, optimize

**Security:**
- [ ] Rate limit/user, prompt injection detection, input sanitize
- [ ] HTTPS, CORS, security headers
- [ ] Dependency scan (Dependabot, Snyk)
- [ ] Penetration test, fix P0/P1

**Monitoring:**
- [ ] Structured logs, tracing (OpenTelemetry)
- [ ] Grafana dashboards, alerts (P0/P1/P2)
- [ ] User analytics (PostHog/Mixpanel)

**Deliverable:** Advanced UI, <60s first round, security passed, monitoring operational
**Accept:** First round <60s; total <10 min; Lighthouse >90; security audit passed; stable at 100 concurrent
**Team:** Frontend, Backend #1 (perf), Backend #2 (security), DevOps, Designer

**Success:** 7+ providers; advanced UI + templates; perf meets targets; monitoring active

---

## Phase 4 (W17-20)

### Sprint 8 (W17): Internal Beta Prep (Local)

**Tasks:**
- [ ] Package local app (scripts, Docker Compose)
- [ ] Local DB backup (daily, 30d retention) + recovery playbook
- [ ] Docs (guide, FAQ, troubleshooting, short video)
- [ ] Onboarding (tutorial, samples)
- [ ] Internal beta (recruit 20-50, feedback sessions)

**Deliverable:** Local build packaged; docs + onboarding ready; internal beta cohort recruited
**Accept:** ≥20 internal users invited; docs accessible; backups verified
**Team:** Backend #2, Frontend, Designer, PM, Tech Writer

### Sprint 9 (W18-19): Beta Test + Iterate (Local)

**Tasks:**
- [ ] Monitor (DAU/WAU, completion, drop-off, tools)
- [ ] Interviews (10-15), surveys (post-discussion, weekly, NPS)
- [ ] Analyze (topics, length, consensus, tool patterns, cost)
- [ ] Prioritize (P0: immediate, P1: sprint, P2: if time)
- [ ] Fix bugs, refine UI/UX, optimize performance
- [ ] Iterate prompts (A/B test)
- [ ] Track KPIs (preference >80%, consensus >70%, accuracy >90%, NPS >40)

**Deliverable:** 100+ discussions, insights, P0/P1 fixed, UI refined, KPI dashboard
**Accept:** ≥20 active users; ≥100 discussions; P0/P1 resolved; NPS >40
**Team:** All

### Sprint 10 (W20): Local Release Prep

**Tasks:**
- [ ] Final bug fixes (P2), UI polish
- [ ] Performance tune, security re-audit
- [ ] Docs update
- [ ] Release notes + changelog
- [ ] Final testing (regression, load 100, chaos)
- [ ] Release checklist

**Deliverable:** All bugs fixed, audit passed, checklist 100%
**Accept:** Zero P0/P1; audit passed; perf targets met; checklist 100%
**Team:** All

**Success:** ≥20 users; ≥100 discussions; NPS >40; user preference >80%; <5% critical bugs; local release ready

---

## Resources

| Role | Time | Responsibility |
|------|------|----------------|
| Backend Lead | 20w | Architecture, agents, orchestration |
| Backend #1 | 20w | Agents, Socratic, judges |
| Backend #2 | 20w | Tools, CARE, security |
| Frontend | W7-20 | UI/UX, real-time |
| DevOps | 40% (W1-2,13-20) | Infrastructure, CI/CD |
| PM | 20w | Roadmap, user research |
| Designer | 30% (W1,7-8,15-20) | UI design |

## Budget (Reference)

Constrained implementation budget: **$50k** (core engineering + PM). Extended estimates (personnel, infra, external) deferred until post-MVP.

## Critical Path

```
W1-2: Infrastructure → W3-4: Agents → W5-6: Tools → W7-8: Orchestration
↓ Local MVP
W9-10: Socratic → W11-12: Judges
↓ Core Complete
W13-14: LLMs → W15-16: UI/Perf/Security
↓ Local Release
W17: Prep → W18-19: Beta → W20: Release
```

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| LLM rate limits | High | Queue, multiple keys, provider diversity |
| High latency | High | Parallel, streaming, quick mode |
| Cost overrun | High | Token budgets, cheaper models, caching |
| Security breach | Critical | Audit, sanitization, monitoring |
| Team leaves | Med | Documentation, cross-train |

## Milestones

| Week | Criteria | Decision |
|------|----------|----------|
| 2 | CI/CD + APIs + DB | Proceed if API access stable |
| 8 | End-to-end <5 min | Proceed if >70% preference |
| 12 | Socratic + judges; consensus >70% | Proceed if CARE >10% gain |
| 16 | 7+ LLMs; <60s first round; audit | Proceed if <5% critical bugs |
| 20 | 50+ users; NPS >40 | Launch if stability confirmed |

## Success by Phase

| Phase | Criteria |
|-------|----------|
| Phase 1 (W8) | End-to-end <5 min; ≥2 tools; basic UI |
| Phase 2 (W12) | Socratic active; consensus >70%; CARE >10% |
| Phase 3 (W16) | 7+ providers; first round <60s; audit passed |
| Phase 4 (W20) | ≥50 users; ≥100 discussions; NPS >40; >80% preference |

---

**v1.0** | **2025-11-12**
