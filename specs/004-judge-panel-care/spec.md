# Feature Specification: Judge Panel with CARE Aggregation

**Feature Branch**: `004-judge-panel-care`  
**Created**: 2025-01-13  
**Status**: Draft  
**Input**: User description: "Judge Panel with CARE aggregation: 3-5 judge LLMs, 5-dimension evaluation, 10-25% better than majority vote"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Multi-Dimension Scoring (Priority: P1)

As a judge LLM, I want to evaluate agent responses across 5 dimensions (factual accuracy, logical coherence, novelty, engagement quality, consensus contribution) so that assessments capture nuanced quality beyond binary agree/disagree.

**Why this priority**: Core judging capability. MVP must demonstrate multi-dimensional evaluation.

**Independent Test**: Submit agent response, verify judge returns 5 scores (1-10 scale) for factual, logical, novelty, engagement, consensus.

**Acceptance Scenarios**:

1. **Given** completed debate round, **When** judge evaluates Agent A, **Then** returns scores: {"factual": 8, "logical": 9, "novelty": 6, "engagement": 7, "consensus": 8}
2. **Given** response with factual errors, **When** judge scores, **Then** factual dimension <5, other dimensions may remain high
3. **Given** response with novel insights, **When** judge scores, **Then** novelty dimension ≥8
4. **Given** judge completes scoring, **When** system validates, **Then** all 5 dimensions present with scores 1-10

---

### User Story 2 - CARE Aggregation (Priority: P1)

As the system, I want to aggregate 3-5 judge scores using CARE method so that final consensus determination is 10-25% more accurate than simple majority voting.

**Why this priority**: Differentiating feature. Must demonstrate superior aggregation vs. baseline.

**Independent Test**: Run 20 test debates, compare CARE aggregation accuracy to majority vote baseline, verify CARE improves by ≥10%.

**Acceptance Scenarios**:

1. **Given** 5 judges score debate, **When** CARE aggregates scores, **Then** produces consensus_level (0-1) and agreed_points list
2. **Given** CARE consensus_level=0.85, **When** compared to majority vote, **Then** CARE accuracy ≥10% higher on ground truth dataset
3. **Given** judges disagree significantly, **When** CARE processes, **Then** consensus_level <0.50 and debated_points list populated
4. **Given** CARE output generated, **When** system validates, **Then** schema includes: consensus_level, agreed_points, debated_points, quality_scores

---

### User Story 3 - Independent Judge Evaluation (Priority: P1)

As a judge LLM, I want to evaluate responses independently without seeing other judges' scores so that my assessment is unbiased and authentic.

**Why this priority**: Methodological rigor. Prevents judge convergence bias.

**Independent Test**: Send identical response to 3 judges simultaneously, verify scores differ (>30% variance in at least 2 dimensions).

**Acceptance Scenarios**:

1. **Given** debate round completes, **When** judges evaluate, **Then** each judge receives only agent responses, not other judges' scores
2. **Given** Judge A completes scoring, **When** Judge B is evaluating, **Then** Judge B cannot access Judge A's scores
3. **Given** all judges complete, **When** system aggregates, **Then** judges' scores show meaningful variance (not identical)
4. **Given** judge evaluates, **When** prompted, **Then** includes justification text for each dimension score

---

### User Story 4 - Consensus Detection (Priority: P2)

As the system, I want to detect when consensus_level exceeds threshold (default 0.85) so that debates terminate efficiently when agreement is reached.

**Why this priority**: Enables intelligent termination. Testable independently from full orchestration.

**Independent Test**: Set consensus threshold=0.80, run CARE aggregation resulting in 0.85, verify system triggers "consensus reached" event.

**Acceptance Scenarios**:

1. **Given** CARE aggregation produces consensus_level=0.85, **When** threshold=0.85, **Then** system marks debate "consensus reached"
2. **Given** consensus reached, **When** verdict generated, **Then** includes: agreed_points list, final_position text, supporting evidence
3. **Given** consensus_level=0.75, **When** threshold=0.85, **Then** system continues debate (consensus not reached)
4. **Given** user sets custom threshold=0.90, **When** system evaluates, **Then** uses 0.90 instead of default 0.85

---

### Edge Cases

