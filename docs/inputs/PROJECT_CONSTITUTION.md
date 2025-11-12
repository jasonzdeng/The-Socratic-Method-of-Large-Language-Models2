# Project Constitution
## Socratic LLM Discussion Forum

Use this with SpecKit's `/constitute` command to seed project rules and standards.

---

## Project Identity

**Name:** Socratic LLM Discussion Forum
**Repository:** The-Socratic-Method-of-Large-Language-Models2
**Type:** Multi-agent AI platform for structured debate
**Target Launch:** 20 weeks from kickoff

---

## Technology Stack (Pinned Versions)

### Backend
- **Language:** Python 3.11+
- **Framework:** FastAPI 0.104+
- **Agent Orchestration:** LangGraph 0.2+ or AutoGen 0.2+
- **LLM Abstraction:** LiteLLM 1.40+
- **Async:** asyncio, aiohttp 3.9+

### Frontend
- **Language:** TypeScript 5.3+
- **Runtime:** Node.js 20 LTS
- **Framework:** Next.js 14.2+ (App Router)
- **UI Library:** React 18.2+
- **UI Components:** shadcn/ui + Tailwind CSS 3.4+
- **State:** Zustand 4.5+ or Jotai 2.6+

### Data & Storage
- **Primary Database:** PostgreSQL 15+
- **Cache:** Redis 7.2+
- **Vector Store:** Pinecone or Weaviate (latest stable)
- **Object Storage:** S3-compatible

### Infrastructure
- **Containers:** Docker 24+, Docker Compose 2.24+
- **Orchestration:** Kubernetes 1.28+ or AWS ECS
- **CI/CD:** GitHub Actions
- **IaC:** Terraform 1.6+ or Pulumi 3.100+
- **Monitoring:** Datadog or Prometheus + Grafana

---

## Code Quality Standards

### Python
- **Formatter:** Black (line-length: 100)
- **Linter:** Ruff (select: E, F, I, N, W)
- **Type Checking:** mypy (strict mode)
- **Import Sorting:** isort (compatible with Black)

### TypeScript
- **Formatter:** Prettier (semi: true, singleQuote: true, trailingComma: 'es5')
- **Linter:** ESLint (extends: next/core-web-vitals, typescript-recommended)
- **Type Checking:** TypeScript strict mode enabled

### Pre-commit Hooks
```yaml
repos:
  - repo: local
    hooks:
      - id: black
      - id: ruff
      - id: mypy
      - id: prettier
      - id: eslint
```

---

## Test Coverage Requirements

### Minimum Thresholds
- **Unit Tests:** 80% coverage
- **Integration Tests:** 70% coverage
- **E2E Tests:** 5-10 critical user flows

### Test Structure
```
tests/
├── unit/              # Fast, isolated tests
├── integration/       # Component integration tests
├── e2e/              # Full user flow tests
└── fixtures/         # Test data and mocks
```

### Test Commands
```bash
# Python
pytest --cov=src --cov-report=html --cov-fail-under=80

# TypeScript
npm test -- --coverage --coverageThreshold='{"global":{"statements":80}}'
```

---

## Git Branch Policy

### Branch Naming Convention
```
<type>/<description>
```

**Types:**
- `feature/*` - New features
- `fix/*` - Bug fixes
- `refactor/*` - Code refactoring
- `docs/*` - Documentation only
- `test/*` - Test additions/changes
- `chore/*` - Maintenance tasks

**Examples:**
- `feature/agent-runtime`
- `fix/consensus-calculation`
- `refactor/llm-abstraction`

### Branch Protection (main/master)
- ✅ Require pull request reviews (minimum 1)
- ✅ Require status checks to pass
  - All tests passing
  - Linting passing
  - Coverage thresholds met
- ✅ Require branches to be up to date
- ✅ Require linear history (squash or rebase)
- ❌ No direct pushes to main
- ❌ No force pushes

### Development Branches
- `develop` - Integration branch for features
- `staging` - Pre-production testing
- `main/master` - Production-ready code

---

## Documentation Requirements

### Required Documentation
Every feature must include:
1. **Inline Code Documentation**
   - All public functions/methods documented
   - Docstrings following conventions:
     - Python: Google-style docstrings
     - TypeScript: TSDoc comments

