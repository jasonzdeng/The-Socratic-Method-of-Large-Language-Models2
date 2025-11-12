# Feature Specification: User Interface

**Feature Branch**: `006-user-interface`  
**Created**: 2025-01-13  
**Status**: Draft  
**Input**: User description: "User Interface: Simple one-click + advanced config, SSE streaming, templates, export"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Simple One-Click Mode (Priority: P1)

As a casual user, I want to enter a question and click "Start Discussion" to immediately begin a debate with default settings (5 agents, 5 rounds) so that I can access the system without configuration complexity.

**Why this priority**: Primary entry point. MVP must demonstrate instant usability.

**Independent Test**: Enter question "Should we invest in renewable energy?", click Start, verify discussion initializes with 5 agents, 5 rounds, SSE streaming begins.

**Acceptance Scenarios**:

1. **Given** user on home screen, **When** enters question and clicks "Start Discussion", **Then** discussion initializes with defaults: 5 agents, 5 rounds, 50K budget
2. **Given** discussion starts, **When** agents respond, **Then** UI streams contributions in real-time via SSE without page refresh
3. **Given** discussion running, **When** user views progress, **Then** UI displays: current phase, round number, agent responses as they arrive
4. **Given** discussion completes, **When** summary generated, **Then** UI displays: executive summary, key insights, consensus breakdown, confidence scores

---

### User Story 2 - Advanced Configuration Mode (Priority: P2)

As a power user, I want to configure discussion parameters (agent count 3-10, rounds 2-10, provider selection, budget, consensus threshold) so that I can customize debates for specific scenarios.

**Why this priority**: Enables experimentation. Testable independently from simple mode.

**Independent Test**: Open advanced config, set 7 agents, 8 rounds, budget=100K, consensus=0.90, start discussion, verify parameters applied.

**Acceptance Scenarios**:

1. **Given** user toggles "Advanced Mode", **When** configuration panel opens, **Then** displays sliders: agents (3-10), rounds (2-10), budget (10K-unlimited), consensus (0.50-0.99)
2. **Given** user adjusts agent count to 7, **When** saves config, **Then** discussion initializes with 7 agents
3. **Given** user selects provider preferences (e.g., prioritize Claude), **When** agents initialize, **Then** agent pool reflects preferences
4. **Given** user sets custom consensus threshold 0.90, **When** debate evaluates, **Then** consensus termination requires 0.90 instead of default 0.85

---

### User Story 3 - SSE Real-Time Streaming (Priority: P1)

As a user watching a live discussion, I want agent contributions to stream in real-time via Server-Sent Events (SSE) so that I experience dynamic debate unfolding rather than waiting for batch completion.

**Why this priority**: Core UX differentiator. MVP must demonstrate live streaming.

**Independent Test**: Start discussion, monitor network tab for SSE connection, verify agent responses appear incrementally (<5s latency per contribution).

**Acceptance Scenarios**:

1. **Given** discussion starts, **When** first agent responds, **Then** UI receives SSE event and displays contribution within 5s
2. **Given** SSE connection established, **When** agent completes response, **Then** event payload includes: agent_id, role, response_text, timestamp
3. **Given** network interruption, **When** SSE disconnects, **Then** UI attempts reconnection with exponential backoff (2s, 4s, 8s)
4. **Given** discussion completes, **When** final verdict generated, **Then** SSE stream closes gracefully with "stream-end" event

---

### User Story 4 - Discussion Templates (Priority: P2)

As a user exploring use cases, I want to select pre-configured templates (Investment Analysis, Research Synthesis, Geopolitical Debate, Tech Trends) so that I can quickly start domain-specific discussions.

**Why this priority**: Accelerates adoption. Demonstrates versatility.

**Independent Test**: Select "Investment Analysis" template, verify UI pre-fills: topic prompt placeholder, prioritizes Alpha Vantage tool, sets 7 agents (2× Analyst role).

**Acceptance Scenarios**:

1. **Given** user clicks "Templates", **When** template gallery opens, **Then** displays: Investment, Research, Geopolitical, Tech with descriptions
2. **Given** user selects "Investment Analysis", **When** template loads, **Then** pre-configures: topic="[Stock ticker] analysis", tools=[Alpha Vantage, Perplexity], analyst_count=2
3. **Given** template loaded, **When** user edits parameters, **Then** changes persist (template provides starting point, not locked config)
4. **Given** user runs template discussion, **When** completes, **Then** export includes template name in metadata

---

### User Story 5 - Export Formats (Priority: P2)

As a user completing a discussion, I want to export results in PDF, Markdown, or JSON formats so that I can integrate insights into reports, documentation, or data pipelines.

**Why this priority**: Enables workflow integration. Independently testable.

**Independent Test**: Complete discussion, click "Export → PDF", verify download includes: title, executive summary, all agent responses, consensus breakdown, timestamps.

**Acceptance Scenarios**:

