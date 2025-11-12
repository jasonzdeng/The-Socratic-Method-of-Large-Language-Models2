<!--
SYNC IMPACT REPORT
==================
Version Change: 0.0.0 → 1.0.0
Change Type: MAJOR (Initial constitution establishment)

Modified Principles:
- NEW: I. Local-First Architecture
- NEW: II. Multi-Agent Rigor
- NEW: III. Quality-First Development (NON-NEGOTIABLE)
- NEW: IV. Evidence-Based Decision Making
- NEW: V. Privacy & Security by Default

Added Sections:
- Core Principles (5 principles)
- Technology Standards
- Quality Gates
- Out of Scope
- Governance

Templates Status:
✅ plan-template.md - Aligned with phased approach and test requirements
✅ spec-template.md - Aligned with feature structure and acceptance criteria
✅ tasks-template.md - Aligned with test-first and quality gates
⚠ agent-file-template.md - Review for multi-agent context
⚠ checklist-template.md - Review for local-first constraints

Follow-up TODOs:
- None (initial version complete)

Rationale for MAJOR v1.0.0:
- First formal constitution establishing foundational governance
- Defines all core principles and non-negotiable practices
- Sets baseline for future amendments
-->

# Socratic LLM Forum Constitution

## Core Principles

### I. Local-First Architecture

**All development MUST prioritize local-only deployment and execution.**

- No external hosting or cloud dependencies in MVP
- All API keys stored in `.env` and loaded at runtime
- No third-party data sharing or telemetry
- Development and runtime environments must function without internet connectivity (except for LLM API calls)
- Database and caching must be local (PostgreSQL, Redis on localhost)

**Rationale:** Ensures user privacy, data sovereignty, and eliminates infrastructure complexity during development. Enables rapid iteration without deployment concerns.

### II. Multi-Agent Rigor

**The system MUST implement structured multi-agent debate with measurable quality.**

- Minimum 3 LLM providers per discussion (diversity requirement)
- Socratic Method implementation: questions, challenges, evidence citations, position updates
- Judge panel with CARE aggregation (correlation-aware ranking ensemble)
- Consensus target: >70% of discussions reach >80% agreement
- Tool integration: >60% of discussions must use external data sources
- Provider fallbacks mandatory (never rely on single LLM provider)

**Rationale:** Multi-perspective analysis with structured critique produces more rigorous, evidence-based conclusions than single-LLM responses. Measurable targets ensure system effectiveness.

### III. Quality-First Development (NON-NEGOTIABLE)

**Test coverage and code quality standards are strictly enforced before any feature is considered complete.**

- **Test-First:** Unit tests written and reviewed BEFORE implementation begins
- **Coverage Gates:**
  - Unit tests: >80% required (`pytest --cov-fail-under=80`)
  - Integration tests: >70% required
  - E2E tests: 10 critical flows minimum
- **Code Standards:**
  - Python: Black (line length 100), Ruff linting, mypy strict mode, isort
  - TypeScript: Prettier, ESLint (next/core-web-vitals), strict mode
  - Pre-commit hooks: ruff, mypy, prettier, eslint (or manual script if installation blocked)
- **No Exceptions:** Features without adequate tests are incomplete and MUST NOT be merged

**Rationale:** High test coverage catches bugs early, enables confident refactoring, and serves as living documentation. Strict standards prevent technical debt accumulation.

### IV. Evidence-Based Decision Making

**All agent contributions and system outputs MUST be grounded in verifiable evidence.**

- Citations required for factual claims
- Tool usage tracked and validated (30s timeout, 2× retry)
- Source transparency: all evidence accessible in discussion workspace
- Confidence quantification: agents must update positions when presented stronger evidence
- Structured logging for debuggability and audit trails

**Rationale:** Evidence requirements prevent hallucination propagation and ensure discussion quality. Transparency builds trust and enables validation.

### V. Privacy & Security by Default

**The system MUST NOT expose user data or enable unauthorized access.**

- Localhost only: no external network exposure (no public endpoints in MVP)
- Input sanitization: prompt injection detection and blocking mandatory
- Dependency scanning: automated vulnerability checks (Dependabot, Snyk)
- Error handling: 4xx → INFO (helpful), 5xx → ERROR (log + alert), External → WARN (retry 3×)
- Incident response: P0/P1 require post-mortems