2. **README Files**
   - Root README.md
   - Module/component READMEs for complex subsystems
   - API documentation (OpenAPI/Swagger for REST)

3. **Architecture Decision Records (ADRs)**
   - Store in `docs/adr/`
   - Use template: Context, Decision, Consequences
   - Required for: LLM provider choices, database design, security decisions

4. **Changelog**
   - Maintain CHANGELOG.md
   - Follow Keep a Changelog format
   - Update with every release

### Documentation Standards
- **Format:** Markdown
- **Diagrams:** Mermaid or PlantUML
- **API Specs:** OpenAPI 3.1
- **Code Examples:** Must be executable and tested

---

## Security & Privacy

### Security Standards

#### API Keys & Secrets
- ✅ Use environment variables (never commit secrets)
- ✅ Store in AWS Secrets Manager / HashiCorp Vault
- ✅ Rotate API keys quarterly
- ✅ Audit secret access monthly

#### Authentication & Authorization
- ✅ JWT tokens with 1-hour expiry
- ✅ Refresh tokens stored securely (HTTP-only cookies)
- ✅ Rate limiting: 100 requests/minute per user
- ✅ RBAC (Role-Based Access Control) for admin features

#### Input Validation
- ✅ Sanitize all user inputs
- ✅ Parameterized database queries (prevent SQL injection)
- ✅ Prompt injection detection for LLM inputs
- ✅ File upload restrictions (type, size limits)

#### Security Headers
```
Strict-Transport-Security: max-age=31536000
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src 'self'
```

#### Dependency Management
- ✅ Automated dependency scanning (Dependabot, Snyk)
- ✅ Update dependencies monthly
- ✅ Pin exact versions in production
- ✅ Security audit before every release

### Privacy Standards

#### Data Handling
- ✅ GDPR compliant (EU users)
- ✅ CCPA compliant (California users)
- ✅ Data retention: 90 days for discussions (configurable)
- ✅ User data export available on request
- ✅ Right to deletion ("forget me")

#### PII Protection
- ✅ Encrypt PII at rest (AES-256)
- ✅ Encrypt in transit (TLS 1.3)
- ✅ Anonymize logs (no PII in logs)
- ✅ Minimize data collection (only necessary fields)

#### LLM Provider Data Sharing
- ✅ Disclose data sent to LLM providers
- ✅ Use zero-retention API options where available
- ✅ User consent for data processing
- ✅ Comply with provider terms of service

#### Audit Logging
- ✅ Log all authentication events
- ✅ Log data access and modifications
- ✅ Retain audit logs for 1 year
- ✅ Automated anomaly detection

---

## Code Review Standards

### Review Checklist
Every PR must verify:
- [ ] Code follows style guide (linter passes)
- [ ] Tests added/updated (coverage maintained)
- [ ] Documentation updated
- [ ] No hardcoded secrets
- [ ] Error handling present
- [ ] Performance implications considered
- [ ] Security implications reviewed
- [ ] Breaking changes documented

### Review Process
1. **Self-review:** Author reviews own PR first
2. **Peer review:** Minimum 1 approval required
3. **CI checks:** All automated checks pass
4. **Merge:** Squash and merge preferred

### Review Response Time
- Critical bugs: <4 hours
- Features: <24 hours
- Documentation: <48 hours

---

## Performance Standards

### API Response Times (p95)
- Simple queries: <200ms
- Agent contributions: <10s
- Full discussion round: <90s
- Total discussion: <10 minutes

### Database Query Limits
- Maximum query time: 1s
- N+1 queries: Not allowed (use eager loading)
- Index all foreign keys
- Explain plans required for complex queries

### Frontend Performance
- Lighthouse score: >90
- First Contentful Paint: <1.5s
- Time to Interactive: <3s
- Cumulative Layout Shift: <0.1

---

## Error Handling Standards

### Error Categories
1. **User Errors** (4xx)
   - Return helpful error messages
   - Include suggestion for correction
   - Log at INFO level

2. **System Errors** (5xx)
   - Generic message to user
   - Detailed logging for debugging
   - Alert on-call engineer
   - Log at ERROR level

3. **External Service Errors**
   - Retry with exponential backoff (3 attempts)
   - Fallback to alternative service
   - Graceful degradation
   - Log at WARN level

