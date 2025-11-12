# Product Requirements Document
## Socratic LLM Discussion Forum

**Version:** 1.0
**Last Updated:** 2025-11-12
**Status:** Approved
**Target Release:** Week 20 (Beta Launch)

---

## Product Overview

**Problem:** Single-LLM responses lack rigor, multiple perspectives, and critical analysis. Users need evidence-based answers that challenge assumptions and explore contrarian views.

**Solution:** Multi-agent AI platform where diverse LLMs (OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi) engage in structured Socratic debates, judged by ensemble panel, producing consensus-driven insights backed by real-time data.

**Value Proposition:** Most rigorous AI discussion platform that challenges status quo through multi-perspective, evidence-based debate supervised by advanced judging mechanisms.

---

## Goals

### Primary Goals
1. **Multi-perspective Analysis:** Enable 3-10 LLM agents to debate from diverse viewpoints
2. **Evidence-Based Reasoning:** Ground all arguments in real-time data (web search, financial data, analysis tools)
3. **Consensus Quality:** Reach >80% consensus on >70% of discussions through advanced judging
4. **Challenge Mainstream:** Push beyond conventional thinking with critical, contrarian analysis
5. **Transparency:** Full visibility into reasoning process and evidence

### Success Metrics
- **User Preference:** >80% prefer multi-agent vs. single-LLM responses
- **Factual Accuracy:** >90% of factual claims verified as correct
- **Consensus Rate:** >70% of discussions reach >80% agreement
- **Time to Completion:** <10 minutes per discussion (p95)
- **Tool Usage:** >60% of discussions successfully use external tools
- **NPS Score:** >50 at beta launch

---

## Non-Goals

### Explicitly Out of Scope
- ❌ Mobile native apps (web-first)
- ❌ Real-time multi-user collaboration
- ❌ Custom LLM fine-tuning or training
- ❌ Video/audio inputs or outputs
- ❌ Social features (likes, sharing, comments)
- ❌ Non-English language support (MVP is English-only)
- ❌ On-premise deployments
- ❌ Browser extensions or desktop apps
- ❌ API for external developers (post-MVP)
- ❌ Integration with Slack/Teams/CRMs (post-MVP)

---

## Target Users

### Primary Personas

**1. Strategic Decision Makers**
- Role: C-suite executives, investment analysts, policy makers
- Need: Deep multi-perspective analysis for high-stakes decisions
- Example: "Which AI companies will dominate in 2026?"
- Success: Makes better-informed decisions with confidence scores

**2. Researchers & Academics**
- Role: Scientists, scholars, PhD candidates
- Need: Literature synthesis, hypothesis exploration, critical peer review
- Example: "What are the most promising Alzheimer's treatments?"
- Success: Comprehensive evidence-based analysis saving days of research

**3. Critical Thinkers & Contrarians**
- Role: Independent analysts, investigative journalists, thought leaders
- Need: Challenge mainstream narratives, explore unconventional angles
- Example: "What are the hidden risks of widespread AI adoption?"
- Success: Uncovers perspectives missed by mainstream analysis

---

## Core Features

### Feature 1: Multi-Agent Discussion System

#### Description
Orchestrate 3-10 LLM agents from diverse providers in structured debates with distinct roles.

#### Goals
- Support 7+ LLM providers (OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi, Llama)
- Enable role specialization (Analyst, Critic, Researcher, Synthesizer)
- Allow user configuration of agent count, roles, and LLM assignments
- Execute independent analysis phase (prevent groupthink)

#### Non-Goals
- Custom LLM fine-tuning
- User-trained agents
- Agent personas with memory across discussions

#### User Stories
- As a user, I want to configure 5 agents with different LLMs so I get diverse perspectives
- As a user, I want agents to have specialized roles so analysis is comprehensive
- As a system, I need agents to work independently first to prevent conformity bias