**Rationale:** Local-first architecture reduces attack surface. Security by default protects users and prevents data leaks even during development.

## Technology Standards

**Backend:**
- Python 3.11+ with FastAPI
- LiteLLM (unified LLM interface across providers)
- Parlant framework (agent guidelines and journeys)
- PostgreSQL 15+, Redis 7.2+, Vector DB (Pinecone/Weaviate)
- Docker containers for services
- Environment: uv for Python dependency management

**Frontend:**
- Next.js 14+ (TypeScript)
- React 18 + shadcn/ui components
- Tailwind CSS
- Server-Sent Events (SSE) for real-time streaming

**Testing:**
- pytest (unit and integration)
- Playwright (E2E)
- pytest-cov (coverage tracking)

**Development:**
- Git with conventional commits
- CI/CD via GitHub Actions
- Pre-commit hooks (or manual checks: `.\scripts\pre-commit-manual.ps1`)

## Quality Gates

**Before any PR is merged:**

1. **Code Quality**
   - Ruff linting passes with no errors
   - Ruff formatting applied (line length 100)
   - mypy strict type checking passes
   - No commented-out code or TODO markers without issue references

2. **Testing**
   - Unit test coverage >80%
   - Integration test coverage >70%
   - All tests pass locally
   - New features include tests (test-first)

3. **Documentation**
   - Public APIs documented with docstrings
   - README updated if user-facing changes
   - DEVELOPMENT.md updated if dev process changes

4. **Review**
   - Code reviewed by at least one other developer
   - Constitutional compliance verified (checklist in PR template)
   - Performance implications assessed (no regressions)

## Out of Scope

**The following are explicitly excluded from the MVP and early phases:**

**Features:**
- Mobile applications (iOS, Android)
- Video/audio I/O processing
- Multi-user real-time collaboration
- Custom LLM training or fine-tuning
- Social features (sharing, comments, likes)
- Non-English language support (internationalization deferred)

**Integrations:**
- Slack/Teams/Discord bots
- Browser extensions
- Developer API (public)
- CRM integrations
- Enterprise SSO

**Technical:**
- Multi-tenancy (single-user local deployment only)
- White-label/rebrandable versions
- Offline mode (requires internet for LLM APIs)
- Cloud hosting or managed services (MVP is local-only)

**Rationale:** Maintaining tight scope prevents feature creep and enables faster delivery of core multi-agent debate functionality. Post-MVP phases can revisit these items.

## Governance

### Amendment Process

1. **Proposal:** Any team member may propose constitutional amendments via issue or discussion
2. **Review:** Proposed changes reviewed by project lead and core team
3. **Impact Assessment:** Evaluate impact on existing code, templates, and workflows
4. **Documentation:** Update constitution with rationale and version bump
5. **Propagation:** Update all dependent templates and documentation
6. **Announcement:** Communicate changes to all contributors

### Versioning Policy

**Constitution uses semantic versioning (MAJOR.MINOR.PATCH):**

- **MAJOR:** Backward-incompatible governance changes, principle removals, or redefinitions that require code changes
- **MINOR:** New principles added, sections materially expanded, new constraints introduced
- **PATCH:** Clarifications, wording improvements, typo fixes, non-semantic refinements

### Compliance Review

- **All PRs:** Reviewers must verify constitutional compliance using PR checklist
- **Weekly:** Team reviews any constitutional tensions or ambiguities
- **Quarterly:** Full constitutional review to ensure alignment with project evolution

### Conflict Resolution

If code/feature conflicts with constitution:
1. Constitution takes precedence by default
2. If exception justified, propose constitutional amendment first
3. Emergency exceptions require project lead approval + immediate amendment proposal

### Living Document

This constitution is a living document. As the project evolves:
- Ambiguities must be clarified (PATCH updates)
- New principles may be added (MINOR updates)
- Fundamental changes require team consensus (MAJOR updates)

**For runtime development guidance, refer to `DEVELOPMENT.md` and phase-specific documentation in `docs/inputs/WORKPLAN.md`.**

---

**Version**: 1.0.0 | **Ratified**: 2025-11-12 | **Last Amended**: 2025-11-12