### Error Response Format
```json
{
  "error": {
    "code": "CONSENSUS_TIMEOUT",
    "message": "Discussion did not reach consensus within maximum rounds",
    "details": {
      "max_rounds": 10,
      "completed_rounds": 10,
      "consensus_level": 0.65
    },
    "suggestion": "Try reducing the scope of the question or increasing max rounds"
  }
}
```

---

## Logging Standards

### Log Levels
- **DEBUG:** Development only, verbose details
- **INFO:** Normal operations, user actions
- **WARN:** Degraded service, recoverable errors
- **ERROR:** Operation failures, requires attention
- **CRITICAL:** System failures, immediate action needed

### Structured Logging
```json
{
  "timestamp": "2025-11-12T10:30:00Z",
  "level": "INFO",
  "service": "agent-orchestrator",
  "message": "Discussion round completed",
  "context": {
    "discussion_id": "uuid",
    "round": 3,
    "agents": 5,
    "duration_ms": 45000
  }
}
```

### Log Retention
- Production: 30 days
- Staging: 14 days
- Development: 7 days
- Audit logs: 1 year

---

## Monitoring & Alerting

### Key Metrics
- **Availability:** Uptime >99.9%
- **Error Rate:** <1% of requests
- **Response Time:** p95 <90s for discussions
- **LLM API Success Rate:** >95%
- **Tool Call Success Rate:** >90%

### Alerts
- Critical: Page on-call engineer
- High: Slack notification
- Medium: Email
- Low: Dashboard only

### Health Checks
```
/health          - Simple alive check
/health/ready    - Ready to serve traffic
/health/live     - Container liveness
```

---

## Deployment Standards

### Environment Parity
- Development, Staging, Production should be identical
- Use same Docker images across environments
- Environment-specific: configurations only (env vars)

### Deployment Process
1. **Build:** CI builds and tests
2. **Tag:** Semantic versioning (v1.2.3)
3. **Deploy to Staging:** Automated
4. **Smoke Tests:** Run critical paths
5. **Deploy to Production:** Manual approval
6. **Monitor:** Watch metrics for 1 hour

### Rollback Plan
- Must be possible within 5 minutes
- Keep previous 3 releases available
- Automated rollback on error spike

### Zero-Downtime Deployments
- Use rolling updates (Kubernetes)
- Or blue-green deployments
- Database migrations backward compatible

---

## API Design Standards

### RESTful Conventions
- Use standard HTTP methods: GET, POST, PUT, PATCH, DELETE
- Resource-oriented URLs: `/discussions/{id}/rounds/{round}`
- Plural nouns: `/discussions` not `/discussion`
- Versioning: `/api/v1/discussions`

### Request/Response Format
- Content-Type: `application/json`
- Date format: ISO 8601
- Pagination: `limit` and `offset` parameters
- Filtering: Query parameters
- Sorting: `sort=created_at:desc`

### API Documentation
- OpenAPI 3.1 specification
- Interactive docs at `/api/docs`
- Examples for every endpoint
- Error scenarios documented

---

## LLM API Usage Standards

### Cost Control
- Token budget per agent: 2,000 tokens/contribution
- Discussion budget: 50,000 tokens total
- User quotas: Configurable per tier
- Monthly spending alerts: >$10k

### Provider Diversity
- Never rely on single provider
- Implement fallback providers
- Monitor provider health
- Track cost per provider

### Prompt Management
- Store prompts in code (not database)
- Version control all prompts
- A/B test prompt variations
- Log prompt performance metrics

### Tool Calling
- Explain before calling (reasoning)
- Validate all parameters
- Timeout after 30s
- Retry failed calls (max 2 attempts)

---

## Dependency Management

### Backend (Python)
```
# requirements.txt - Direct dependencies
# requirements-dev.txt - Dev dependencies
# requirements-lock.txt - Pinned (pip freeze)
```

### Frontend (TypeScript)
```
# package.json - Direct dependencies
# package-lock.json - Lock file (committed)
```

### Update Policy
- Security patches: Immediate
- Minor updates: Monthly
- Major updates: Quarterly (with testing)
- Pre-release: Never in production

---

## Out of Scope (Explicitly)

The following are **NOT** in scope for the initial release:

