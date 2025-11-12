# Project Constitution
**Use:** `/constitute docs/inputs/PROJECT_CONSTITUTION.md`

---

## Stack

| Component | Version |
|-----------|---------|
| Python | 3.11+ |
| TypeScript | 5.3+ |
| FastAPI | 0.104+ |
| Next.js | 14.2+ |
| React | 18.2+ |
| PostgreSQL | 15+ |
| Redis | 7.2+ |
| LiteLLM | 1.40+ |
| LangGraph | 0.2+ |
| Docker | 24+ |
| Kubernetes | 1.28+ |

## Standards

**Python:** Black (100), Ruff, mypy strict, isort
**TypeScript:** Prettier, ESLint (next/core-web-vitals), strict
**Pre-commit:** black, ruff, mypy, prettier, eslint

## Tests

| Type | Coverage | Command |
|------|----------|---------|
| Unit | >80% | `pytest --cov=src --cov-fail-under=80` |
| Integration | >70% | `pytest tests/integration` |
| E2E | 10 flows | `playwright test` |

## Git

**Branches:** `<type>/<desc>` (feature|fix|refactor|docs|test|chore)
**Protection (main):** PR review required, status checks pass, no direct push
**Flow:** develop → staging → main

## Security

- Secrets: AWS Secrets Manager only
- Auth: JWT (1h), refresh tokens, 100 req/min limit
- Input: Sanitize all, parameterized queries, prompt injection detection
- Headers: HSTS, X-Frame-Options, CSP
- Deps: Dependabot, Snyk, monthly updates

## Privacy

- GDPR, CCPA compliant
- Retention: 90 days
- Export/deletion available
- Encrypt: AES-256 (rest), TLS 1.3 (transit)
- No PII in logs

## Performance (p95)

- API: <200ms
- Agent contribution: <10s
- Discussion round: <90s
- Total discussion: <10 min
- DB query: <1s
- Lighthouse: >90

## Errors

| Type | Level | Action |
|------|-------|--------|
| 4xx | INFO | Helpful message |
| 5xx | ERROR | Log + alert |
| External | WARN | Retry 3×, fallback |

## Monitoring

**Metrics:** Uptime >99.9%, Error <1%, LLM success >95%
**Alerts:** Critical=page, High=Slack, Medium=email
**Health:** `/health`, `/health/ready`, `/health/live`

## LLM

- Token budget: 2K/contribution, 50K/discussion
- Never single provider (implement fallbacks)
- Version control prompts
- Tool timeout: 30s, retry 2×

## Out of Scope

**Features:** Mobile apps, video/audio I/O, multi-user collab, custom LLM training, social features, non-English
**Integrations:** Slack/Teams, browser extensions, developer API (MVP), CRM
**Technical:** Multi-tenancy, white-label, SSO, offline

## Constraints

**Technical:** LLM latency 3-10s, rate limits, context 8K-200K tokens
**Business:** $50k dev, $15k/mo infra, 7 people max, 20 weeks fixed
**Legal:** LLM ToS, GDPR/CCPA, content moderation, AI disclaimer

## Incidents

| P0 | P1 | P2 | P3 |
|----|----|----|-----|
| 1h | 4h | 24h | 1w |

Post-mortem required: P0/P1

---

**v1.0** | **2025-11-12**