#### Acceptance Tests
```gherkin
Given a user starts a discussion with default settings
When the system initializes agents
Then 5 agents are created with roles: 2 Analysts, 1 Critic, 1 Researcher, 1 Synthesizer
And agents use diverse LLM providers (at least 3 different providers)
And each agent has independent context (cannot see others' work in Phase 1)

Given a user configures custom agent setup
When user selects 7 agents with specific LLM assignments
Then system creates exactly 7 agents with user-specified providers
And validates that provider API keys are available
And warns user if all agents use same provider

Given an agent fails initialization (API error)
When the system detects the failure
Then system retries with exponential backoff (3 attempts)
And falls back to alternative LLM provider if retry fails
And notifies user of provider substitution
```

#### Technical Details
- Use LiteLLM for unified LLM interface
- Implement AgentPool class managing agent lifecycle
- Support async/parallel agent execution
- Token budget: 2,000 tokens per contribution

---

### Feature 2: Socratic Method Framework

#### Description
Implement structured Socratic methodology where agents pose probing questions, challenge assumptions, and demand evidence.

#### Goals
- Integrate IntelliChain framework (2025) for question reformulation
- Implement CONSENSAGENT sycophancy mitigation
- Enable assumption identification and challenging
- Require evidence citations for all factual claims
- Support position updates when agents are persuaded

#### Non-Goals
- Natural language understanding of user's intent (structured topics only)
- Automatic topic decomposition
- Multi-turn user-agent Socratic dialogue (user poses question once)

#### User Stories
- As an agent, I need to identify assumptions in other agents' arguments to challenge them
- As an agent, I want to pose clarifying questions to understand opposing viewpoints
- As a user, I want to see agents update their positions when presented with better evidence
- As the system, I need to prevent agents from agreeing just to reach consensus (sycophancy)

#### Acceptance Tests
```gherkin
Given a debate round with multiple agent contributions
When an agent responds to another agent's argument
Then the response includes at least one probing question
And challenges at least one assumption in the original argument
And provides evidence citations for counter-claims

Given an agent's initial position in Round 1
When agent encounters stronger evidence in Round 3
Then agent explicitly acknowledges the new evidence
And updates position with reasoning for change
And quantifies confidence level (0-1 scale)

Given agents discussing a controversial topic
When 80% of agents initially agree on a position
Then at least one "devil's advocate" agent challenges the consensus
And CONSENSAGENT mitigation prevents premature agreement
And judges flag if consensus appears suspiciously fast (<2 rounds)
```

#### Technical Details
- Prompt engineering: Socratic templates with question types
- Knowledge graph integration (Pinecone/Weaviate) for context
- Confidence scoring per claim (0-1)
- Assumption detection via structured prompts

---

### Feature 3: Tool Integration Ecosystem

#### Description
Equip agents with access to external tools for real-time data, analysis, and verification.

#### Goals
- Integrate Perplexity Sonar Pro (web search, 200K context, 1200 tokens/s)
- Support Alpha Vantage (stock data, fundamentals)
- Enable code execution sandbox (Python with pandas, numpy, visualization)
- Add Wolfram Alpha (mathematical computations)
- Implement Model Context Protocol (MCP) for standardized tool interface
- Enforce "explain before calling" pattern

#### Non-Goals
- Custom user-defined tools (pre-defined only)
- Browser automation tools
- Tools that modify external systems (read-only)
- Image generation tools

#### User Stories
- As an agent, I want to search the web for recent news to ground my arguments
- As an agent, I need to fetch stock data to analyze market trends
- As an agent, I want to run statistical analysis on data to support claims
- As the system, I need to validate tool inputs to prevent abuse

