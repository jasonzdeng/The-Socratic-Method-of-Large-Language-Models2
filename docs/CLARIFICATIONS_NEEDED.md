# Specification Clarifications Needed

**Generated**: 2025-11-12  
**Status**: Review Required  
**Purpose**: Identify ambiguous requirements across all 7 feature specifications that need stakeholder clarification

---

## F1: Multi-Agent System (`001-multi-agent-system`)

### 🔴 High Priority Clarifications

#### C1.1: Provider Distribution Algorithm
**Location**: User Story 1, Acceptance Scenario 3  
**Issue**: "balanced provider distribution" is undefined  
**Current Text**: "exactly 8 agents are created with balanced provider distribution"  
**Clarification Needed**:
User-configurable weighting (e.g., 50% OpenAI, 30% Claude, 20% others)


**Suggested Resolution**: Specify algorithm: "Round-robin distribution ensuring max difference between any two providers ≤1 agent"

---

#### C1.2: Role Distribution Rules
**Location**: User Story 2, FR-005  
**Issue**: "distribute roles evenly" conflicts with example distribution  
**Current Text**: 
- FR-005: "distribute roles evenly across agent pool (no role type >50% of pool unless pool size <4)"
- Scenario 1: "5 agents → 2× Analyst, 1× Critic, 1× Researcher, 1× Synthesizer"

**Clarification Needed**:
- Why does Analyst get 2 agents while others get 1? (Not "even")
- Is there a priority ordering: Analyst > Critic > Researcher > Synthesizer?
- For 7 agents: 2-2-2-1 distribution? Which role gets 1?
- For 10 agents: 3-3-2-2? Or 4-2-2-2?

**Suggested Resolution**: Define explicit formula or priority-based allocation algorithm. Round-robin distribution ensuring max difference. 

---

#### C1.3: Semantic Divergence Measurement
**Location**: User Story 4, FR-016  
**Issue**: "40% semantic divergence" lacks implementation specification  
**Current Text**: "System MUST validate semantic divergence >40% between Phase 1 agent responses"  
**Clarification Needed**:
- Which embedding model for semantic similarity? (OpenAI text-embedding-3, Sentence-BERT?)
- Divergence calculated how? (1 - cosine_similarity? Euclidean distance?)
- Pairwise comparison (all pairs averaged) or variance-based?
- What if embeddings unavailable (API failure)?

**Suggested Resolution**: (yes use a embedding model from openai)
---

### 🟡 Medium Priority Clarifications

#### C1.4: Retry Backoff Strategy
**Location**: FR-015  
**Issue**: Exponential backoff sequence ambiguous  
**Current Text**: "exponential backoff (1s, 2s, 4s)"  
**Clarification Needed**:
- Does this apply to rate limits only or all failures?
- After 4s, does it stop or continue (8s, 16s...)?
- Max backoff duration before giving up?

**Suggested Resolution**: "Rate limit backoff: 1s, 2s, 4s, 8s (max 4 attempts). General failures: immediate retry, 2s retry, then fallback" Yes

---

#### C1.5: Provider Fallback Priority
**Location**: User Story 3  
**Issue**: Fallback provider selection strategy undefined  
**Current Text**: "automatically attempts initialization with provider B from available pool"  
**Clarification Needed**:
- Is there a priority order (OpenAI > Claude > Gemini...)?
- Or: Random selection from remaining providers?
- Or: Least-used provider for load balancing?
- Or: User-configurable priority list?

**Suggested Resolution**: OpenAI > Claude > KIMI > DEEPSEEK > GEMINI ...
---

## F2: Socratic Method (`002-socratic-method`)

### 🔴 High Priority Clarifications

#### C2.1: Question Substantiveness Scoring
**Location**: FR-002  
**Issue**: NLP scoring algorithm not specified  
**Current Text**: "reject generic/rhetorical questions scoring <3/10"  
**Clarification Needed**:
- Which NLP model/library for scoring? (Custom classifier? GPT-based?)
- What criteria define "substantive"? (Specificity, domain relevance, complexity?)
- Who trains/validates the scoring model?
- Fallback if NLP service unavailable?

**Suggested Resolution**: Specify: "Use GPT-4 with prompt: 'Rate question substantiveness 1-10 based on: specificity, logical depth, relevance to debate context'" Yes

---

