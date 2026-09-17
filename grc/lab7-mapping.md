# Lab 7 — Mapping Technical Findings to GRC Frameworks

Findings sourced from `grc/lab5-findings.md` (Lynis) and `grc/audit-report.csv`
(custom script), mapped to current framework versions: CIS Ubuntu 24.04 LTS
Benchmark, NIST CSF 2.0 (effective 2024, replacing the older PR.AC-numbered
1.1 categories), and ISO/IEC 27001:2022 Annex A (renumbered from the 2013
version).

| Technical finding | CIS Control | NIST CSF 2.0 | ISO 27001:2022 Annex A | Business risk |
|---|---|---|---|---|
| Vulnerable/outdated packages (Lynis PKGS-7392) | General patch hygiene | PR.PS-02 (Software is maintained, replaced, and removed commensurate with risk) | A.8.8 (Management of technical vulnerabilities) | Known CVEs remain exploitable until patched |
| Password max age unset (PASS_MAX_DAYS=99999) | CIS 5.4.1.1 | PR.AA-01 (Identities and credentials are managed) | A.5.17 (Authentication information) | Compromised credentials remain valid indefinitely |
| SSH root login permitted | CIS 5.2.8 | PR.AA-01 (Identities and credentials are managed) | A.8.5 (Secure authentication) | Direct root compromise if credentials leak, no privilege-escalation audit trail |
| Host firewall inactive | CIS 3.5.1 | PR.IR-01 (Networks/environments protected from unauthorized logical access) | A.8.20 (Networks security) | No perimeter control; every listening service directly exposed |
| Audit daemon (auditd) not running | CIS 4.1.1.1 | PR.PS-04 (Log records generated and made available for continuous monitoring) | A.8.15 (Logging) | No audit trail for incident response or after-the-fact investigation |
| Single responsive DNS nameserver (Lynis NETW-2705) | N/A (availability, not a CIS security control) | PR.IR-04 (Adequate resource capacity to ensure availability) | A.8.14 (Redundancy of information processing facilities) | Single point of failure for name resolution/availability |

## Reflection: which framework was easiest to map to?

CIS was the easiest to map findings to directly, because CIS controls are
written as specific, testable configuration statements ("PermitRootLogin
should not be yes") that correspond almost 1:1 with what a scanning tool like
Lynis or a custom script actually checks. NIST CSF was the hardest, not
because it's poorly written, but because it operates at a higher level of
abstraction — a single CSF subcategory like PR.PS-02 covers an entire
category of behavior ("software is maintained"), so I had to interpret intent
rather than match a literal string. ISO 27001 sat in between: specific enough
to point to one control, but phrased in outcome/policy language rather than
Linux config syntax.

This distinction is exactly why frameworks are usually used together rather
than as substitutes for one another: CIS/vendor benchmarks give you the
concrete "how," NIST CSF gives you the "why this matters to the business" and
risk-tolerance framing for leadership conversations, and ISO 27001 gives you
the audit/certification structure to prove you're doing both consistently
over time. Recognizing that overlap — rather than treating the three as
interchangeable checklists — is what actually separates a junior GRC analyst
from someone just running scanners.