#### Acceptance Tests
```gherkin
Given an agent analyzing stock market question
When agent decides to fetch financial data
Then agent explains reasoning for tool call
And specifies parameters (ticker symbol, date range)
And system validates parameters against schema
And tool executes with 30s timeout
And agent receives structured result with citations

Given a tool call fails (API timeout)
When system detects the failure
Then system retries with exponential backoff (max 2 retries)
And falls back to alternative tool if available
And agent acknowledges tool failure in contribution
And continues analysis without the data (graceful degradation)

Given an agent makes 10 tool calls in one contribution
When system detects excessive tool usage
Then system allows only first 5 tool calls
And warns agent about tool budget limits
And logs event for usage analysis
```

#### Technical Details
- Tool registry with JSON schemas (MCP standard)
- Rate limiting per tool (prevent abuse)
- Tool result caching (Redis, 15 min TTL)
- Security: input sanitization, output validation

**Tool Inventory:**
| Tool | Provider | Purpose | Rate Limit |
|------|----------|---------|------------|
| Perplexity Sonar Pro | Perplexity | Web search | 100/hour |
| Alpha Vantage | Alpha Vantage | Stock data | 5/min |
| Code Sandbox | E2B/Modal | Python execution | 10/discussion |
| Wolfram Alpha | Wolfram | Math/science | 100/day |

---

### Feature 4: Ensemble Judge Panel with CARE Aggregation

#### Description
3-5 judge LLMs from diverse providers evaluate debate progress using Correlation-Aware Ranking Ensemble (NeurIPS 2025).

#### Goals
- Support 3-5 judge agents from different LLM providers
- Implement CARE aggregation (10-25% better than majority vote)
- Evaluate 5 dimensions: factual accuracy, logical coherence, novel insights, engagement quality, consensus progress
- Provide structured feedback after each round
- Identify agreed points vs. debated points
- Calculate consensus level (0-1 scale)

#### Non-Goals
- Single judge (must be ensemble)
- User-selectable judges (system-assigned for diversity)
- Judge participation in debate (judges only evaluate)
- Real-time judge feedback (only after complete rounds)

#### User Stories
- As the judge panel, I need to evaluate agent contributions objectively across multiple dimensions
- As the system, I want to aggregate judge opinions while mitigating systematic biases
- As a user, I want to see which points have consensus and which are still debated
- As the system, I need to detect when consensus is reached to terminate discussion

#### Acceptance Tests
```gherkin
Given a completed discussion round with 5 agent contributions
When the judge panel evaluates the round
Then each of 3-5 judges independently scores each contribution
And judges evaluate across 5 dimensions (factual, logical, novel, engagement, consensus)
And CARE aggregation computes final scores accounting for judge correlations
And system identifies agreed points (>80% judge agreement)
And system identifies debated points (<80% judge agreement)
And consensus level is calculated (weighted average)

Given judge panel with historical bias data
When CARE aggregation is applied
Then algorithm models judge correlations from past evaluations
And systematic biases (verbosity, position) are weighted down
And resulting consensus is more accurate than simple majority vote
And improvement over majority vote is >10% (MAE metric)

Given consensus level reaches 0.85 (85%)
When system checks termination conditions
Then system marks discussion as "consensus reached"
And triggers final verdict generation
And presents results to user with confidence scores
```

#### Technical Details
- Judge LLM diversity: GPT-4 Turbo, Claude Opus, Gemini Pro, DeepSeek, o1
- CARE algorithm implementation from NeurIPS 2025 paper
- Historical judge data stored (correlation matrix)
- Structured JSON output from judges

**Judge Evaluation Schema:**
```json
{
  "round": 3,
  "consensus_level": 0.75,
  "agreed_points": ["Point A", "Point B"],
  "debated_points": [
    {
      "topic": "Point C interpretation",
      "positions": {
        "view_x": {"agents": ["Agent1", "Agent2"], "evidence": "..."},
        "view_y": {"agents": ["Agent3"], "evidence": "..."}
      }
    }
  ],
  "quality_scores": {
    "Agent1": {"factual": 9, "logical": 8, "novel": 7, "engagement": 8, "consensus": 6}
  },
  "next_steps": ["Focus debate on Point C", "Request additional evidence for claim X"]
}
```

