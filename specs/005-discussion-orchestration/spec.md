# Feature Specification: Discussion Orchestration

**Feature Branch**: `005-discussion-orchestration`  
**Created**: 2025-01-13  
**Status**: Draft  
**Input**: User description: "Discussion Orchestration: 4 phases, 2-10 rounds, consensus termination, context management"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Four-Phase Progression (Priority: P1)

As the system, I want to orchestrate debates through 4 sequential phases (Independent Analysis → Opening Arguments → Iterative Debate → Convergence) so that discussions follow structured methodology from isolated thinking to consensus.

**Why this priority**: Core orchestration logic. MVP must demonstrate phase transitions.

**Independent Test**: Start discussion, verify phases progress: Independent (all agents complete) → Opening (all complete) → Debate (consensus or max rounds) → Convergence (complete).

**Acceptance Scenarios**:

1. **Given** discussion starts, **When** initialized, **Then** phase="Independent", round=1, agents receive isolated context
2. **Given** all agents complete Phase 1, **When** system evaluates, **Then** transitions to phase="Opening", round=2
3. **Given** Phase 2 (Opening) completes, **When** system transitions, **Then** phase="Debate", rounds=3-N, agents gain cross-visibility
4. **Given** consensus reached or max rounds hit, **When** system evaluates, **Then** transitions to phase="Convergence", generates final verdict

---

### User Story 2 - Configurable Round Limits (Priority: P1)

As a user, I want to configure min/max rounds (2-10) so that debates adapt to topic complexity without endless loops.

**Why this priority**: Essential control. Testable independently from phase logic.

**Independent Test**: Set max_rounds=5, start debate, verify termination at round 5 even if consensus not reached.

**Acceptance Scenarios**:

1. **Given** user configures max_rounds=7, **When** debate reaches round 7, **Then** system terminates and transitions to Convergence
2. **Given** consensus reached at round 4, **When** max_rounds=10, **Then** system terminates early (consensus takes priority)
3. **Given** user sets min_rounds=3, **When** consensus reached at round 2, **Then** system continues to round 3 before terminating
4. **Given** no configuration provided, **When** debate starts, **Then** system uses defaults: min=2, max=10

---

### User Story 3 - Multi-Condition Termination (Priority: P1)

As the system, I want to terminate debates based on 4 conditions (consensus reached, max rounds, stable positions, user interrupt) so that discussions end intelligently.

**Why this priority**: Prevents wasted computation. Core orchestration logic.

**Independent Test**: Test each condition independently: (1) consensus=0.85, (2) round=max, (3) position_variance<5% for 2 rounds, (4) user clicks Stop.

**Acceptance Scenarios**:

1. **Given** consensus_level=0.85 and threshold=0.85, **When** round completes, **Then** termination_reason="consensus_reached"
2. **Given** round=10 and max_rounds=10, **When** round completes, **Then** termination_reason="max_rounds_reached"
3. **Given** position variance <5% for 2 consecutive rounds, **When** round completes, **Then** termination_reason="stable_positions"
4. **Given** user clicks "Stop Debate", **When** current round completes, **Then** termination_reason="user_interrupt"

---

### User Story 4 - Context Management (Priority: P2)

As an agent, I want appropriate context visibility per phase (isolated in Phase 1, full cross-visibility in Phase 3) so that debate methodology is preserved.

**Why this priority**: Ensures methodological rigor. Testable independently by context audits.

**Independent Test**: In Phase 1, verify Agent A cannot access Agent B's draft. In Phase 3, verify Agent A receives all agents' Phase 1-2 outputs.

**Acceptance Scenarios**:

1. **Given** phase="Independent", **When** Agent A generates response, **Then** context includes only: user prompt, agent role, no other agents' drafts
2. **Given** phase="Opening", **When** Agent A responds, **Then** context includes: user prompt, own Phase 1 output, no other agents' Phase 2 drafts
3. **Given** phase="Debate", **When** Agent A responds in Round 3, **Then** context includes: all agents' Phase 1-2 outputs, all Round 3 responses so far
4. **Given** phase="Convergence", **When** final verdict generated, **Then** context includes all phases, all rounds, all judge scores

---

### User Story 5 - Budget Tracking (Priority: P2)

As the system, I want to track token budget (default 50K, configurable) across all rounds so that discussions terminate before exceeding cost limits.

**Why this priority**: Cost control. Testable independently by token counting.

**Independent Test**: Set budget=10K tokens, run debate consuming 2K tokens/round, verify termination at round 5 with termination_reason="budget_exceeded".

**Acceptance Scenarios**:

1. **Given** budget=50K tokens configured, **When** discussion starts, **Then** remaining_budget=50K logged
2. **Given** round consumes 5K tokens, **When** round completes, **Then** remaining_budget reduced by 5K
3. **Given** remaining_budget<5K (insufficient for next round), **When** system evaluates, **Then** termination_reason="budget_exceeded"
4. **Given** budget=unlimited configured, **When** rounds execute, **Then** no budget checks performed