#### C2.2: Position Variance Calculation
**Location**: FR-013, SC-005  
**Issue**: "Semantic diversity" measurement method unclear  
**Current Text**: "measure semantic diversity of agent positions using embedding cosine similarity"  
**Clarification Needed**:
- Position = full response text or extracted claim only?
- Which embedding model? (Must match C1.3 for consistency)
- Variance threshold: why 30% drop triggers warning? (Evidence-based?)
- How to extract "position" from multi-paragraph response?

**Suggested Resolution**: Define position extraction: "Use first 3 sentences containing modal verbs (should, must, will) as position. Embed with text-embedding-3-large (yes use a model from openai)"

---

#### C2.3: Citation Verification Process
**Location**: FR-017  
**Issue**: "Cross-reference citations with tool results" implementation unclear  
**Current Text**: "System MUST validate evidence citations against tool results and flag unverifiable sources"  
**Clarification Needed**:
- How to match free-text citation to tool result? (Fuzzy matching? Entity extraction?)
- What about citations from agent's training data (not tool-derived)?
- Who maintains "known sources" database?
- Acceptable false positive rate for flagging?

**Suggested Resolution**: "Tool-derived citations MUST include tool_invocation_id. Non-tool citations marked [UNVERIFIED] but not rejected" OK

---

### 🟡 Medium Priority Clarifications

#### C2.4: Contrarian Injection Mechanism
**Location**: FR-015  
**Issue**: "Inject contrarian prompts" strategy not detailed  
**Current Text**: "system prompt includes: 'Maintain contrarian perspective if evidence supports it'"  
**Clarification Needed**:
- Which 2 agents selected for contrarian injection? (Random? Critic role priority?)
- Does contrarian requirement override agent's actual analysis?
- How long does contrarian mode persist? (1 round? Until variance improves?)

**Suggested Resolution**: "Select 1 Critic + 1 random non-Critic. Append prompt: 'Challenge consensus with alternative interpretation. Duration: 2 rounds'"

---

## F3: Tool Integration (`003-tool-integration`)

### 🔴 High Priority Clarifications

#### C3.1: Perplexity Context Truncation Strategy
**Location**: FR-012  
**Issue**: "Oldest-first truncation" may lose critical context  
**Current Text**: "truncate Perplexity context to 200K tokens using oldest-first strategy"  
**Clarification Needed**:
- What if oldest context contains key definitions/background?
- Should we preserve: (a) most recent N rounds, or (b) relevance-ranked chunks?
- Who decides relevance ranking algorithm?

**Suggested Resolution**: "Preserve: (1) user query, (2) most recent 2 rounds, (3) oldest rounds summarized to 10% original size. Total ≤200K tokens" OK

---

#### C3.2: Tool Parameter Validation Rules
**Location**: FR-007  
**Issue**: Validation logic per-tool not specified  
**Current Text**: "System MUST validate tool parameters before API invocation (e.g., ticker symbols, code syntax)"  
**Clarification Needed**:
- Ticker validation: regex pattern? API lookup to verify existence?
- Code syntax: Python AST parsing? Blacklist dangerous operations (os, sys)?
- What about Perplexity query validation? (Length limits? Content filtering?)

**Suggested Resolution**: Define per-tool validation schemas in configuration. Example: `AlphaVantage: ticker = regex(^[A-Z]{1,5}$) + API_exists_check` OK

---

#### C3.3: MCP Schema Version Compatibility
**Location**: FR-018  
**Issue**: Version mismatch handling strategy unclear  
**Current Text**: "conform to MCP request/response schema for MCP-compliant tools"  
**Clarification Needed**:
- Which MCP schema version required? (1.0? Latest?)
- Forward/backward compatibility strategy?
- Do we support multiple schema versions simultaneously?
- Deprecation timeline for old versions?

**Suggested Resolution**: "Support MCP schema v1.x with backward compatibility. Log warnings for deprecated features. Drop support for v0.x after 6 months" OK

---

### 🟡 Medium Priority Clarifications

#### C3.4: Retry vs Fallback Decision Logic
**Location**: FR-006  
**Issue**: When to retry vs when to fallback unclear  
**Current Text**: "2× retry logic with exponential backoff (2s, 4s) for failed tool calls"  
**Clarification Needed**:
- Retry for: timeout, 5xx errors, rate limits?
- Immediate fallback for: 4xx errors, invalid params?
- What is "fallback" for tools? (Skip tool use? Use alternative tool? Cache?)

**Suggested Resolution**: "Retry: timeouts, 503, rate limits. Fallback (skip tool): 400-499, invalid response format. No fallback: continue debate without data"

