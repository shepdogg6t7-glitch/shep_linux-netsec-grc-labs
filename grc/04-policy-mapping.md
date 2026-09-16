# Lab 7: Mapping Technical Findings to GRC Frameworks

**GRC concepts covered:** control frameworks, framework crosswalking,
translating technical findings into audit/compliance language

## Why this matters

The actual job of GRC isn't running Lynis — it's translating "SSH root login
is enabled" into "this violates PR.AC-1 under NIST CSF and CIS control 5.2.8,
here's the business risk, here's the remediation timeline." This lab builds
that translation skill.

## Exercise

For every finding in your `grc/lab5-findings.md` and `audit-report.csv`,
fill out this mapping:

| Technical finding | CIS Control | NIST CSF Function/Category | ISO 27001 Annex A | Business risk (1 sentence) |
|---|---|---|---|---|
| SSH root login enabled | 5.2.8 | PR.AC-1 (Identity Mgmt) | A.9.2.3 (Privileged access rights) | Direct root compromise if creds leak |
| Firewall inactive | 3.5.1 | PR.AC-5 (Network Integrity) | A.13.1.1 (Network controls) | No perimeter control on the host |

Reference material to look up (search these, don't memorize — this is how
real GRC analysts work):
- CIS Ubuntu Linux Benchmark (search "CIS Ubuntu 24.04 Benchmark")
- NIST Cybersecurity Framework categories (nist.gov/cyberframework)
- ISO/IEC 27001 Annex A control list

## Deliverable

`grc/lab7-mapping.md` — a completed table like above for at least 5 findings,
plus a one-paragraph reflection: which framework did you find easiest to map
your findings to, and why? (This is a common GRC interview question — frameworks
overlap heavily, and recognizing that overlap is a real skill.)
