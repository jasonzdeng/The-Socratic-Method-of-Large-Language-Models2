# Product Requirements Document
**Use with:** `/specify docs/inputs/PRD.md`

**Version:** 1.0 | **Target:** Week 20 (Beta)

---

## Product Summary

**Problem:** Single-LLM responses lack rigor, multiple perspectives, critical analysis.

**Solution:** Multi-agent platform where 7+ LLMs debate using Socratic Method, judged by ensemble panel, producing evidence-based consensus.

**Value:** Most rigorous AI discussion platform challenging status quo through multi-perspective, tool-enhanced debate.

---

## Goals & Success Metrics

| Goal | Metric | Target |
|------|--------|--------|
| Multi-perspective analysis | Agents per discussion | 3-10 configurable |
| Evidence-based reasoning | Tool usage rate | >60% discussions |
| Consensus quality | Consensus achievement | >70% reach >80% agreement |
| Factual accuracy | Verified claims | >90% correct |
| User preference | vs. single-LLM | >80% prefer multi-agent |
| Performance | Discussion time (p95) | <10 minutes |
| User satisfaction | NPS score | >50 |

---

## Non-Goals (Out of Scope)

- ❌ Mobile native apps (web-first)
- ❌ Real-time multi-user collaboration
- ❌ Custom LLM fine-tuning
- ❌ Video/audio I/O
- ❌ Social features
- ❌ Non-English support (MVP)
- ❌ On-premise deployment
- ❌ Browser extensions
- ❌ Developer API (post-MVP)
- ❌ Slack/Teams integration (post-MVP)

---

## Users

| Persona | Need | Example | Success |
|---------|------|---------|---------|
| **Strategic Decision Makers** (C-suite, analysts) | Deep multi-perspective analysis | "Which AI companies dominate 2026?" | Better-informed decisions with confidence |
| **Researchers** (scientists, academics) | Literature synthesis, hypothesis exploration | "Most promising Alzheimer's treatments?" | Evidence-based analysis, days saved |
| **Critical Thinkers** (journalists, analysts) | Challenge mainstream, explore unconventional | "Hidden risks of AI adoption?" | Uncover missed perspectives |

---

## Features

### F1: Multi-Agent Discussion System

**Description:** Orchestrate 3-10 LLM agents from diverse providers with specialized roles.

**Goals:**
- Support 7+ providers (OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi, Llama)
- Role specialization (Analyst, Critic, Researcher, Synthesizer)
- User-configurable agents, roles, LLMs
- Independent analysis phase (prevent groupthink)

**Non-Goals:**
- Custom LLM fine-tuning
- Agent personas with cross-discussion memory

**Acceptance Tests:**
```gherkin
GIVEN user starts discussion with defaults
WHEN system initializes agents
THEN 5 agents created (2 Analysts, 1 Critic, 1 Researcher, 1 Synthesizer)
AND agents use 3+ different providers
AND agents have independent context in Phase 1

GIVEN user configures 7 custom agents
WHEN user selects specific LLMs
THEN system creates exactly 7 agents with user providers
AND validates API keys available
AND warns if all agents use same provider

GIVEN agent fails initialization
WHEN system detects failure
THEN retry 3× exponential backoff
AND fallback to alternative provider
AND notify user of substitution
```

---

### F2: Socratic Method Framework

**Description:** Structured Socratic methodology with probing questions, assumption challenging, evidence demands.

**Goals:**
- IntelliChain question reformulation
- CONSENSAGENT sycophancy mitigation
- Assumption identification/challenging
- Evidence citations required
- Position updates when persuaded

**Non-Goals:**
- User-agent Socratic dialogue (one-way: user poses question once)
- Automatic topic decomposition

**Acceptance Tests:**
```gherkin
GIVEN debate round with multiple contributions
WHEN agent responds to another agent
THEN response includes 1+ probing question
AND challenges 1+ assumption
AND provides evidence citations for claims

GIVEN agent's initial position (Round 1)
WHEN agent encounters stronger evidence (Round 3)
THEN agent acknowledges new evidence
AND updates position with reasoning
AND quantifies confidence (0-1)

GIVEN 80% agents agree initially
WHEN discussion begins
THEN 1+ devil's advocate agent challenges consensus
AND CONSENSAGENT prevents premature agreement
AND judges flag if consensus appears <2 rounds
```

---

### F3: Tool Integration Ecosystem

**Description:** Equip agents with external tools for real-time data, analysis, verification.

