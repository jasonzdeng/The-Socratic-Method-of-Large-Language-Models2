# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

# Feature Specification: Socratic Method

**Feature Branch**: `002-socratic-method`  
**Created**: 2025-01-13  
**Status**: Draft  
**Input**: User description: "Socratic Method: IntelliChain question reformulation, CONSENSAGENT sycophancy mitigation, assumption challenging with evidence"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Question-Driven Dialogue (Priority: P1)

As an agent participating in debate, I want to include at least one clarifying or probing question in each response so that the discussion uncovers deeper insights rather than just exchanging statements.

**Why this priority**: Core Socratic method behavior - transforms monologues into dialogues. MVP must demonstrate question-asking to qualify as "Socratic".

**Independent Test**: Run single debate round, parse agent responses with NLP, verify each response contains ≥1 interrogative sentence (ending with "?"). Success if 100% of agent responses meet criteria.

**Acceptance Scenarios**:

1. **Given** debate round on topic "AI safety risks", **When** agent responds, **Then** response includes at least 1 question (e.g., "What evidence supports the timeline for AGI emergence?")
2. **Given** agent with "Critic" role, **When** responding to another agent's claim, **Then** question challenges an assumption (e.g., "Does this assume uniform access to compute resources?")
3. **Given** agent formulates response, **When** question validation runs, **Then** question is substantive (not rhetorical or generic like "What do you think?")
4. **Given** agent asks question, **When** next round begins, **Then** system tracks whether question was addressed in subsequent responses

---

### User Story 2 - Assumption Challenge (Priority: P1)

As an agent with Critic role, I want to explicitly identify and challenge at least one unstated assumption in each debate round so that hidden biases and logical gaps are exposed.

**Why this priority**: Prevents arguments from resting on unchallenged foundations. Critical for debate quality. Independently testable by extracting challenge statements.

**Independent Test**: Seed debate with claim "Electric vehicles will dominate by 2030", verify Critic agent response identifies assumption (e.g., "This assumes battery production scales linearly") and provides counter-scenario.

**Acceptance Scenarios**:

1. **Given** agent reads opponent's argument, **When** formulating response, **Then** identifies 1+ assumption using phrase "This assumes..." or "The argument presupposes..."
2. **Given** identified assumption, **When** agent challenges it, **Then** provides alternative scenario or counter-evidence
3. **Given** agent challenges assumption, **When** response is evaluated, **Then** challenge is logically distinct from restating disagreement
4. **Given** multiple assumptions detected, **When** agent prioritizes, **Then** challenges most foundational assumption first

---

### User Story 3 - Evidence Citation (Priority: P1)

As an agent making factual claims, I want to provide citations or specify evidence sources so that arguments are grounded and verifiable rather than speculative.

**Why this priority**: Distinguishes rigorous debate from opinion exchange. MVP must show evidence-based reasoning.

**Independent Test**: Parse agent responses for citation markers (e.g., "[Source: ...]", "According to...", "Studies show..."), verify ≥1 citation per response when factual claims made.

**Acceptance Scenarios**:

1. **Given** agent makes factual claim (e.g., "Market cap of renewables exceeds $500B"), **When** response generated, **Then** includes citation or source qualifier
2. **Given** agent uses tool (Perplexity, Alpha Vantage), **When** incorporating results, **Then** explicitly attributes data to tool: "Perplexity search indicates..."
3. **Given** agent cannot find evidence, **When** making claim, **Then** qualifies with uncertainty: "No direct evidence found, but reasoning suggests..."
4. **Given** multiple sources available, **When** agent cites, **Then** prioritizes primary sources over secondary (e.g., research paper > news article)

---

### User Story 4 - Position Update with Confidence (Priority: P2)

As an agent encountering stronger counter-evidence, I want to update my position mid-debate and quantify confidence shifts so that the discussion demonstrates intellectual honesty and Bayesian reasoning.

**Why this priority**: Shows adaptive reasoning. Not essential for MVP but critical for demonstrating non-sycophantic behavior (CONSENSAGENT mitigation).

**Independent Test**: Inject strong counter-evidence in Round 3, monitor agent's Round 4 response for position shift keywords ("reconsidering", "updating") and confidence quantification (e.g., "confidence reduced from 80% to 55%").