- What happens when **judges give wildly divergent scores** (variance >4 points per dimension)? CARE aggregation weights lower, consensus_level drops, debated_points expanded.
- What happens when **all judges give identical scores**? System logs convergence warning, flags potential judge prompt issue.
- What happens when **judge fails to provide all 5 dimensions**? System rejects incomplete evaluation, prompts judge to complete scoring.
- What happens when **CARE accuracy is <10% better than majority**? System logs performance warning, falls back to majority vote with quality_scores metadata.
- What happens when **consensus_level plateaus** (same value 3+ rounds)? System triggers termination recommendation to avoid infinite loops.
- What happens when **judge justification contradicts score** (e.g., "excellent" text but score=3)? System flags inconsistency for review, uses score but logs discrepancy.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support configurable judge panel size: 3-5 judge LLMs per debate
- **FR-002**: System MUST require judges to score responses across exactly 5 dimensions: factual accuracy, logical coherence, novelty, engagement quality, consensus contribution
- **FR-003**: System MUST enforce 1-10 integer scoring scale for all dimensions
- **FR-004**: System MUST isolate judge evaluations (judges cannot access other judges' scores during evaluation)
- **FR-005**: System MUST implement CARE aggregation method for consensus determination
- **FR-006**: System MUST produce CARE output schema: consensus_level (0-1 float), agreed_points (array), debated_points (array with positions), quality_scores (object)
- **FR-007**: System MUST validate CARE aggregation improves accuracy ≥10% over majority vote baseline on test dataset
- **FR-008**: System MUST support configurable consensus threshold (default 0.85, range 0.50-0.99)
- **FR-009**: System MUST trigger "consensus reached" event when consensus_level ≥ threshold
- **FR-010**: System MUST generate verdict when consensus reached: agreed_points, final_position, supporting_evidence
- **FR-011**: System MUST require judges to provide justification text for each dimension score
- **FR-012**: System MUST reject incomplete judge evaluations (missing dimensions)
- **FR-013**: System MUST log judge score variance across all dimensions for bias detection
- **FR-014**: System MUST flag judge convergence warnings when all scores identical (variance <0.5)
- **FR-015**: System MUST detect consensus_level plateau (same value 3+ consecutive rounds) and recommend termination
- **FR-016**: System MUST validate judge justifications align with scores (flag score-text contradictions)
- **FR-017**: System MUST fall back to majority vote with quality_scores metadata if CARE accuracy <10% improvement
- **FR-018**: System MUST persist all judge evaluations with: judge ID, agent ID, round number, dimension scores, justifications, timestamp

### Key Entities

- **Judge**: LLM evaluator with attributes: judge ID, provider name, evaluation count, average score variance, bias metrics
- **Evaluation**: Judge assessment with attributes: evaluation ID, judge ID, agent ID, round number, dimension scores (5×), justifications (5× text), timestamp
- **CAREResult**: Aggregated consensus with attributes: consensus_level (float), agreed_points (array of strings), debated_points (array of {topic, positions} objects), quality_scores (agent_id → dimension → score map), verdict_text (if consensus reached)
- **ConsensusTreshold**: Configuration with attributes: threshold value (0.50-0.99), plateau_rounds (default 3), majority_fallback_enabled (boolean)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: CARE aggregation achieves 10-25% higher consensus accuracy than majority vote baseline on 50-debate test corpus
- **SC-002**: Judges produce all 5 dimension scores in 100% of evaluations
- **SC-003**: Judge score variance averages ≥2.0 points per dimension across debates (confirming independence)
- **SC-004**: Consensus detection triggers correctly in 95% of cases when threshold met (no false positives/negatives)
- **SC-005**: Verdict generation includes ≥3 agreed_points and final_position text in 90% of consensus scenarios
- **SC-006**: Judge justification-score consistency validated with <15% flagged contradictions
- **SC-007**: CARE aggregation completes within 5s for 5 judges evaluating 5 agents
- **SC-008**: Consensus plateau detection prevents infinite loops in 100% of stalled debates (≥3 rounds same consensus_level)
- **SC-009**: System successfully falls back to majority vote in <5% of debates where CARE underperforms
- **SC-010**: Quality_scores metadata enables post-debate analysis with 100% dimension coverage per agent