**Goals:**
- Perplexity Sonar Pro (200K context, 1200 tok/s)
- Alpha Vantage (stock data)
- Code sandbox (Python: pandas, numpy, viz)
- Wolfram Alpha (math/science)
- Model Context Protocol (MCP)
- "Explain before calling" pattern

**Non-Goals:**
- Custom user-defined tools
- Browser automation
- Write operations on external systems
- Image generation

**Tool Inventory:**

| Tool | Provider | Purpose | Rate Limit |
|------|----------|---------|------------|
| Perplexity Sonar Pro | Perplexity | Web search, citations | 100/hour |
| Alpha Vantage | Alpha Vantage | Stock data, fundamentals | 5/min |
| Code Sandbox | E2B/Modal | Python execution | 10/discussion |
| Wolfram Alpha | Wolfram | Math, science queries | 100/day |

**Acceptance Tests:**
```gherkin
GIVEN agent analyzing stock question
WHEN agent decides to fetch data
THEN agent explains reasoning
AND specifies parameters (ticker, date range)
AND system validates against schema
AND tool executes with 30s timeout
AND agent receives structured result + citations

GIVEN tool call fails (timeout)
WHEN system detects failure
THEN retry 2× exponential backoff
AND fallback to alternative tool if available
AND agent acknowledges failure
AND continues without data (graceful degradation)

GIVEN agent makes 10 tool calls
WHEN system detects excessive usage
THEN allow only first 5 calls
AND warn agent about budget
AND log event
```

---

### F4: Ensemble Judge Panel (CARE Aggregation)

**Description:** 3-5 judge LLMs evaluate using Correlation-Aware Ranking Ensemble (NeurIPS 2025).

**Goals:**
- 3-5 judges from diverse providers
- CARE aggregation (10-25% better than majority vote)
- 5 evaluation dimensions: factual accuracy, logical coherence, novel insights, engagement, consensus progress
- Structured feedback after each round
- Identify agreed vs. debated points
- Calculate consensus level (0-1)

**Non-Goals:**
- Single judge
- User-selectable judges
- Judge participation in debate
- Real-time judge feedback (only post-round)

**Judge Evaluation Schema:**
```json
{
  "round": 3,
  "consensus_level": 0.75,
  "agreed_points": ["Point A", "Point B"],
  "debated_points": [
    {"topic": "Point C", "positions": {"view_x": {...}, "view_y": {...}}}
  ],
  "quality_scores": {
    "Agent1": {"factual": 9, "logical": 8, "novel": 7, "engagement": 8, "consensus": 6}
  },
  "next_steps": ["Focus on Point C", "Request evidence for claim X"]
}
```

**Acceptance Tests:**
```gherkin
GIVEN completed round with 5 contributions
WHEN judge panel evaluates
THEN 3-5 judges independently score each contribution
AND judges evaluate across 5 dimensions
AND CARE aggregation computes final scores
AND system identifies agreed points (>80% judge agreement)
AND system identifies debated points (<80%)
AND consensus level calculated (weighted avg)

GIVEN judge panel with historical data
WHEN CARE aggregation applied
THEN algorithm models judge correlations
AND systematic biases weighted down
AND accuracy >10% better than majority vote (MAE)

GIVEN consensus level = 0.85
WHEN system checks termination
THEN mark discussion "consensus reached"
AND trigger final verdict generation
AND present results with confidence scores
```

---

### F5: Discussion Workspace & Orchestration

**Description:** Manage discussion lifecycle with phases, state tracking, termination conditions.

**Goals:**
- 4 phases: Independent Analysis, Opening Arguments, Iterative Debate, Convergence
- Configurable rounds (2-10, default 5)
- State tracking, history, evidence repository
- Smart context management (truncation, summarization)
- Multiple termination: consensus, max rounds, stable state, user override

**Non-Goals:**
- Infinite discussions
- Discussion branching
- Concurrent user interactions mid-discussion
- Workspace sharing

**Phases:**

| Phase | Description | Termination |
|-------|-------------|-------------|
| **1. Independent Analysis** | Agents work alone, no visibility | All agents complete |
| **2. Opening Arguments** | Agents present positions, read others | All agents complete |
| **3. Iterative Debate** | Respond, challenge, update positions | Consensus or max rounds |
| **4. Convergence** | Final synthesis, verdict generation | Complete |