**Acceptance Scenarios**:

1. **Given** agent holds position "Policy X is optimal" with 80% confidence in Round 2, **When** Round 3 presents contradictory evidence, **Then** Round 4 response states "Updating position: Policy X effectiveness uncertain, confidence now 55%"
2. **Given** agent updates position, **When** explaining shift, **Then** provides reasoning: "New evidence from [source] contradicts initial assumption about Y"
3. **Given** agent encounters minor counter-evidence, **When** evaluating impact, **Then** maintains position but adjusts confidence: "Position unchanged, confidence adjusted from 75% to 70%"
4. **Given** agent updates position, **When** system logs event, **Then** records: agent ID, round number, old position, new position, confidence delta, triggering evidence

---

### User Story 5 - IntelliChain Question Reformulation (Priority: P2)

As an agent receiving a vague or multi-part question, I want to reformulate it into clearer sub-questions using IntelliChain technique so that responses are focused and traceable.

**Why this priority**: Improves question quality and response precision. Testable independently by feeding complex questions and verifying reformulation.

**Independent Test**: Present agent with compound question "Why do markets fail and what are the solutions?", verify response breaks it into: "1. What causes market failures? 2. Which solutions address which causes?"

**Acceptance Scenarios**:

1. **Given** agent receives multi-part question, **When** processing, **Then** decomposes into numbered sub-questions (e.g., "Breaking this into: 1) ..., 2) ...")
2. **Given** vague question ("What about climate change?"), **When** reformulating, **Then** clarifies scope: "Clarifying: Are we discussing mitigation strategies or adaptation policies?"
3. **Given** reformulated sub-questions, **When** agent responds, **Then** addresses each sub-question sequentially with labeled sections
4. **Given** reformulation occurs, **When** logged, **Then** system tracks original question, reformulated questions, and which agent performed reformulation

---

### User Story 6 - CONSENSAGENT Sycophancy Mitigation (Priority: P2)

As a system operator, I want agents to resist converging prematurely on consensus by enforcing minimum divergence thresholds so that debates explore the full solution space rather than gravitating to safe middle-ground.

**Why this priority**: Prevents groupthink. CONSENSAGENT research shows LLMs over-conform. Testable by measuring opinion variance across rounds.

**Independent Test**: Run 5-round debate, measure semantic diversity of positions in Rounds 2, 3, 4. Success if diversity doesn't drop >30% between rounds (indicating premature convergence).

**Acceptance Scenarios**:

1. **Given** debate reaches Round 3, **When** system measures position variance, **Then** variance remains ≥70% of Round 1 baseline
2. **Given** agent observes majority opinion forming, **When** formulating response, **Then** system prompt includes: "Maintain contrarian perspective if evidence supports it"
3. **Given** agent's position aligns with majority, **When** explaining position, **Then** must provide independent reasoning (not "I agree with Agent X")
4. **Given** consensus appears reached, **When** Critic role agents respond, **Then** at least 1 Critic challenges consensus with alternative framing

---

### Edge Cases

