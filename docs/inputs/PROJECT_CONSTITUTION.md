# Project Constitution
**Use with:** `/constitute docs/inputs/PROJECT_CONSTITUTION.md`

---

## Stack (Pinned Versions)

| Component | Version | Notes |
|-----------|---------|-------|
| **Python** | 3.11+ | Backend language |
| **TypeScript** | 5.3+ | Frontend language |
| **FastAPI** | 0.104+ | API framework |
| **Next.js** | 14.2+ | Frontend (App Router) |
| **React** | 18.2+ | UI library |
| **Node.js** | 20 LTS | Runtime |
| **PostgreSQL** | 15+ | Primary DB |
| **Redis** | 7.2+ | Cache |
| **LiteLLM** | 1.40+ | LLM abstraction |
| **LangGraph** | 0.2+ | Agent orchestration |
| **Docker** | 24+ | Containers |
| **Kubernetes** | 1.28+ | Orchestration |
| **Terraform** | 1.6+ | IaC |

---

## Code Standards

### Python
```yaml
Formatter: Black (line-length: 100)
Linter: Ruff (select: E, F, I, N, W)
Type Checker: mypy (strict mode)
Import Sort: isort (Black-compatible)
```

### TypeScript
```yaml
Formatter: Prettier (semi: true, singleQuote: true)
Linter: ESLint (next/core-web-vitals, typescript-recommended)
Type Checker: TypeScript strict mode
```

### Pre-commit Hooks
Required: black, ruff, mypy, prettier, eslint

---

## Test Requirements

| Type | Coverage | Scope |
|------|----------|-------|
| **Unit** | >80% | All logic, isolated |
| **Integration** | >70% | Component interactions |
| **E2E** | 10 flows | Critical user paths |

**Commands:**
```bash
# Python
pytest --cov=src --cov-fail-under=80

# TypeScript
npm test -- --coverage --coverageThreshold='{"global":{"statements":80}}'
```

---

## Git Policy

### Branch Naming
`<type>/<description>` where type = feature | fix | refactor | docs | test | chore

### Branch Protection (main)
- ✅ Require PR review (min 1)
- ✅ Require status checks pass
- ✅ Require up-to-date branches
- ✅ Require linear history
- ❌ No direct push
- ❌ No force push

### Workflow
develop → staging → main

---

## Documentation

### Required
1. **Inline:** All public functions (Python: Google-style, TS: TSDoc)
2. **READMEs:** Root + complex modules
3. **ADRs:** `docs/adr/` for major decisions
4. **Changelog:** CHANGELOG.md (Keep a Changelog format)
5. **API Specs:** OpenAPI 3.1

---

## Security

### Secrets
- ✅ Environment variables only
- ✅ AWS Secrets Manager / Vault
- ✅ Rotate quarterly
- ❌ Never commit

### Authentication
- JWT (1-hour expiry)
- Refresh tokens (HTTP-only cookies)
- Rate limit: 100 req/min per user

### Input Validation
- Sanitize all user inputs
- Parameterized queries (SQL injection prevention)
- Prompt injection detection
- File upload restrictions

### Headers
```
Strict-Transport-Security: max-age=31536000
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Content-Security-Policy: default-src 'self'
```

### Dependencies
- Automated scanning (Dependabot, Snyk)
- Update monthly
- Pin versions in production
- Security audit pre-release

---

## Privacy

### Compliance
- ✅ GDPR (EU)
- ✅ CCPA (California)
- Data retention: 90 days
- User data export available
- Right to deletion

### Protection
- Encrypt PII: AES-256 (rest), TLS 1.3 (transit)
- Anonymize logs (no PII)
- Minimize collection
- LLM provider data disclosure
- User consent required

### Audit
- Log auth events
- Log data access/modifications
- Retain logs: 1 year
- Automated anomaly detection

---

## Performance

### Targets (p95)
- Simple API: <200ms
- Agent contribution: <10s
- Discussion round: <90s
- Total discussion: <10 min
- Lighthouse: >90
- FCP: <1.5s, TTI: <3s, CLS: <0.1

### Database
- Max query: 1s
- No N+1 queries
- Index all FKs
- Explain plans required

---

## Error Handling