---

### Feature 5: Discussion Workspace & Orchestration

#### Description
Manage complete discussion lifecycle with workspace tracking, phase transitions, and termination conditions.

#### Goals
- Support 4 discussion phases: Independent Analysis, Opening Arguments, Iterative Debate, Convergence
- Enable configurable debate rounds (2-10, default 5)
- Track discussion state, history, evidence repository
- Implement smart context management (truncation, summarization)
- Support multiple termination conditions (consensus, max rounds, stable state, user override)

#### Non-Goals
- Infinite discussions (must have max rounds)
- Discussion branching (single linear path)
- Concurrent user interactions mid-discussion
- Workspace sharing between users

#### User Stories
- As a user, I want to track discussion progress in real-time to understand how far along we are
- As the system, I need to transition between phases based on completion criteria
- As the system, I want to terminate discussions when consensus is reached to save cost
- As a user, I want to see the full evidence trail to understand the reasoning

#### Acceptance Tests
```gherkin
Given a user starts a discussion
When the system initializes workspace
Then workspace is created with unique ID
And phase is set to "Independent Analysis"
And evidence repository is initialized (empty)
And token budget is set (50,000 total)
And max rounds is set (default 5, or user-configured)

Given discussion is in "Iterative Debate" phase (Round 3)
When all agents complete their contributions
Then judge panel evaluates the round
And system checks termination conditions
And if consensus_level >= 0.80: transition to "Convergence"
And if consensus_level < 0.80 and round < max_rounds: continue debate
And if round >= max_rounds: force termination

Given discussion reaches consensus (0.85) in Round 4
When system detects consensus
Then discussion phase transitions to "Completed"
And final verdict is generated (AI summary)
And user receives comprehensive debrief
And workspace is persisted to database

Given discussion context exceeds 150K tokens
When system prepares next round
Then system summarizes older rounds (compression)
And keeps recent 2 rounds in full detail
And stores full history separately for user review
```

#### Technical Details
- PostgreSQL for discussion persistence
- Redis for active workspace state (fast access)
- Context window management: summarization for old rounds
- Phase state machine with clear transitions

**Workspace Data Model:**
```python
class Discussion:
    id: UUID
    topic: str
    status: Enum[RUNNING, COMPLETED, TERMINATED]
    phase: Enum[INDEPENDENT, OPENING, DEBATE, CONVERGENCE]
    current_round: int
    max_rounds: int
    token_budget_used: int
    token_budget_total: int
    consensus_level: float
    created_at: datetime
    completed_at: Optional[datetime]

class Contribution:
    id: UUID
    discussion_id: UUID
    agent_id: str
    round_num: int
    phase: str
    content: str
    tool_calls: List[ToolCall]
    citations: List[Citation]
    confidence: float
    tokens_used: int
```

---

### Feature 6: User Interface & Experience

#### Description
Web application with discussion configuration, real-time progress tracking, and comprehensive result presentation.

#### Goals
- Simple mode (one-click start with defaults)
- Advanced mode (configure agents, tools, debate style)
- Real-time streaming updates via SSE
- Discussion templates (Investment, Research, Geopolitical, Technology)
- Result export (PDF, Markdown, JSON)

#### Non-Goals
- Mobile native apps
- Discussion replay/editing
- Collaborative multi-user discussions
- In-discussion user participation (user observes only)

#### User Stories
- As a user, I want to start a discussion with one click using defaults to get quick results
- As a power user, I want to configure agent count and LLM providers to customize analysis
- As a user, I want to see real-time updates as agents contribute to understand progress
- As a user, I want to export discussion results to share with my team