### Features
- ❌ Mobile native apps (iOS/Android)
- ❌ Video/audio input/output
- ❌ Real-time collaboration (multiple users in one discussion)
- ❌ Custom LLM fine-tuning
- ❌ On-premise deployment
- ❌ Blockchain/NFT integration
- ❌ Social features (likes, comments, followers)
- ❌ Discussion replay with different settings
- ❌ Export to formats other than PDF, Markdown, JSON

### Integrations
- ❌ Slack/Teams bots (post-MVP)
- ❌ Browser extensions
- ❌ API for external developers (post-launch)
- ❌ Zapier/IFTTT integration
- ❌ CRM integrations (Salesforce, HubSpot)

### Technical
- ❌ Multi-tenancy (each customer isolated DB)
- ❌ White-label solutions
- ❌ Custom domain hosting
- ❌ SSO (SAML, OAuth providers)
- ❌ Offline mode
- ❌ Desktop applications

### Geographic
- ❌ Non-English language support (MVP is English-only)
- ❌ Regional compliance (GDPR/CCPA only)
- ❌ Data residency requirements

---

## Constraints

### Technical Constraints
- **Latency:** LLM API calls are inherently slow (3-10s per call)
- **Cost:** LLM APIs expensive at scale (requires token budgets)
- **Rate Limits:** All LLM providers have rate limits
- **Context Windows:** Limited by smallest model (8K-200K tokens)
- **Tool Reliability:** External APIs may fail or be slow

### Business Constraints
- **Budget:** $50k for 20-week development + infrastructure
- **Team Size:** Maximum 7 people (4-6 engineers + PM + designer)
- **Timeline:** 20 weeks to beta launch (non-negotiable)
- **API Costs:** Must stay under $15k/month during beta

### Legal Constraints
- **LLM Provider ToS:** Must comply with all provider terms
- **Data Privacy:** GDPR and CCPA compliance required
- **Content Policy:** Must moderate harmful content
- **Liability:** Disclaimer for AI-generated content

### User Constraints
- **Expertise:** Users must understand complex topics (not for novices)
- **Time:** Discussions take 5-15 minutes (not instant)
- **Cost:** Premium feature, not free-tier friendly at scale

---

## Project Communication

### Channels
- **Slack:** #socratic-llm-dev (development), #socratic-llm-alerts (monitoring)
- **Email:** team@socratic-llm.ai
- **Wiki:** Confluence or Notion for design docs
- **Tickets:** GitHub Issues, Linear, or Jira

### Meetings
- **Daily Standups:** 15 min, 9:30 AM
- **Sprint Planning:** Monday, 2 hours
- **Sprint Review:** Friday, 1 hour
- **Retrospective:** Friday, 30 min

### Status Updates
- Weekly update email to stakeholders
- Monthly all-hands demo
- Quarterly roadmap review

---

## Incident Response

### Severity Levels
- **P0 (Critical):** Service down, data loss - Resolve in 1 hour
- **P1 (High):** Major feature broken - Resolve in 4 hours
- **P2 (Medium):** Minor feature broken - Resolve in 24 hours
- **P3 (Low):** Cosmetic issue - Resolve in 1 week

### On-Call Rotation
- 1 week rotations
- Compensation: Time off or additional pay
- Maximum 2 pages per week (otherwise add capacity)

### Post-Mortem
Required for P0 and P1 incidents:
- Root cause analysis
- Timeline of events
- Action items (prevent recurrence)
- Blameless culture

---

## Licensing

### Project License
- **Code:** MIT License (open source)
- **Documentation:** CC BY 4.0

### Dependencies
- Audit all dependency licenses
- Avoid GPL (copyleft) dependencies
- Prefer MIT, Apache 2.0, BSD

### LLM Provider Licenses
- Comply with all API terms of service
- Commercial use allowed for all providers
- User data handling per provider policies

---

## Success Criteria for Constitution

This constitution is successful if:
- ✅ All team members understand and follow standards
- ✅ Code reviews reference constitution requirements
- ✅ Automated checks enforce standards (CI)
- ✅ New team members onboarded with constitution
- ✅ Constitution updated quarterly based on learnings

---

**Last Updated:** 2025-11-12
**Version:** 1.0
**Owner:** Engineering Lead

Use this document with:
```bash
/constitute docs/inputs/PROJECT_CONSTITUTION.md
```