### Categories
| Code | Level | Action |
|------|-------|--------|
| **4xx** | INFO | Helpful message + suggestion |
| **5xx** | ERROR | Generic message + detailed log + alert |
| **External** | WARN | Retry (3×), fallback, degrade |

### Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "User-friendly message",
    "details": {},
    "suggestion": "How to fix"
  }
}
```

---

## Logging

### Levels
DEBUG (dev only) | INFO (ops) | WARN (degraded) | ERROR (failure) | CRITICAL (system down)

### Structured Format
```json
{
  "timestamp": "ISO8601",
  "level": "INFO",
  "service": "name",
  "message": "text",
  "context": {}
}
```

### Retention
- Production: 30 days
- Staging: 14 days
- Dev: 7 days
- Audit: 1 year

---

## Monitoring

### Metrics
- Uptime: >99.9%
- Error rate: <1%
- Response time (p95): <90s
- LLM API success: >95%
- Tool success: >90%

### Alerts
- **Critical:** Page on-call
- **High:** Slack
- **Medium:** Email
- **Low:** Dashboard only

### Health Checks
- `/health` - alive
- `/health/ready` - ready for traffic
- `/health/live` - container liveness

---

## Deployment

### Process
Build → Tag (semver) → Deploy Staging → Smoke Tests → Deploy Prod (manual) → Monitor (1 hour)

### Requirements
- Zero-downtime (rolling/blue-green)
- Rollback: <5 min
- Keep 3 previous releases
- DB migrations backward-compatible

---

## API Standards

### REST
- Methods: GET, POST, PUT, PATCH, DELETE
- URLs: `/api/v1/resource/{id}`
- Format: JSON, ISO 8601 dates
- Pagination: `limit`, `offset`
- Sort: `sort=field:desc`

### Documentation
- OpenAPI 3.1 spec
- Interactive docs: `/api/docs`
- Examples for all endpoints

---

## LLM Usage

### Cost Control
- Token budget: 2K/contribution, 50K/discussion
- User quotas per tier
- Monthly alerts: >$10k

### Providers
- Never single provider
- Implement fallbacks
- Monitor health
- Track cost per provider

### Prompts
- Version control all prompts
- A/B test variations
- Log performance

### Tools
- Explain before calling
- Validate parameters
- Timeout: 30s
- Retry: max 2×

---

## Explicitly Out of Scope

### Features
- ❌ Mobile native apps
- ❌ Video/audio I/O
- ❌ Real-time multi-user collaboration
- ❌ Custom LLM fine-tuning
- ❌ On-premise deployment
- ❌ Social features
- ❌ Discussion replay/branching
- ❌ Non-PDF/Markdown/JSON exports

### Integrations
- ❌ Slack/Teams bots
- ❌ Browser extensions
- ❌ Developer API (post-MVP)
- ❌ CRM integrations

### Technical
- ❌ Multi-tenancy
- ❌ White-label
- ❌ Custom domains
- ❌ SSO
- ❌ Offline mode

### Geographic
- ❌ Non-English languages (MVP)
- ❌ Data residency (beyond GDPR/CCPA)

---

## Constraints

### Technical
- LLM latency: 3-10s per call (unavoidable)
- Cost: LLM APIs expensive (require budgets)
- Rate limits: All providers limited
- Context windows: 8K-200K tokens

### Business
- Budget: $50k dev + $15k/month infra (beta)
- Team: Max 7 people
- Timeline: 20 weeks (fixed)
- API costs: <$15k/month in beta

### Legal
- Comply with LLM provider ToS
- GDPR/CCPA required
- Content moderation required
- AI-generated content disclaimer

---

## Incident Response

| Severity | SLA | Action |
|----------|-----|--------|
| **P0** | 1 hour | Service down, data loss |
| **P1** | 4 hours | Major feature broken |
| **P2** | 24 hours | Minor feature broken |
| **P3** | 1 week | Cosmetic issue |

### Post-Mortem (P0/P1)
- Root cause analysis
- Timeline
- Action items
- Blameless

---

## Communication

### Daily
- Standup: 9:30 AM, 15 min
- Slack: #socratic-dev, #socratic-alerts

### Weekly
- Sprint Planning: Monday, 2h
- Sprint Review: Friday, 1h
- Retrospective: Friday, 30min
- Status email to stakeholders

---

**Version:** 1.0 | **Updated:** 2025-11-12