#### Acceptance Tests
```gherkin
Given a user on the home page
When user enters a question and clicks "Start Discussion"
Then discussion starts with default configuration (5 agents, 5 max rounds)
And user is redirected to discussion progress page
And progress bar shows "Round 0/5"
And agent contributions stream in real-time (SSE)

Given a user clicks "Advanced Configuration"
When user adjusts settings (7 agents, 10 max rounds, specific LLMs)
And user clicks "Start Discussion"
Then discussion starts with custom configuration
And system validates that selected LLM providers are available
And warns user if configuration will be expensive (>10k tokens estimated)

Given a discussion in progress (Round 2/5)
When user views the discussion page
Then progress bar shows "Round 2/5 • Consensus: 35%"
And all completed contributions are visible (expandable)
And currently active agent shows "Analyzing..." spinner
And evidence repository sidebar shows all citations

Given a completed discussion
When user views results page
Then user sees executive summary (2-3 paragraphs)
And key insights (3-5 bullet points)
And consensus breakdown (agreed vs. debated points)
And confidence scores for major claims
And full discussion transcript (expandable)
And export buttons (PDF, Markdown, JSON)
```

#### Technical Details
- Next.js 14+ with App Router
- React Server Components + Client Components
- Server-Sent Events for real-time updates
- shadcn/ui + Tailwind for UI
- Zustand for client state management

**UI Flow:**
```
Home Page
  ↓ (User enters question)
Configuration Modal (optional)
  ↓ (Start discussion)
Progress Page (real-time updates)
  → Agent contributions stream in
  → Judge feedback after each round
  → Consensus tracker updates
  ↓ (Discussion completes)
Results Page
  → Executive summary
  → Key insights
  → Evidence & citations
  → Export options
```

---

### Feature 7: Parlant Framework Integration

#### Description
Integrate Parlant framework for enhanced agent control, behavioral guidelines, and tool orchestration.

#### Goals
- Define behavioral guidelines for each agent role
- Create journey templates for discussion phases
- Centralize tool orchestration through Parlant
- Use canned responses for common patterns (evidence requests, consensus proposals)
- Manage domain-specific terminology

#### Non-Goals
- Custom Parlant modifications (use as-is)
- User-facing Parlant interface (backend only)
- Real-time guideline editing

#### User Stories
- As the system, I want consistent agent behavior across discussions using guidelines
- As a developer, I want to manage agent journeys declaratively to simplify orchestration
- As the system, I want standardized responses for common scenarios to reduce variance

#### Acceptance Tests
```gherkin
Given an agent with "rigorous analyst" guideline
When agent generates a contribution
Then contribution includes evidence citations (guideline enforcement)
And uses formal analytical tone
And challenges weak claims aggressively

Given a discussion in "Iterative Debate" phase
When system uses Parlant journey
Then journey defines: agent turn order, time limits, response structure
And agents follow journey constraints automatically
And violations are logged and corrected

Given an agent needs to request evidence from another agent
When agent uses canned response template
Then response follows standardized format
And includes specific question format
And references the original claim accurately
```

#### Technical Details
- Parlant version: 3.0+
- Guidelines stored in YAML/JSON
- Journey definitions for each phase
- Canned response library (10-15 templates)

---

## Technical Architecture

### System Components

```
┌─────────────────────────────────┐
│   Frontend (Next.js 14+)        │
│   - React 18 + TypeScript       │
│   - SSE for real-time updates   │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   API Layer (FastAPI)           │
│   - REST endpoints              │
│   - SSE streaming               │
│   - Authentication              │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   Orchestration Layer           │
│   - DiscussionManager           │
│   - PhaseController             │
│   - ConsensusTracker            │
│   - Parlant Integration         │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   Agent Runtime Layer           │
│   - AgentPool (3-10 debaters)   │
│   - JudgePanel (3-5 judges)     │
│   - ToolManager (MCP)           │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   LLM Abstraction (LiteLLM)     │
│   - OpenAI, Claude, Perplexity  │
│   - Gemini, DeepSeek, Kimi      │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   External Services             │
│   - Perplexity Sonar Pro        │
│   - Alpha Vantage               │
│   - E2B/Modal (code sandbox)    │
│   - Wolfram Alpha               │
└─────────────────────────────────┘

Data Layer:
├── PostgreSQL (discussions, contributions, users)
├── Redis (workspace state, caching)
├── Pinecone/Weaviate (vector store for knowledge graph)
└── S3 (artifacts, exports, logs)
```