**Acceptance Tests:**
```gherkin
GIVEN user starts discussion
WHEN system initializes workspace
THEN workspace created with unique ID
AND phase = "Independent Analysis"
AND evidence repository initialized
AND token budget = 50K total
AND max rounds = 5 (default or user-configured)

GIVEN phase "Iterative Debate" (Round 3)
WHEN all agents complete contributions
THEN judge panel evaluates
AND check termination conditions
AND if consensus ≥0.80: transition to "Convergence"
AND if consensus <0.80 and round <max: continue debate
AND if round ≥max: force termination

GIVEN consensus = 0.85 (Round 4)
WHEN system detects consensus
THEN phase = "Completed"
AND generate final verdict (AI summary)
AND persist workspace to database
AND present debrief to user

GIVEN context >150K tokens
WHEN preparing next round
THEN summarize older rounds
AND keep recent 2 rounds in full
AND store full history separately
```

---

### F6: User Interface & Experience

**Description:** Web app with configuration, real-time tracking, comprehensive results.

**Goals:**
- Simple mode (one-click, defaults)
- Advanced mode (configure agents, tools, style)
- Real-time streaming (SSE)
- Discussion templates (Investment, Research, Geopolitical, Tech)
- Export (PDF, Markdown, JSON)

**Non-Goals:**
- Mobile native apps
- Discussion replay/editing
- Multi-user collaboration
- In-discussion user participation

**UI Flow:**
```
Home → (Optional) Config Modal → Progress Page (SSE) → Results Page
```

**Acceptance Tests:**
```gherkin
GIVEN user on home page
WHEN user enters question and clicks "Start"
THEN discussion starts with defaults (5 agents, 5 rounds)
AND redirect to progress page
AND progress bar shows "Round 0/5"
AND contributions stream via SSE

GIVEN user clicks "Advanced Config"
WHEN user adjusts (7 agents, 10 rounds, specific LLMs)
AND clicks "Start"
THEN discussion starts with custom config
AND system validates LLM providers available
AND warns if expensive (>10K tokens)

GIVEN discussion in progress (Round 2/5)
WHEN user views page
THEN progress bar "Round 2/5 • Consensus: 35%"
AND completed contributions visible (expandable)
AND active agent shows "Analyzing..." spinner
AND evidence sidebar shows citations

GIVEN completed discussion
WHEN user views results
THEN executive summary (2-3 paragraphs)
AND key insights (3-5 bullets)
AND consensus breakdown (agreed vs. debated)
AND confidence scores
AND full transcript (expandable)
AND export buttons (PDF, Markdown, JSON)
```

---

### F7: Parlant Framework Integration

**Description:** Integrate Parlant for agent control, guidelines, tool orchestration.

**Goals:**
- Behavioral guidelines per role
- Journey templates for phases
- Centralized tool orchestration
- Canned responses (evidence requests, consensus proposals)
- Domain-specific terminology

**Non-Goals:**
- Custom Parlant modifications
- User-facing Parlant interface
- Real-time guideline editing

**Acceptance Tests:**
```gherkin
GIVEN agent with "rigorous analyst" guideline
WHEN agent generates contribution
THEN contribution includes evidence citations
AND uses formal analytical tone
AND challenges weak claims

GIVEN discussion in "Iterative Debate"
WHEN system uses Parlant journey
THEN journey defines: turn order, time limits, structure
AND agents follow constraints automatically
AND violations logged and corrected

GIVEN agent requests evidence from another
WHEN agent uses canned response template
THEN response follows standardized format
AND includes specific question
AND references original claim accurately
```

---

## Architecture

```
Frontend (Next.js 14+, React, TypeScript, SSE)
    ↓
API Layer (FastAPI, REST, Auth, Rate Limiting)
    ↓
Orchestration (DiscussionManager, PhaseController, ConsensusTracker, Parlant)
    ↓
Agent Runtime (AgentPool, JudgePanel, ToolManager)
    ↓
LLM Abstraction (LiteLLM: OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi)
    ↓
External Services (Perplexity, Alpha Vantage, Code Sandbox, Wolfram)

Data: PostgreSQL + Redis + Pinecone/Weaviate + S3
```

**Stack:**
- Backend: Python 3.11+, FastAPI 0.104+, LangGraph 0.2+, LiteLLM 1.40+
- Frontend: TypeScript 5.3+, Next.js 14.2+, React 18.2+, shadcn/ui
- Data: PostgreSQL 15+, Redis 7.2+, Pinecone/Weaviate
- Infra: Docker 24+, Kubernetes 1.28+, Terraform 1.6+

---

## Constraints

### Technical
- LLM latency: 3-10s/contribution (unavoidable)
- Cost: $0.50-$2.00/discussion (require token budgets)
- Rate limits: All providers limited (need queues, retries)
- Context windows: 8K-200K tokens (limits depth)
- Tool reliability: External APIs may fail (require fallbacks)

