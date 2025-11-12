# Feature Specification: Parlant Integration

**Feature Branch**: `007-parlant-integration`  
**Created**: 2025-01-13  
**Status**: Draft  
**Input**: User description: "Parlant Integration: Guidelines per role, journey templates, tool orchestration"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Role-Specific Guidelines (Priority: P2)

As an agent with assigned role (Analyst, Critic, Researcher, Synthesizer), I want Parlant to provide behavioral guidelines specific to my role so that my contributions consistently reflect role-appropriate style and focus.

**Why this priority**: Enhances role differentiation. Not critical for MVP but improves debate quality.

**Independent Test**: Assign agent "Rigorous Analyst" guideline, verify responses include citations, formal tone, data-driven language.

**Acceptance Scenarios**:

1. **Given** agent assigned "Analyst" role, **When** Parlant guideline loaded, **Then** instructions include: "Focus on data interpretation, provide citations, use formal tone, challenge weak claims"
2. **Given** agent with Analyst guideline responds, **When** output generated, **Then** includes ≥1 citation, formal vocabulary (no colloquialisms), numerical data references
3. **Given** agent assigned "Critic" role, **When** guideline loaded, **Then** instructions include: "Challenge assumptions, identify logical flaws, request evidence, maintain skeptical stance"
4. **Given** agent with Critic guideline responds, **When** evaluated, **Then** contains ≥1 assumption challenge, ≥1 request for evidence

---

### User Story 2 - Journey Templates (Priority: P3)

As a system orchestrator, I want Parlant journey templates to define debate structure (turn order, time limits, phase transitions) so that discussions follow predefined workflows consistently.

**Why this priority**: Adds structure rigor. Phase 2 feature - not essential for MVP.

**Independent Test**: Load "Formal Debate" journey, verify system enforces: alternating turns, 2-minute agent time limit, structured opening statements.

**Acceptance Scenarios**:

1. **Given** "Formal Debate" journey selected, **When** debate starts, **Then** Parlant enforces: opening statements (all agents), rebuttal phase (alternating turns), closing arguments
2. **Given** journey defines turn order: Analyst → Critic → Researcher → Synthesizer, **When** round executes, **Then** agents respond in specified sequence
3. **Given** journey specifies 2-minute time limit, **When** agent exceeds limit, **Then** response truncated at 2 minutes, logged as "time_limit_exceeded"
4. **Given** journey template includes phase transition rules, **When** conditions met, **Then** Parlant triggers phase change via orchestration API

---

### User Story 3 - Tool Orchestration (Priority: P3)

As an agent using tools (Perplexity, Alpha Vantage, Code Sandbox), I want Parlant to orchestrate tool invocations by suggesting optimal tools for current context and validating parameters before execution.

**Why this priority**: Improves tool usage quality. Nice-to-have for Phase 2.

**Independent Test**: Agent analyzing financial topic, Parlant suggests Alpha Vantage, validates ticker symbol, executes call.

**Acceptance Scenarios**:

1. **Given** agent analyzing "AAPL stock performance", **When** Parlant evaluates context, **Then** suggests tool: Alpha Vantage with parameter guidance: "ticker=AAPL"
2. **Given** agent decides to invoke tool, **When** Parlant orchestrates, **Then** validates parameters (ticker symbol format), retries with corrections if invalid
3. **Given** tool execution completes, **When** Parlant receives result, **Then** formats response for agent context: "Alpha Vantage returned: price=$150.00, volume=50M"
4. **Given** multiple tools applicable, **When** Parlant evaluates, **Then** ranks by relevance: (1) Perplexity for research, (2) Alpha Vantage for stocks, (3) Code Sandbox for calculations

---

### User Story 4 - Canned Responses (Priority: P3)

As an agent encountering common scenarios (tool failure, clarification needed, agreement), I want Parlant to provide canned response templates so that standard interactions are handled efficiently.

**Why this priority**: Reduces latency for routine responses. Phase 2 optimization.

**Independent Test**: Tool fails, Parlant provides canned response: "Tool unavailable. Proceeding with reasoning: [agent fills reasoning]".

**Acceptance Scenarios**:

1. **Given** tool invocation fails, **When** Parlant detects failure, **Then** offers canned response: "Tool [name] unavailable. Proceeding with reasoning-based analysis."
2. **Given** agent needs clarification, **When** Parlant triggered, **Then** provides template: "To provide accurate analysis, I need clarification on: [agent fills question]"
3. **Given** agent agrees with prior point, **When** Parlant detects agreement, **Then** offers template: "I concur with Agent X's analysis of [point]. Building on this: [agent fills extension]"
4. **Given** canned response used, **When** logged, **Then** system tracks: template_id, customization_text, agent_id, timestamp

