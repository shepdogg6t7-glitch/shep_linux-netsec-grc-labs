# AtlasOps Security Posture (GRC Reference)

## Scope
Focused security controls for the AtlasOps self-hosted document intelligence platform. This is a subset relevant to GRC review — not all 800 NIST SP 800-53 controls.

## Deployment Model
Self-hosted, private infrastructure. All backing services bind to loopback-only ports by default via Docker Compose. No data leaves the customer network unless explicitly configured.

## Controls Implemented (Focused Subset)

| Area | Control | Implementation |
|------|---------|----------------|
| Authentication | Password hashing | Argon2id, 12+ char minimum |
| Authentication | Session tokens | JWT bearer, 30-minute expiry |
| Authorization | Organization isolation | Project access checked against user org membership |
| Authorization | Registration gating | ALLOW_REGISTRATION on/off, defaults to false |
| Input validation | File type | PDF magic-byte validation |
| Input validation | File size | 25 MB default limit |
| Input validation | Filename sanitization | Path traversal and control-character stripping |
| Rate limiting | Per-user/IP | slowapi with Redis, fails closed on Redis outage |
| Network | CORS | Configurable CORS_ORIGIN, localhost by default |
| Secrets | JWT signing key | Required JWT_SECRET (32+ chars), no dev fallback |
| Secrets | API keys | LLM/embedding keys in .env only, never committed |

## What Is Not In Scope
- Multi-tenant SaaS hosting (self-hosted only)
- SSO/OIDC (email/password only)
- E2E encryption at rest (relies on host disk encryption)
- SIEM integration (stdout/stderr logs; forward via your log aggregator)