### Business
- Budget: $50k dev + $15k/month infra (beta)
- Timeline: 20 weeks (non-negotiable)
- Team: 4-6 engineers + PM + designer (max 7)
- API costs: <$15k/month in beta

### Legal
- LLM provider ToS compliance
- GDPR/CCPA compliance
- Content moderation
- AI-generated content disclaimer

### User
- Expertise: Users must understand complex topics (not novice-friendly)
- Time: Discussions take 5-15 min (not instant)
- Cost: Premium feature, requires paid tier for frequent use

---

## Security & Privacy

### Security
- ✅ Secrets in AWS Secrets Manager
- ✅ Input sanitization (prompt injection prevention)
- ✅ Rate limiting: 100 req/min per user
- ✅ HTTPS only (TLS 1.3)
- ✅ JWT auth (1-hour expiry)
- ✅ SQL injection prevention (parameterized queries)
- ✅ Dependency scanning (Dependabot, Snyk)

### Privacy
- ✅ GDPR compliant (EU)
- ✅ CCPA compliant (California)
- ✅ Data retention: 90 days (configurable)
- ✅ User data export available
- ✅ Right to deletion
- ✅ Encrypt PII: AES-256 (rest), TLS 1.3 (transit)
- ✅ Anonymize logs (no PII)
- ✅ Disclose LLM provider data sharing

---

## Release Acceptance Criteria

### Functional
- ✅ End-to-end discussion with 5 agents
- ✅ 7 LLM providers integrated
- ✅ 4 core tools functional
- ✅ Judge panel reaches consensus (>80% on test cases)
- ✅ UI functional (desktop: Chrome, Safari, Firefox)
- ✅ Discussion <10 min (p95)

### Quality
- ✅ Unit test coverage: >80%
- ✅ Integration test coverage: >70%
- ✅ 10 E2E tests passing
- ✅ No P0/P1 bugs
- ✅ Code review approval on all PRs
- ✅ Security audit passed

### Performance
- ✅ API response: <200ms (p95, simple queries)
- ✅ Discussion round: <90s (p95)
- ✅ Total discussion: <10 min (p95)
- ✅ Lighthouse: >90
- ✅ FCP: <1.5s

### User Acceptance
- ✅ 50+ beta users onboarded
- ✅ 100+ discussions completed
- ✅ User preference: >80%
- ✅ NPS: >40
- ✅ No critical user-reported bugs

---

## Research Integration (2024-2025)

| Method | Source | Implementation | Impact |
|--------|--------|----------------|--------|
| **IntelliChain** | arxiv.org/abs/2502.00010 | Knowledge graph, CoT dialogue | Question reformulation, context enhancement |
| **CONSENSAGENT** | people.cs.vt.edu/naren/papers/CONSENSAGENT.pdf | Two-phase protocol, sycophancy mitigation | Prevents conformity bias |
| **CARE Aggregation** | NeurIPS 2025 | Correlation-aware judge ensemble | 10-25% improvement over majority vote |
| **M-MAD** | arxiv.org/abs/2412.20127 | Multidimensional debate | Dimension-specific assignments |
| **Multi-Agent Debate** | arxiv.org/abs/2305.14325 | Iterative debate, position updating | Foundation for factuality improvement |

---

## Dependencies

### Required (MVP)
- [ ] OpenAI API (GPT-4, GPT-4 Turbo, o1)
- [ ] Anthropic API (Claude Sonnet, Opus)
- [ ] Perplexity API (Sonar Pro)
- [ ] Alpha Vantage API
- [ ] Wolfram Alpha API
- [ ] E2B or Modal (code sandbox)

### Optional (Phase 2)
- [ ] Google AI (Gemini)
- [ ] DeepSeek API (V3, Reasoner)
- [ ] Moonshot AI (Kimi K2)
- [ ] Brave Search (fallback)
- [ ] Yahoo Finance (fallback)

---

## Feature Prioritization

| Priority | Features | Phase |
|----------|----------|-------|
| **Must Have** | Multi-agent (3+), Basic tools (Perplexity, Alpha Vantage), Orchestration (4 phases), Simple UI | MVP (Week 8) |
| **Should Have** | Socratic framework, Judge panel + CARE, Parlant, 5+ LLMs | Phase 2 (Week 12) |
| **Could Have** | Templates, Advanced UI, 7+ LLMs, More tools | Phase 3 (Week 16) |
| **Won't Have** | Mobile apps, Real-time collab, Custom LLM training, Non-English | Out of scope |

---

**Version:** 1.0 | **Updated:** 2025-11-12