---

### Edge Cases

- What happens when **Phase 1 never completes** (agent stuck)? System times out agent after 2× normal latency, continues with completed agents, logs timeout.
- What happens when **multiple termination conditions met simultaneously** (consensus + max rounds)? System prioritizes: (1) user interrupt, (2) consensus, (3) max rounds, (4) stable, (5) budget.
- What happens when **user modifies config mid-debate** (max_rounds 10→5 at round 7)? System validates new config, applies from next round, logs configuration change.
- What happens when **all termination conditions disabled**? System enforces mandatory max_rounds=10 ceiling, logs warning.
- What happens when **position variance calculation fails** (agent responses too short)? System skips stable-position check for that round, continues with other termination conditions.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST orchestrate debates through exactly 4 sequential phases: Independent Analysis, Opening Arguments, Iterative Debate, Convergence
- **FR-002**: System MUST isolate agent context in Phase 1 (Independent): agents access only user prompt and own role
- **FR-003**: System MUST restrict context in Phase 2 (Opening): agents access own Phase 1 output only
- **FR-004**: System MUST enable full cross-visibility in Phase 3 (Debate): agents access all prior outputs
- **FR-005**: System MUST aggregate all context in Phase 4 (Convergence): final verdict generation receives complete debate history
- **FR-006**: System MUST support configurable round limits: min_rounds (1-10, default 2), max_rounds (2-10, default 10)
- **FR-007**: System MUST enforce max_rounds termination even if consensus not reached
- **FR-008**: System MUST honor min_rounds before allowing consensus-based termination
- **FR-009**: System MUST implement 4 termination conditions: consensus_reached, max_rounds_reached, stable_positions, user_interrupt
- **FR-010**: System MUST detect stable_positions: position variance <5% for 2 consecutive rounds
- **FR-011**: System MUST prioritize termination conditions: (1) user_interrupt, (2) consensus_reached, (3) max_rounds_reached, (4) stable_positions, (5) budget_exceeded
- **FR-012**: System MUST support configurable token budget (default 50K, 10K-unlimited range)
- **FR-013**: System MUST track token consumption per round and cumulative across debate
- **FR-014**: System MUST terminate when remaining_budget insufficient for next round (estimated 2K tokens/round minimum)
- **FR-015**: System MUST log phase transitions with timestamps: phase_name, start_time, end_time, trigger_condition
- **FR-016**: System MUST timeout agents in Phase 1/2 after 2× median latency, continue with completed agents
- **FR-017**: System MUST validate configuration changes mid-debate and apply from next round
- **FR-018**: System MUST enforce mandatory max_rounds=10 ceiling if all termination conditions disabled
- **FR-019**: System MUST handle position variance calculation failures by skipping stable-position check for that round

### Key Entities

- **Discussion**: Orchestration session with attributes: discussion_id, current_phase (enum: Independent, Opening, Debate, Convergence), current_round (int), config (min/max rounds, budget, thresholds), termination_reason, start_time, end_time
- **Phase**: Debate stage with attributes: phase_name, context_visibility_rules, completion_condition, round_range, agent_isolation_enabled
- **Round**: Debate iteration with attributes: round_number, phase, agent_responses (array), judge_evaluations (array), token_count, position_variance, consensus_level, duration
- **TerminationCondition**: Exit rule with attributes: condition_type (enum: consensus, max_rounds, stable, user, budget), threshold_value, priority (1-5), triggered_status, trigger_time
- **ContextWindow**: Agent visibility scope with attributes: agent_id, phase, included_rounds, included_agents, total_tokens, isolation_validated

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Phase transitions occur correctly in 100% of debates: Independent → Opening → Debate → Convergence
- **SC-002**: Context isolation in Phase 1 maintains 100% success rate (no cross-agent context leakage)
- **SC-003**: Termination conditions trigger accurately in 95% of test cases (no false positives/negatives)
- **SC-004**: Round limits honored in 100% of debates: terminate at max_rounds, continue through min_rounds
- **SC-005**: Budget tracking accuracy ≥95% (predicted vs actual token consumption within 10%)
- **SC-006**: Stable position detection identifies convergence in 80% of debates plateauing >2 rounds
- **SC-007**: Multi-condition termination prioritizes correctly in 100% of simultaneous trigger scenarios
- **SC-008**: Agent timeout recovery succeeds in 90% of stuck agent scenarios (debate continues with remaining agents)
- **SC-009**: Configuration change validation rejects invalid configs in 100% of test cases (e.g., max<min)
- **SC-010**: Phase completion latency averages: Phase 1 <30s, Phase 2 <30s, Phase 3 <60s/round, Phase 4 <20s
