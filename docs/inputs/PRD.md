# Product Requirements
**Use:** `/specify docs/inputs/PRD.md` | **Target:** Week 20

---

## Summary

**Problem:** Single-LLM lacks rigor, multiple perspectives, critical analysis
**Solution:** 7+ LLMs debate via Socratic Method, judged by ensemble panel
**Value:** Most rigorous AI platform challenging status quo

## Goals

| Goal | Target |
|------|--------|
| Multi-perspective | 3-10 agents configurable |
| Tool usage | >60% discussions |
| Consensus | >70% reach >80% agreement |


## Non-Goals

Mobile apps, real-time multi-user, custom LLM training, video/audio, social features, non-English (MVP), on-premise, browser extensions, developer API (MVP)

## Users

| Persona | Need | Success |
|---------|------|---------|
| Decision Makers (C-suite, analysts) | Multi-perspective analysis | Better decisions with confidence |
| Researchers (scientists, academics) | Literature synthesis, hypothesis test | Evidence-based analysis, days saved |
| Critical Thinkers (journalists) | Challenge mainstream | Uncover missed perspectives |

---

## Features

### F1: Multi-Agent System

**Goal:** 3-10 LLM agents from 7+ providers (OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi, Llama) with roles (Analyst, Critic, Researcher, Synthesizer)

**Tests:**
```gherkin
GIVEN user starts discussion
THEN 5 agents created with 3+ providers
AND independent context in Phase 1

GIVEN agent fails initialization
THEN retry one more time, fallback to alternative provider
```

### F2: Socratic Method

**Goal:** IntelliChain question reformulation, CONSENSAGENT sycophancy mitigation, assumption challenging, evidence citations, position updates

**Tests:**
```gherkin
GIVEN debate round
WHEN agent responds
THEN includes 1+ question, challenges 1+ assumption, provides citations

GIVEN agent encounters stronger evidence
THEN updates position with reasoning, quantifies confidence
```

### F3: Tool Integration

**Goal:** Perplexity Sonar Pro (200K context), Alpha Vantage (stocks), Code Sandbox (Python), MCP protocol



**Tests:**
```gherkin
GIVEN agent analyzing stocks
WHEN decides to fetch data
THEN explains reasoning, validates params, 30s timeout, receives result

GIVEN tool fails
THEN retry 2×, fallback, continue without data
```

### F4: Judge Panel (CARE)

**Goal:** 1-5 judge LLMs, CARE aggregation (10-25% better than majority vote), 5-dimension eval (factual, logical, novel, engagement, consensus)

**Schema:**
```json
{
  "consensus_level": 0.75,
  "agreed_points": ["A", "B"],
  "debated_points": [{"topic": "C", "positions": {...}}],
  "quality_scores": {"Agent1": {"factual": 9, "logical": 8, ...}}
}
```

**Tests:**
```gherkin
GIVEN completed round
THEN judges score independently across 5 dimensions
AND CARE aggregation >10% better than majority vote

GIVEN consensus = 0.85 (can be user defined)
THEN mark "consensus reached", generate verdict
```

### F5: Discussion Orchestration

**Goal:** 4 phases (Independent, Opening, Debate, Convergence), 2-10 rounds, termination (consensus/max rounds/stable/user)

| Phase | Termination |
|-------|-------------|
| Independent Analysis | All agents complete |
| Opening Arguments | All agents complete |
| Iterative Debate | Consensus or max rounds |
| Convergence | Complete |

**Tests:**
```gherkin
GIVEN user starts discussion
THEN workspace created, phase="Independent", budget=50K tokens (can be user defined), rounds=5(can be user defined)

GIVEN Round 3
WHEN all agents complete
THEN judge evaluates, check termination
AND if consensus ≥0.80: transition to Convergence

GIVEN context >150K tokens
THEN summarize old rounds, keep recent 2 full, all agents have visibility to the previous rounds for them have actively engaging debates against each others.
```

### F6: User Interface

**Goal:** Simple (one-click) + Advanced (config), real-time SSE, templates (Investment/Research/Geopolitical/Tech), export (PDF/MD/JSON)

**Tests:**
```gherkin
GIVEN user enters question
THEN discussion starts (5 agents, 5 rounds), contributions stream via SSE

GIVEN discussion completes
THEN exec summary, key insights, consensus breakdown, confidence scores, export
```

### F7: Parlant Integration

**Goal:** Behavioral guidelines per role, journey templates, tool orchestration, canned responses

**Tests:**
```gherkin
GIVEN agent with "rigorous analyst" guideline
THEN includes citations, formal tone, challenges weak claims

GIVEN discussion in Debate phase
THEN Parlant journey defines: turn order, time limits, structure
```

---

## Architecture --- 
only for local deployment. would be helpful to have a GUI interface


## Security
only for local deployment. all api keys to be saved in .env and to be loaded when running



## Research (2024-2025)

| Method | Impact |
|--------|--------|
| IntelliChain | Question reformulation, context enhancement |
| CONSENSAGENT | Prevents conformity bias |
| CARE Aggregation | 10-25% better than majority vote |
| M-MAD | Dimension-specific assignments |

## Dependencies

**MVP:** OpenAI, Anthropic, Perplexity, Alpha Vantage, 
**Phase 2:** Gemini, DeepSeek, Kimi, Brave Search, Yahoo Finance, Wolfram, E2B/Modal

## Priority

| Priority | Features | Phase |
|----------|----------|-------|
| Must | Multi-agent (3+), Tools (Perplexity, Alpha Vantage), Orchestration, Simple UI, Socratic, Judges + CARE, | MVP |
| Should | Parlant, 5+ LLMs | Phase 2  |
| Could | Templates, Advanced UI, 7+ LLMs | Phase 3 |
| Won't | Mobile, Real-time collab, Custom training, Non-English | Out of scope |

---

**v1.0** | **2025-11-12**
