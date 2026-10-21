# NIST SP 800-53 Rev 5 Control Mapping (Focused Subset)

## Scope
This is a focused subset of NIST SP 800-53 Rev 5 controls relevant to AtlasOps. Not all 800 controls — only those applicable to a self-hosted document processing API.

## Access Control (AC)

| Control ID | Control Name | Status | Implementation |
|------------|--------------|--------|----------------|
| AC-2 | Account Management | Implemented | Registration on/off switch; orgs created per registered user |
| AC-3 | Access Enforcement | Implemented | Org membership validated on every /organizations and /projects endpoint |
| AC-6 | Least Privilege | Implemented | Membership roles (owner); users access only their own org projects |
| AC-17 | Remote Access | Implemented | API access via bearer token over HTTPS |

## Identification and Authentication (IA)

| Control ID | Control Name | Status | Implementation |
|------------|--------------|--------|----------------|
| IA-2 | Identification and Authentication | Implemented | Email/password auth with JWT bearer tokens |
| IA-5 | Authenticator Management | Implemented | Argon2id hashing; 12-char minimum password |
| IA-5(1) | Password Complexity | Implemented | 12+ char minimum enforced at registration |
| IA-7 | Cryptographic Module Authentication | Implemented | JWT signed with JWT_SECRET (HS256 via PyJWT) |

## System and Communications Protection (SC)

| Control ID | Control Name | Status | Implementation |
|------------|--------------|--------|----------------|
| SC-7 | Boundary Protection | Implemented | Docker Compose binds services to localhost-only ports; CORS restricted |
| SC-8 | Transmission Confidentiality | Implemented | TLS required for production; enforced at reverse proxy |
| SC-28 | Protection at Rest | Partially | App does not encrypt at rest; relies on host disk/volume encryption |

## System and Information Integrity (SI)

| Control ID | Control Name | Status | Implementation |
|------------|--------------|--------|----------------|
| SI-3 | Malicious Code Protection | Partially | PDF magic-byte validation rejects non-PDF files |
| SI-4 | Information System Monitoring | Partially | Health endpoint (/health); errors logged to stdout |
| SI-7 | Software Integrity | Partially | Pinned dependency versions in requirements.txt |

## Statement of Applicability
Controls marked Planned are infrastructure/operational responsibilities of the deploying organization. Controls marked Partially are implemented at the application layer but require host-level configuration to be fully effective.