### Technology Stack

**Backend:**
- Python 3.11+, FastAPI 0.104+
- LangGraph 0.2+ or AutoGen 0.2+
- LiteLLM 1.40+, Parlant 3.0+
- PostgreSQL 15+, Redis 7.2+

**Frontend:**
- TypeScript 5.3+, Node.js 20 LTS
- Next.js 14.2+, React 18.2+
- shadcn/ui, Tailwind CSS 3.4+

**Infrastructure:**
- Docker 24+, Kubernetes 1.28+ or AWS ECS
- GitHub Actions (CI/CD)
- Terraform 1.6+ (IaC)
- Datadog or Prometheus + Grafana

---

## Constraints

### Technical Constraints
1. **LLM API Latency:** 3-10s per agent contribution (unavoidable)
2. **Cost:** $0.50-$2.00 per discussion (must implement token budgets)
3. **Rate Limits:** All providers have limits (need queue + retry logic)
4. **Context Windows:** Min 8K tokens (limits discussion depth)
5. **Tool Reliability:** External APIs may fail (require fallbacks)

### Business Constraints
1. **Budget:** $50k development + $15k/month infrastructure (beta)
2. **Timeline:** 20 weeks to beta (non-negotiable)
3. **Team Size:** 4-6 engineers + PM + designer (max 7 people)
4. **API Costs:** Must stay under $15k/month during beta

### Legal Constraints
1. **LLM Provider ToS:** Must comply with all terms of service
2. **GDPR/CCPA:** Data privacy compliance required
3. **Content Moderation:** Must filter harmful content
4. **Liability:** Disclaimer for AI-generated advice

### User Constraints
1. **Expertise:** Users must understand complex topics (not novice-friendly)
2. **Time:** Discussions take 5-15 minutes (not instant)
3. **Cost:** Premium feature, requires paid tier for frequent use

---

## Security & Privacy

### Security Requirements
- ✅ Secrets in AWS Secrets Manager (no hardcoded keys)
- ✅ Input sanitization (prevent prompt injection)
- ✅ Rate limiting: 100 requests/min per user
- ✅ HTTPS only (TLS 1.3)
- ✅ JWT authentication (1-hour expiry)
- ✅ SQL injection prevention (parameterized queries)
- ✅ Dependency scanning (Dependabot, Snyk)

### Privacy Requirements
- ✅ GDPR compliant (EU users)
- ✅ CCPA compliant (California users)
- ✅ Data retention: 90 days (configurable)
- ✅ User data export available
- ✅ Right to deletion ("forget me")
- ✅ Encrypt PII at rest (AES-256)
- ✅ Anonymize logs (no PII)
- ✅ Disclose LLM provider data sharing

---

## Success Criteria (Acceptance for Release)

### Functional Requirements
- ✅ Complete end-to-end discussion with 5 agents
- ✅ All 7 LLM providers integrated and working
- ✅ All 4 core tools functional (Perplexity, Alpha Vantage, Code Sandbox, Wolfram)
- ✅ Judge panel evaluates and reaches consensus (>80% on test cases)
- ✅ UI functional on desktop (Chrome, Safari, Firefox)
- ✅ Discussion completes in <10 minutes (p95)

### Quality Requirements
- ✅ Unit test coverage: >80%
- ✅ Integration test coverage: >70%
- ✅ 10 E2E tests passing (critical user flows)
- ✅ No P0/P1 bugs in backlog
- ✅ Code review approval on all PRs
- ✅ Security audit passed