---

## F4: Judge Panel (CARE) (`004-judge-panel-care`)

### 🔴 High Priority Clarifications

#### C4.1: CARE Aggregation Algorithm
**Location**: FR-005, SC-001  
**Issue**: CARE method not specified - proprietary algorithm?  
**Current Text**: "implement CARE aggregation method", "10-25% better than majority vote"  
**Clarification Needed**:
- Is CARE a published algorithm? (Reference paper? Implementation repo?)
- If proprietary: do we have license/permission to implement?
- What are the mathematical steps? (Weighted voting? Confidence-adjusted?)
- How to validate "10-25% better"? (Need ground truth dataset?)

**Suggested Resolution**: TODO: select a easy to implement and reasonable method

---

#### C4.2: Consensus Level Calculation
**Location**: FR-006  
**Issue**: How consensus_level (0-1) computed from 5-dimension scores?  
**Current Text**: "consensus_level (0-1 float)"  
**Clarification Needed**:
- Is it: average of all judges' scores across all dimensions?
- Or: weighted by dimension importance (factual > novelty)?
- Or: minimum score across dimensions (weakest link)?
- How do agreed_points and debated_points factor in?

**Suggested Resolution**: "consensus_level = weighted_avg(dimension_agreement × dimension_weights). Weights: factual=0.3, logical=0.3, novelty=0.15, engagement=0.15, consensus=0.10"

---

#### C4.3: Judge Independence Validation
**Location**: FR-004, SC-003  
**Issue**: "≥2.0 points variance" arbitrary - how determined?  
**Current Text**: "Judge score variance averages ≥2.0 points per dimension"  
**Clarification Needed**:
- Why 2.0? (Statistical basis? Empirical testing?)
- Is this variance or standard deviation?
- Per-dimension or across-dimensions?
- What if variance too high (e.g., 8 points) - indicates judge quality issues?

**Suggested Resolution**: "Standard deviation ≥2.0 per dimension confirms independence. Flag if σ<1.5 (too similar) or σ>4.0 (quality concerns)"

---

### 🟡 Medium Priority Clarifications

#### C4.4: Dimension Score Interpretation
**Location**: FR-002  
**Issue**: What do dimension scores mean? (Absolute or relative?)  
**Current Text**: "factual accuracy, logical coherence, novelty, engagement quality, consensus contribution"  
**Clarification Needed**:
- Factual accuracy: fact-checked claims count? Or judge's perception?
- Logical coherence: logical fallacies count? Or readability?
- Novelty: novel to this debate? Or generally novel insight?
- Should we provide judges with scoring rubrics/examples?

**Suggested Resolution**: Define scoring rubric document. Example: "Factual (1-10): 1-3=multiple errors, 4-6=some errors, 7-9=accurate, 10=perfect + evidence"

---

## F5: Discussion Orchestration (`005-discussion-orchestration`)

### 🔴 High Priority Clarifications

#### C5.1: Phase Transition Conditions
**Location**: FR-001, User Story 1  
**Issue**: "All agents complete" timing unclear  
**Current Text**: "Phase 1 termination: All agents complete. Phase 2 termination: All agents complete"  
**Clarification Needed**:
- Complete = submit response? Or response passes validation?
- What if agent response rejected by validation - does agent retry?
- Max wait time before timing out stuck agent?
- Can phases overlap (Phase 2 starts while Phase 1 agent still processing)?

**Suggested Resolution**: "Complete = response submitted + passed validation. Timeout: 2× median agent latency. No overlap: Phase N+1 waits for all Phase N agents"

---

#### C5.2: Position Variance Measurement
**Location**: FR-010, SC-006  
**Issue**: Same as C2.2 - must be consistent across features  
**Current Text**: "position variance <5% for 2 consecutive rounds"  
**Clarification Needed**:
- 5% of what baseline? (Round 1 variance?)
- Why "<5%" vs Socratic Method's "70% of Round 1 baseline"? (Different metrics?)
- Cross-feature consistency needed

**Suggested Resolution**: Align with F2 (Socratic Method) - use same embedding-based variance calculation

---

#### C5.3: Token Budget Estimation
**Location**: FR-014  
**Issue**: "Estimated 2K tokens/round minimum" - how calculated?  
**Current Text**: "terminate when remaining_budget insufficient for next round (estimated 2K tokens/round minimum)"  
**Clarification Needed**:
- Does 2K include: agent responses only? Or also system prompts, context, tool calls?
- Does estimate adapt based on actual usage or fixed 2K?
- What if actual usage 10K/round but budget assumed 2K?