---

### Edge Cases

- What happens when **Parlant guideline conflicts with agent role**? System logs warning, prioritizes agent role over guideline, allows manual override.
- What happens when **journey template references unsupported phase**? System validates journey on load, rejects template with clear error: "Phase X not supported. Available: Independent, Opening, Debate, Convergence".
- What happens when **tool orchestration suggests tool not enabled**? Parlant skips suggestion, logs "tool_unavailable", provides next-best alternative.
- What happens when **canned response doesn't fit context**? Agent ignores canned option, generates custom response, system logs "template_rejected".
- What happens when **journey time limits cause frequent truncations**? System logs "excessive_truncations" metric, recommends increasing time limits in journey config.
- What happens when **Parlant service unavailable**? System falls back to non-Parlant operation (no guidelines, no orchestration), logs degraded mode.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST integrate Parlant framework for behavioral guidelines and journey templates
- **FR-002**: System MUST provide role-specific guidelines: Analyst (data-driven, citations, formal), Critic (challenge assumptions, skeptical), Researcher (evidence gathering), Synthesizer (integration, holistic view)
- **FR-003**: System MUST validate agent responses against guideline requirements (e.g., Analyst must include ≥1 citation)
- **FR-004**: System MUST support journey templates defining: turn order, time limits, phase transition rules, structural requirements
- **FR-005**: System MUST enforce journey turn order when template specifies sequence
- **FR-006**: System MUST truncate agent responses exceeding journey time limits and log "time_limit_exceeded" events
- **FR-007**: System MUST enable Parlant tool orchestration: suggest optimal tools for context, validate parameters, format results
- **FR-008**: System MUST rank tool suggestions by relevance: (1) Perplexity for research, (2) Alpha Vantage for finance, (3) Code Sandbox for computation
- **FR-009**: System MUST provide canned response templates for common scenarios: tool failure, clarification needed, agreement, disagreement
- **FR-010**: System MUST allow agents to accept, customize, or reject canned responses
- **FR-011**: System MUST log canned response usage: template_id, customizations, acceptance_rate, agent_id
- **FR-012**: System MUST fall back to non-Parlant operation if Parlant service unavailable
- **FR-013**: System MUST validate journey templates on load and reject unsupported configurations
- **FR-014**: System MUST prioritize agent role over conflicting Parlant guidelines
- **FR-015**: System MUST skip tool suggestions for disabled tools and provide alternatives

### Key Entities

- **Guideline**: Behavioral instruction with attributes: guideline_id, role_target (Analyst, Critic, Researcher, Synthesizer), instructions_text, validation_rules (e.g., citation_required=true), tone_specification (formal, collaborative)
- **JourneyTemplate**: Debate structure with attributes: template_name, turn_order (array of roles), time_limits (per-agent, per-phase), phase_transition_rules, structural_requirements (e.g., opening_statement_required)
- **ToolSuggestion**: Orchestration recommendation with attributes: tool_name, relevance_score (0-1), suggested_parameters, validation_schema, alternative_tools (array)
- **CannedResponse**: Template message with attributes: template_id, scenario_trigger (tool_failure, clarification, agreement), template_text (with placeholders), customization_fields (array), usage_count

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Role-specific guidelines improve response quality: Analyst responses include ≥1 citation in 90% of cases
- **SC-002**: Critic guideline adherence: 85% of Critic responses include assumption challenges
- **SC-003**: Journey templates enforce turn order correctly in 100% of structured debates
- **SC-004**: Time limit truncations occur in <15% of agent responses (indicating appropriate limit setting)
- **SC-005**: Tool orchestration suggestions accepted by agents in 70% of applicable scenarios
- **SC-006**: Tool parameter validation prevents invalid invocations in 95% of test cases
- **SC-007**: Canned responses used in 40% of common scenarios (tool failures, agreements)
- **SC-008**: Canned response customization rate: 60% of uses include agent modifications (showing flexibility)
- **SC-009**: Parlant service fallback maintains 90% functionality (only guideline/journey features disabled)
- **SC-010**: Journey template validation rejects invalid configs in 100% of malformed template tests
- **SC-011**: Guideline-role conflict resolution logs occur in <5% of agent responses (indicating good guideline design)
- **SC-012**: Tool suggestion ranking accuracy: top-ranked tool selected in 75% of cases when agent chooses tool