### Performance Requirements
- ✅ API response time: <200ms (p95) for simple queries
- ✅ Discussion round completion: <90s (p95)
- ✅ Total discussion time: <10 min (p95)
- ✅ Lighthouse score: >90
- ✅ First Contentful Paint: <1.5s

### User Acceptance
- ✅ 50+ beta users onboarded
- ✅ 100+ discussions completed in beta
- ✅ User preference: >80% prefer multi-agent (survey)
- ✅ NPS score: >40
- ✅ No critical user-reported bugs

---

## Research Integration

### State-of-the-Art Methods (2024-2025)

1. **IntelliChain** (Jan 2025)
   - Source: arxiv.org/abs/2502.00010
   - Implementation: Knowledge graph integration, chain-of-thought dialogue optimization
   - Impact: Improved question reformulation and context enhancement

2. **CONSENSAGENT** (2025)
   - Source: people.cs.vt.edu/naren/papers/CONSENSAGENT.pdf
   - Implementation: Two-phase discussion protocol, sycophancy mitigation
   - Impact: Prevents conformity bias, improves consensus quality

3. **CARE Aggregation** (NeurIPS 2025)
   - Source: openreview.net/pdf/3c687...
   - Implementation: Correlation-aware judge ensemble with bias modeling
   - Impact: 10-25% improvement over majority voting (MAE metric)

4. **M-MAD** (Dec 2024)
   - Source: arxiv.org/abs/2412.20127
   - Implementation: Multidimensional multi-agent debate framework
   - Impact: Dimension-specific agent assignments, collaborative reasoning

5. **Multi-Agent Debate** (ICML 2023)
   - Source: arxiv.org/abs/2305.14325
   - Implementation: Foundation for iterative debate and position updating
   - Impact: Improved factuality and reasoning through agent discussion

---

## Dependencies

### External Services (Required)
- [ ] OpenAI API (GPT-4, GPT-4 Turbo, o1)
- [ ] Anthropic API (Claude Sonnet 3.5, Opus 3.5)
- [ ] Perplexity API (Sonar Pro)
- [ ] Alpha Vantage API
- [ ] Wolfram Alpha API
- [ ] E2B or Modal (code execution sandbox)

### External Services (Optional - Phase 2)
- [ ] Google AI (Gemini 2.0, Pro)
- [ ] DeepSeek API (V3, Reasoner)
- [ ] Moonshot AI (Kimi K2)
- [ ] Brave Search API (fallback)
- [ ] Yahoo Finance API (fallback)

### Infrastructure
- [ ] Cloud provider (AWS, GCP, or Azure)
- [ ] Domain registration
- [ ] SSL certificates
- [ ] Email service (SendGrid, Mailgun)
- [ ] Monitoring (Datadog or Prometheus)

---

## Open Questions

1. **Pricing Model:** Per-discussion, subscription, or token-based? (Decision by Week 4)
2. **Agent Personas:** Should agents have consistent personalities across discussions? (Decision by Week 6)
3. **User Intervention:** Allow mid-discussion user input or observation only? (Decision by Week 8)
4. **Multi-language:** When to add non-English support? (Post-MVP)
5. **API Access:** When to open API for developers? (Post-launch)

---

## Appendix: Feature Prioritization

### Must Have (MVP - Week 8)
- Multi-agent discussion (3+ agents)
- Basic tool integration (Perplexity, Alpha Vantage)
- Discussion orchestration (4 phases)
- Simple UI (start, view, results)

### Should Have (Phase 2 - Week 12)
- Socratic method framework
- Ensemble judge panel with CARE
- Parlant integration
- 5+ LLM providers

### Could Have (Phase 3 - Week 16)
- Discussion templates
- Advanced UI (configuration, export)
- 7+ LLM providers
- More tools (code sandbox, Wolfram)

### Won't Have (Out of Scope)
- Mobile apps
- Real-time collaboration
- Custom LLM training
- Non-English support

---

**Use with SpecKit:**
```bash
/specify docs/inputs/PRD.md
```