**Suggested Resolution**: "Dynamic estimation: avg(last 3 rounds) × 1.2 safety margin. Minimum floor: 2K tokens. Includes: prompts, context, responses, tool calls"

---

### 🟡 Medium Priority Clarifications

#### C5.4: Configuration Change Validation
**Location**: FR-017  
**Issue**: What validations applied to mid-debate config changes?  
**Current Text**: "validate configuration changes mid-debate and apply from next round"  
**Clarification Needed**:
- Can user reduce max_rounds below current_round? (e.g., round 7, change max to 5?)
- Can budget be increased/decreased mid-debate?
- Are some configs immutable once debate starts? (e.g., agent count, providers?)

**Suggested Resolution**: "Immutable: agent_count, providers. Mutable: max_rounds (≥current+1), budget (≥remaining_estimate), thresholds. Reject invalid changes with error"

---

## F6: User Interface (`006-user-interface`)

### 🔴 High Priority Clarifications

#### C6.1: SSE Reconnection State Management
**Location**: FR-006  
**Issue**: "Buffer missed events" - how to detect what was missed?  
**Current Text**: "UI displays reconnection indicator, buffers missed events, backfills when reconnected"  
**Clarification Needed**:
- How does UI know which events missed? (Event sequence numbers? Timestamps?)
- Does server maintain per-client event buffer? (Memory limits? Expiration?)
- Max buffer size before dropping events?

**Suggested Resolution**: "Server assigns sequence_id to each SSE event. On reconnect, client sends last_received_id. Server replays events since that ID (buffer: 100 events or 5 minutes)"

---

#### C6.2: Template Parameter Conflict Resolution
**Location**: FR-017  
**Issue**: "Adjust to minimum viable config" strategy unclear  
**Current Text**: "validate template parameters and adjust to minimum viable config if conflicts detected"  
**Clarification Needed**:
- Example: template wants 10 agents but only 2 providers enabled. Adjust how?
  - Option A: Reduce to 6 agents (3× per provider)?
  - Option B: Enable more providers automatically?
  - Option C: Reject template and show error?
- Who defines "minimum viable" thresholds?

**Suggested Resolution**: "Minimum viable: ≥3 agents, ≥2 providers. If template conflicts: scale agents down to max_agents_per_provider × available_providers. Show warning modal"

---

#### C6.3: Export File Size Handling
**Location**: FR-019  
**Issue**: "100MB threshold" arbitrary - platform/browser limitations?  
**Current Text**: "warn users when export size >100MB and offer summary-only or chunked alternatives"  
**Clarification Needed**:
- Why 100MB? (Browser memory limits? Download timeout concerns?)
- Chunked exports: split by round? By agent? User chooses?
- Summary-only: what's included vs excluded?

**Suggested Resolution**: "100MB = typical browser safe limit. Chunked: 10 rounds per file. Summary: executive summary + consensus breakdown + metadata only (<1MB)"

---

### 🟡 Medium Priority Clarifications

#### C6.4: Template Selection UX
**Location**: User Story 4  
**Issue**: Template gallery presentation not specified  
**Current Text**: "displays: Investment, Research, Geopolitical, Tech with descriptions"  
**Clarification Needed**:
- Visual design: cards? List? Comparison table?
- Descriptions: how detailed? (1 sentence? Paragraph?)
- Can users save custom templates?
- Preview template config before starting?

**Suggested Resolution**: "Card layout with: template name, 2-sentence description, agent count, tool list, 'Preview' button shows full config before start"

---

## F7: Parlant Integration (`007-parlant-integration`)

### 🔴 High Priority Clarifications

#### C7.1: Parlant Service Dependency
**Location**: FR-001, FR-012  
**Issue**: Parlant integration scope unclear - full framework or partial?  
**Current Text**: "integrate Parlant framework", "fall back to non-Parlant operation if Parlant service unavailable"  
**Clarification Needed**:
- Is Parlant an external service/library or custom implementation?
- If external: license? API documentation? Version requirements?
- If custom: implementation scope? (Full Parlant feature set or subset?)
- Fallback mode: which features lost? (Just guidelines? Journey templates?)

**Suggested Resolution**: "Integrate Parlant v2.x library (MIT license). Fallback: disable journey templates + guidelines. Maintain core orchestration + tool use"