- What happens when **agent fails to include a question** in response? System logs warning, prompts agent to add question via follow-up generation pass, or flags response for review.
- What happens when **assumption challenge is too shallow** (e.g., "This assumes things")? NLP validator scores challenge specificity; rejects <3/10 specificity, triggers regeneration with stricter prompt.
- What happens when **evidence citation is fabricated** (hallucinated source)? System cross-references citations with tool results and known sources; flags unverifiable citations for human review.
- What happens when **agent refuses to update position** despite strong counter-evidence? System logs stubbornness metric, escalates to Judge Panel for "intellectual flexibility" dimension evaluation.
- What happens when **question reformulation creates >5 sub-questions**? System limits reformulation to 3 sub-questions maximum to prevent fragmentation, prioritizes most critical questions.
- What happens when **all agents converge in Round 2** (variance drops to <30%)? System triggers "divergence injection": assigns 2 agents to explore contrarian positions with increased reward weight.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST enforce that every agent response includes at least 1 interrogative sentence (question ending with "?")
- **FR-002**: System MUST validate question substantiveness using NLP scoring (reject generic/rhetorical questions scoring <3/10)
- **FR-003**: System MUST require agents to explicitly identify assumptions using markers: "This assumes...", "Presupposes...", "Takes for granted..."
- **FR-004**: System MUST validate assumption challenges are distinct from simple disagreement (not just "I disagree because...")
- **FR-005**: System MUST require evidence citations for factual claims using formats: "[Source: X]", "According to Y", "Data from Z"
- **FR-006**: System MUST attribute tool-derived data to specific tools (e.g., "Perplexity search indicates...", "Alpha Vantage reports...")
- **FR-007**: System MUST allow agents to qualify uncertain claims with markers: "No direct evidence found, but...", "Reasoning suggests..."
- **FR-008**: System MUST enable agents to update positions mid-debate with explicit change statements: "Updating position:", "Reconsidering..."
- **FR-009**: System MUST require confidence quantification when positions update (e.g., "confidence reduced from 80% to 55%")
- **FR-010**: System MUST log position updates with: agent ID, round number, old position, new position, confidence delta, triggering evidence
- **FR-011**: System MUST implement IntelliChain question reformulation: decompose multi-part questions into numbered sub-questions
- **FR-012**: System MUST limit question reformulation to maximum 3 sub-questions to prevent fragmentation
- **FR-013**: System MUST measure semantic diversity of agent positions across rounds using embedding cosine similarity
- **FR-014**: System MUST trigger divergence warnings when position variance drops >30% between consecutive rounds
- **FR-015**: System MUST inject contrarian prompts to 2 agents when consensus appears premature (variance <30% before Round 4)
- **FR-016**: System MUST prevent agents from using "I agree with Agent X" reasoning without independent justification
- **FR-017**: System MUST validate evidence citations against tool results and flag unverifiable sources for review
- **FR-018**: System MUST track question-response chains: which questions were asked in Round N, which were addressed in Round N+1
- **FR-019**: System MUST assign higher priority to challenging foundational assumptions over superficial details
- **FR-020**: System MUST log "stubbornness metric" when agents fail to update positions despite strong counter-evidence (>80% confidence contradicting evidence)

### Key Entities

- **Question**: Interrogative statement with attributes: text, substantiveness score (1-10), type (clarifying, probing, challenging), reformulated sub-questions, asking agent, target agent/topic, addressed status
- **Assumption**: Unstated premise with attributes: text, challenged status, challenger agent, round identified, alternative scenarios proposed, foundational importance score
- **Citation**: Evidence reference with attributes: source name, type (tool output, study, news), claim it supports, verification status (verified, unverifiable, flagged), timestamp
- **PositionUpdate**: Belief change event with attributes: agent ID, round number, old position text, new position text, old confidence %, new confidence %, confidence delta, triggering evidence IDs, reasoning text
- **DivergenceMetric**: Debate health indicator with attributes: round number, position variance %, semantic diversity score, consensus warnings, contrarian injection triggers

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of agent responses contain at least 1 substantive question (score ≥3/10) across 20 test debates
- **SC-002**: 85% of Critic role responses successfully identify and challenge explicit assumptions using required markers
- **SC-003**: 90% of factual claims include verifiable citations or uncertainty qualifiers
- **SC-004**: Position updates occur in ≥40% of debates lasting >3 rounds when contradictory evidence introduced
- **SC-005**: Semantic diversity of agent positions maintains ≥70% of Round 1 baseline through Round 3 in 80% of debates (CONSENSAGENT mitigation success)
- **SC-006**: Question reformulation reduces compound questions to 2-3 focused sub-questions in 95% of cases
- **SC-007**: Question-response tracking shows ≥60% of questions from Round N addressed in Round N+1
- **SC-008**: Contrarian injection triggers successfully increase position variance by >15% within 2 rounds in 70% of premature consensus scenarios
- **SC-009**: Citation verification flags <10% false positives (valid citations incorrectly marked unverifiable)
- **SC-010**: Confidence quantification appears in 100% of position update statements with delta ≥10%
- **SC-011**: Assumption challenges rated as "substantive" (not mere disagreement) by human evaluators in 75% of cases
- **SC-012**: Stubbornness metric triggers review for <15% of agents per debate (indicating healthy intellectual flexibility)