1. **Given** discussion completes, **When** user clicks "Export → PDF", **Then** generates PDF with sections: Summary, Agent Responses, Judge Scores, Consensus, Metadata
2. **Given** user selects "Export → Markdown", **When** file generated, **Then** includes: heading hierarchy, code blocks for JSON data, citation links
3. **Given** user selects "Export → JSON", **When** file generated, **Then** conforms to schema: discussion_id, agents[], rounds[], consensus, timestamps
4. **Given** export requested, **When** file generated, **Then** filename format: `debate_[topic-slug]_[timestamp].[ext]`

---

### Edge Cases

- What happens when **SSE connection fails during discussion**? UI displays reconnection indicator, buffers missed events, backfills when reconnected.
- What happens when **user navigates away mid-discussion**? Discussion continues server-side, UI provides "Resume Discussion" option on return.
- What happens when **export file size >100MB** (very long debate)? System warns user, offers: (1) summary-only export, (2) chunked exports, (3) proceed anyway.
- What happens when **template parameters conflict** (e.g., 10 agents but only 2 providers enabled)? UI validates on template load, displays warning, adjusts to minimum viable config.
- What happens when **browser doesn't support SSE** (old IE)? UI falls back to polling every 5s, displays "limited real-time support" notice.
- What happens when **user clicks Start without entering topic**? UI blocks submission, displays: "Please enter a discussion topic" error.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide Simple Mode: single-click start with defaults (5 agents, 5 rounds, 50K budget, consensus=0.85)
- **FR-002**: System MUST provide Advanced Mode: configurable agents (3-10), rounds (2-10), budget (10K-unlimited), consensus (0.50-0.99)
- **FR-003**: System MUST stream agent contributions in real-time via Server-Sent Events (SSE)
- **FR-004**: System MUST deliver SSE events within 5s of agent response completion
- **FR-005**: System MUST include in SSE payload: agent_id, role, response_text, timestamp, round_number
- **FR-006**: System MUST implement SSE reconnection with exponential backoff (2s, 4s, 8s) on disconnection
- **FR-007**: System MUST provide 4 discussion templates: Investment Analysis, Research Synthesis, Geopolitical Debate, Tech Trends
- **FR-008**: System MUST pre-configure templates with: topic placeholder, tool priorities, role distribution, agent count
- **FR-009**: System MUST allow users to edit template parameters before starting discussion
- **FR-010**: System MUST support 3 export formats: PDF, Markdown, JSON
- **FR-011**: System MUST include in exports: executive summary, all agent responses, judge scores, consensus breakdown, metadata (timestamps, config)
- **FR-012**: System MUST generate export filenames: `debate_[topic-slug]_[timestamp].[ext]`
- **FR-013**: System MUST validate topic input before allowing discussion start (non-empty, 10-500 chars)
- **FR-014**: System MUST display real-time progress indicators: current phase, round number, active agents
- **FR-015**: System MUST show confidence scores in final summary (per agent, per dimension)
- **FR-016**: System MUST enable "Resume Discussion" if user navigates away mid-debate
- **FR-017**: System MUST validate template parameters and adjust to minimum viable config if conflicts detected
- **FR-018**: System MUST fall back to 5s polling if browser doesn't support SSE
- **FR-019**: System MUST warn users when export size >100MB and offer summary-only or chunked alternatives
- **FR-020**: System MUST persist discussion state to allow pausing/resuming

### Key Entities

- **UIMode**: Interface configuration with attributes: mode_type (enum: simple, advanced), default_config (agents=5, rounds=5, budget=50K), customizations_enabled (boolean)
- **Template**: Pre-configured scenario with attributes: template_name (Investment, Research, Geopolitical, Tech), topic_placeholder, tool_priorities (array), role_distribution (object), agent_count (int)
- **SSEStream**: Real-time data channel with attributes: connection_id, discussion_id, event_types (agent_response, judge_score, phase_transition), reconnection_attempts, backoff_interval
- **ExportFormat**: Output specification with attributes: format_type (PDF, Markdown, JSON), schema_version, include_sections (array: summary, responses, scores, consensus, metadata), file_size_limit (100MB)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Simple Mode enables 90% of users to start discussion within 30 seconds of landing on page
- **SC-002**: SSE streaming delivers agent contributions with <5s latency in 95% of events under normal network conditions
- **SC-003**: Advanced Mode parameter validation rejects invalid configs in 100% of test cases (e.g., max_rounds<min_rounds)
- **SC-004**: Discussion templates reduce configuration time by 60% compared to manual setup (measured: template <10s vs manual ~25s)
- **SC-005**: Export generation completes within 10s for discussions <1000 rounds
- **SC-006**: PDF exports render correctly across 95% of PDF readers (Adobe, browser native, iOS Preview)
- **SC-007**: JSON exports validate against schema in 100% of test cases
- **SC-008**: SSE reconnection succeeds in 85% of network interruption scenarios
- **SC-009**: UI displays real-time progress with <2s lag between server state and UI state
- **SC-010**: "Resume Discussion" functionality successfully restores state in 95% of navigation-away scenarios
- **SC-011**: Template parameter conflicts resolved automatically in 100% of cases without discussion failure
- **SC-012**: Browser fallback (polling) provides acceptable UX in ≥90% of non-SSE environments (user surveys: >3/5 rating)
