# The Socratic Method of Large Language Models 2

> Local-first multi-agent LLM debate + judging system producing concise, evidence-backed consensus.

[![Status](https://img.shields.io/badge/status-planning-blue.svg)](https://github.com)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## Overview

Multiple heterogeneous LLM agents (OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi, Llama) debate using a structured Socratic protocol. A judge panel applies CARE aggregation to score rounds and track convergence toward consensus. Tools (search, finance, sandbox) provide fresh evidence. Output: transparent reasoning + confidence.

### Key Differentiator

Structured multi-agent Socratic debate + correlation-aware judging (CARE) > single-model answer. Emphasis on challenge, evidence, mitigation of conformity.

---

## Example

**User Question:**
> "Which companies will benefit most from the release of the Kimi K2 model for the rest of 2025 and into 2026?"

**Flow:** Independent analyses → iterative Socratic rounds (questions + challenges + citations) → judge scoring + CARE aggregation → consensus verdict (confidence, dissent, evidence).

---

## Core Features

### Multi-Agent System
- 3–10 debate agents, roles: Analyst, Critic, Researcher, Synthesizer
- Providers: OpenAI, Claude, Perplexity, Gemini, DeepSeek, Kimi, Llama

### Tooling
- Search (Perplexity Sonar Pro)
- Finance (Alpha Vantage; later Yahoo Finance)
- Python sandbox (analysis + plots)
- Knowledge (Wolfram Alpha)
- Parlant framework (guidelines / journeys)

### Socratic Method
IntelliChain (question reformulation), CONSENSAGENT (conformity mitigation), assumption surfacing, confidence updates, citations every round.

### Judge Panel
3–5 judges (diverse providers) → score (factual, logical, novel, engagement, consensus); CARE aggregation >10% over majority.

### Workspace
Streaming updates; evidence repository; consensus progression; full transcript.

---

## Technical Architecture

```
┌─────────────────────────────────────┐
│       User Interface (Next.js)      │
│     Real-time Streaming Updates     │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│   Application Orchestration Layer   │
│  ┌────────────────────────────────┐ │
│  │  Parlant Framework Integration │ │
│  │   (Guidelines • Journeys •     │ │
│  │    Tool Orchestration)         │ │
│  └────────────────────────────────┘ │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│      Agent Runtime Layer            │
│  • Agent Pool (3-10 debaters)       │
│  • Judge Panel (3-5 judges)         │
│  • Tool Manager (MCP protocol)      │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│   LLM Provider Abstraction Layer    │
│      (LiteLLM unified interface)    │
│  OpenAI • Claude • Perplexity •     │
│  Gemini • DeepSeek • Kimi • Llama   │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│     External Tools & APIs           │
│  Search • Finance • Analysis •      │
│  Knowledge • Custom Tools           │
└─────────────────────────────────────┘
```

### Tech Stack

**Backend:** FastAPI, LiteLLM, Parlant, PostgreSQL, Redis, Vector DB, Docker.  
**Frontend:** Next.js (TypeScript), shadcn/ui, Tailwind, SSE streaming.  
**Local-first:** `.env` secrets; no external hosting required (MVP).

---

## Documentation

### Core Documents (in `docs/inputs/`)

- **[PROJECT_CONSTITUTION.md](docs/inputs/PROJECT_CONSTITUTION.md)** - Project Rules & Standards
  - Technology stack (pinned versions)
  - Code quality standards (formatting, linting, type checking)
  - Test coverage requirements (80% unit, 70% integration)
  - Git branch policy and protection rules
  - Security and privacy requirements
  - Documentation standards
  - Explicitly defined out-of-scope items
  - **Use with:** `/constitute docs/inputs/PROJECT_CONSTITUTION.md`

- **[PRD.md](docs/inputs/PRD.md)** - Product Requirements Document
  - Goals, non-goals, and success metrics
  - Target users and personas
  - 7 core features with acceptance tests
  - Technical architecture and constraints
  - State-of-the-art research integration
  - Stack pins and security notes
  - **Use with:** `/specify docs/inputs/PRD.md`

- **[WORKPLAN.md](docs/inputs/WORKPLAN.md)** - Implementation Workplan
  - 4 phases over 20 weeks
  - Sprint-by-sprint task breakdown
  - Milestones and decision points
  - Dependencies and critical path
  - Resource allocation and budget
  - Risk management matrix
  - **Use with:** `/plan docs/inputs/WORKPLAN.md`

### SpecKit Commands

```bash
# 1. Set up project constitution (rules and standards)
/constitute docs/inputs/PROJECT_CONSTITUTION.md

# 2. Load product requirements
/specify docs/inputs/PRD.md

# 3. Generate implementation plan
/plan docs/inputs/WORKPLAN.md
```

---

## Roadmap (Summary)
Phase 1 (W1-8): Agents, tools, orchestration, simple UI (<5 min run)  
Phase 2 (W9-12): Socratic engine, judges + CARE (>70% consensus)  
Phase 3 (W13-16): 7+ providers, perf (<60s first round), security  
Phase 4 (W17-20): Internal beta, polish, local release

---

## Research Basis (2024–2025)

1. **IntelliChain** (Jan 2025)
   - [arxiv.org/abs/2502.00010](https://arxiv.org/abs/2502.00010)
   - Framework for enhanced Socratic dialogue with knowledge graphs

2. **CONSENSAGENT** (2025)
   - Efficient consensus mechanisms with sycophancy mitigation
   - Phase-based discussion protocol

3. **CARE Aggregation** (NeurIPS 2025)
   - Correlation-Aware Ranking Ensemble for judge panels
   - 10-25% improvement over majority voting
   - Mitigates systematic biases

4. **M-MAD** (Dec 2024)
   - [arxiv.org/abs/2412.20127](https://arxiv.org/abs/2412.20127)
   - Multidimensional Multi-Agent Debate framework

5. **Multi-Agent Debate** (ICML 2023)
   - [arxiv.org/abs/2305.14325](https://arxiv.org/abs/2305.14325)
   - Foundation work on improving factuality through debate

---

## Differentiation
Single LLM: lacks challenge → we add structured cross-model critique.  
Perplexity: single search model → we aggregate diverse agents.  
Other multi-agent: we add Socratic rigor + CARE + evidence discipline.

---

## Getting Started (Planned)

```bash
# Clone repository
git clone https://github.com/yourusername/socratic-llm-forum.git
cd socratic-llm-forum

# Set up environment
cp .env.example .env
# Add your API keys for OpenAI, Anthropic, Perplexity, etc.

# Install dependencies
pip install -r requirements.txt  # Backend
npm install                       # Frontend

# Run development servers
docker-compose up                 # Start services
npm run dev                       # Start frontend
python -m uvicorn app.main:app --reload  # Start backend

# Access at http://localhost:3000
```

---

## API Keys Required

To run the full platform, you'll need API access to:

### Required (MVP)
- [OpenAI API](https://platform.openai.com/) - GPT-4, GPT-4 Turbo
- [Anthropic API](https://console.anthropic.com/) - Claude Sonnet, Opus
- [Perplexity API](https://www.perplexity.ai/api-platform) - Sonar Pro

### Optional (Extended)
- [Google AI](https://ai.google.dev/) - Gemini
- [DeepSeek](https://platform.deepseek.com/) - DeepSeek V3
- [Moonshot AI](https://platform.moonshot.cn/) - Kimi K2
- [Alpha Vantage](https://www.alphavantage.co/) - Financial data
- [Wolfram Alpha](https://products.wolframalpha.com/api/) - Knowledge
- [Brave Search](https://brave.com/search/api/) - Web search

---

## Example Use Cases

### Investment Analysis
> "Given the release of DeepSeek V3, which semiconductor companies will see the most impact on their stock prices?"

**Features Used:** Financial data APIs, real-time news search, market analysis tools, 5-7 debate rounds

### Scientific Research
> "What are the most promising approaches to treating Alzheimer's disease based on 2024-2025 research?"

**Features Used:** Academic search, multi-perspective medical analysis, evidence synthesis, citation tracking

### Geopolitical Analysis
> "How will the new AI regulations in the EU affect US tech companies' operations?"

**Features Used:** News aggregation, policy analysis, economic impact modeling, legal interpretation

### Technology Evaluation
> "Should our company adopt Kubernetes or stick with traditional VM deployments?"

**Features Used:** Technical documentation search, performance benchmarking, cost analysis, architectural debate

### Strategic Planning
> "What are the biggest risks and opportunities for renewable energy investments in 2026?"

**Features Used:** Market data, policy tracking, technology trends, risk assessment tools

---

## Success Metrics (Targets)

### Quality
- **Factual Accuracy:** >90% of claims verified as correct
- **Consensus Achievement:** >70% of discussions reach >80% agreement
- **User Preference:** >80% prefer multi-agent vs. single-LLM

### Performance
- **Time to First Round:** <60 seconds
- **Round Completion:** <90 seconds per round
- **Total Discussion:** <10 minutes typical

### Engagement
- **NPS Score:** >50
- **Discussion Depth:** >3 follow-up questions per session
- **Tool Usage:** >60% of discussions use external tools

---

## Contributing
Planning phase. Early helpful areas: tool adapters, judge evaluation metrics, prompt hardening, test harnesses.

---

## Influences & Related
Influences: Socratic method, ensemble learning, deliberative processes.  
Related: Parlant, LangGraph, AutoGen, LiteLLM.

---

<!-- Future roadmap (post local release) intentionally condensed. -->

---

## License

MIT License (to be finalized)

---

## Contact

- **Project Lead:** [Your Name]
- **Email:** [your.email@example.com]
- **Website:** [Coming Soon]

---

## Acknowledgments

This project builds on cutting-edge research from:
- Stanford University (SocraSynth)
- Princeton NLP Group (SocraticAI)
- Virginia Tech (CONSENSAGENT)
- NeurIPS community (CARE aggregation)
- And many other contributors to the field of multi-agent LLM systems

Special thanks to the open-source community for frameworks like Parlant, LangGraph, and LiteLLM that make this project possible.

---

**Status:** Planning
**Version:** 0.1.0
**Last Updated:** 2025-11-12

---

## Quick Links

- [📋 Product Requirements Document](docs/inputs/PRD.md)
- [🗓️ Implementation Workplan](docs/inputs/WORKPLAN.md)
- [⚙️ Project Constitution](docs/inputs/PROJECT_CONSTITUTION.md)
- [🔬 Research Papers](#state-of-the-art-research)
- [🏗️ Technical Architecture](#technical-architecture)
- [📊 Success Metrics](#success-metrics)

---

*"The unexamined answer is not worth accepting."*