---

#### C7.2: Guideline Validation Mechanism
**Location**: FR-003  
**Issue**: How to validate "Analyst must include ≥1 citation"?  
**Current Text**: "validate agent responses against guideline requirements (e.g., Analyst must include ≥1 citation)"  
**Clarification Needed**:
- Citation detection: regex pattern ([Source: X])? NLP citation extraction?
- If validation fails: reject response + agent retries? Or log warning + accept?
- Validation latency acceptable? (Could slow response streaming)

**Suggested Resolution**: "Regex patterns per guideline (citation: \\[Source:|According to). If fail: log warning + reduce agent's quality_score by 10%. Don't block response"

---

#### C7.3: Journey Template Structure
**Location**: FR-004  
**Issue**: Template definition format not specified  
**Current Text**: "journey templates defining: turn order, time limits, phase transition rules, structural requirements"  
**Clarification Needed**:
- Template file format? (JSON? YAML? Custom DSL?)
- Who creates templates? (Developers only? Power users?)
- Schema validation on template load?
- Example template to demonstrate structure?

**Suggested Resolution**: "JSON schema with fields: name, turn_order: [role], time_limits: {agent: 120s, phase: 600s}, transitions: [{from, to, condition}]. Validate on load"

---

### 🟡 Medium Priority Clarifications

#### C7.4: Tool Suggestion Ranking Algorithm
**Location**: FR-008  
**Issue**: "Rank by relevance" - how determined?  
**Current Text**: "ranks by relevance: (1) Perplexity for research, (2) Alpha Vantage for stocks, (3) Code Sandbox for calculations"  
**Clarification Needed**:
- Relevance based on: keywords in context? Agent role? Topic classification?
- Static ranking or dynamic based on discussion content?
- Can user override ranking preferences?

**Suggested Resolution**: "Keyword-based: {stock, finance, market} → Alpha Vantage. {analysis, research, evidence} → Perplexity. {calculation, code, verify} → Code Sandbox. User overrides in advanced config"

---

## Summary Statistics

- **Total Clarifications Identified**: 27
  - 🔴 High Priority: 19 (70%)
  - 🟡 Medium Priority: 8 (30%)

- **By Feature**:
  - F1 (Multi-Agent): 5 clarifications
  - F2 (Socratic Method): 4 clarifications
  - F3 (Tool Integration): 4 clarifications
  - F4 (Judge Panel CARE): 4 clarifications
  - F5 (Discussion Orchestration): 4 clarifications
  - F6 (User Interface): 4 clarifications
  - F7 (Parlant Integration): 4 clarifications

- **Common Patterns**:
  1. **Algorithmic Ambiguity**: "balanced", "optimal", "relevant" lack mathematical definitions (9 instances)
  2. **Threshold Arbitrariness**: Numeric thresholds (40%, 2.0, 100MB) without justification (7 instances)
  3. **Cross-Feature Inconsistency**: Position variance measured differently in F2 vs F5 (2 instances)
  4. **External Dependency Uncertainty**: Parlant, CARE, MCP specifications missing (3 instances)
  5. **Error Handling Gaps**: Fallback strategies incomplete (6 instances)

---

## Recommended Next Actions

1. **Immediate (Pre-Implementation)**:
   - Address all 🔴 High Priority clarifications (19 items)
   - Establish cross-feature consistency for shared concepts (variance, embeddings, scoring)
   - Document external dependencies (Parlant, CARE algorithm, MCP version)

2. **Phase 1 (MVP)**:
   - Define algorithms with mathematical precision (distribution, ranking, aggregation)
   - Create configuration schema documents for all tunable parameters
   - Build validation test suite for ambiguous requirements

3. **Phase 2 (Refinement)**:
   - Address 🟡 Medium Priority clarifications based on Phase 1 learnings
   - User testing to validate threshold values (40% divergence, 100MB export, etc.)
   - Performance tuning to optimize timeout values and retry strategies

4. **Documentation Updates Required**:
   - Create `docs/algorithms/` directory with detailed algorithm specifications
   - Add `docs/configuration-schema.json` defining all parameters with ranges/defaults
   - Update constitution with cross-feature consistency requirements

---

**Review Status**: ⏸️ Awaiting Stakeholder Decisions  
**Blocking**: Implementation task creation (`/tasks`) should wait for high-priority clarifications  
**Estimated Resolution Time**: 2-4 hours stakeholder meeting + 1-2 days documentation
