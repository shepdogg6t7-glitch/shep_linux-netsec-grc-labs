# Lab 5 Findings — CIS Benchmark Auditing with Lynis

## Hardening index: before and after

- Baseline scan: Hardening index 65/100 (251 tests performed)
- Remediation applied: `sudo apt full-upgrade -y` (resolved PKGS-7392, vulnerable packages)
- Post-remediation scan: Hardening index 65/100 (unchanged)

The PKGS-7392 warning disappeared entirely after remediation (confirmed via
`sudo grep '^warning' /var/log/lynis-report.dat`), but the overall index number
didn't move. This makes sense once you understand the index is a weighted
composite across 251 individual tests, not a simple pass/fail counter — fixing
one real, meaningful risk doesn't necessarily shift a rounded top-line score
if other unrelated checks weigh more heavily. The index is a useful trend
indicator, not proof that any single finding was or wasn't addressed; the
underlying warning/suggestion list is the real evidence.

## Findings mapped to risk and remediation

| Finding ID | Finding | Control area | Risk if unfixed | Remediation |
|---|---|---|---|---|
| PKGS-7392 | Vulnerable packages found | Patch management | Known CVEs exploitable on the host | `sudo apt update && sudo apt full-upgrade -y` |
| AUTH-9286 | No max password age set | Password aging policy (CIS 5.4.1) | Compromised credentials stay valid indefinitely | Set `PASS_MAX_DAYS` in `/etc/login.defs` |
| AUTH-9328 | Default umask not strict (should be 027) | File permission hardening (CIS 5.4.4) | New files/dirs created world-readable by default | Set `UMASK 027` in `/etc/login.defs` |
| DEB-0880 | fail2ban not installed | Brute-force/intrusion prevention | Unlimited SSH login attempts possible | `sudo apt install fail2ban` |
| NETW-2705 | Couldn't find 2 responsive nameservers | DNS resiliency (availability, not security) | Single point of failure for name resolution | Add a secondary DNS server (e.g. `1.1.1.1`) |

## Why automated scanning doesn't replace human judgment

Lynis flagged NETW-2705 (couldn't find 2 responsive nameservers) as a warning,
the same severity tier as PKGS-7392 (actual known-vulnerable packages). Taken
at face value, a checklist-only approach would treat both as equally urgent.
In reality, having only one working DNS resolver is an availability/resiliency
concern, not a security vulnerability an attacker can exploit — it belongs in
a different remediation priority tier entirely. A GRC analyst's job is exactly
this triage: reading what a scanner reports, understanding *why* a control
exists, and judging actual risk and business impact rather than treating every
flagged line item as equally critical. Automated tools like Lynis are
essential for coverage and consistency (a human auditor won't manually check
251 things every time), but they don't understand context, compensating
controls, or risk tolerance — that interpretation layer is the actual value
a GRC analyst provides.
