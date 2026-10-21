# Threat Model (Focused Subset)

## Assets

| Asset | Sensitivity | Protection |
|-------|-------------|------------|
| Uploaded PDF documents | High | MinIO + loopback binding, disk encryption at host |
| Document chunks + embeddings | High | PostgreSQL + pgvector, loopback binding |
| User credentials | High | Argon2id hashes in PostgreSQL |
| JWT signing secret | Critical | JWT_SECRET env var, 32+ chars |
| LLM/embedding API keys | Critical | .env on API host only |

## Top Threats and Mitigations

| Threat Actor | Threat | Impact | Likelihood | Mitigation |
|--------------|--------|--------|------------|------------|
| Unauthenticated attacker | Register when registration open | Unauthorized org creation | Medium | ALLOW_REGISTRATION=false default |
| Unauthenticated attacker | Brute-force login | Account takeover | Medium | Rate limiting (10/min), Argon2id, 12+ char passwords |
| Authenticated user | Access another org project | Data leakage across tenants | Low | Org membership check on every endpoint |
| Network attacker | Intercept API traffic | Credential/document theft | Medium | TLS at reverse proxy; loopback-only defaults |
| Malicious file upload | Non-PDF or oversized file | DoS, code execution | Low | PDF magic-byte check, 25 MB limit |
| Insider / compromised account | Export all documents | Data exfiltration | Medium | Per-user rate limiting, org isolation |

## Data Flow Boundaries
1. Client → API: HTTPS (prod), HTTP (dev localhost)
2. API → PostgreSQL: Loopback-only Docker network
3. API → MinIO: Loopback-only Docker network
4. API → Redpanda: Loopback-only Docker network
5. API → LLM provider: Outbound HTTPS (only when LLM Q&A enabled)

## Assumptions
- Host OS and Docker daemon are patched
- Underlying disk/volume encryption enabled at infrastructure layer
- Reverse proxy handles TLS termination
- JWT_SECRET generated with secrets.token_urlsafe(48)
