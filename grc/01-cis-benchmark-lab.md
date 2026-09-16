# Lab 5: CIS Benchmark Auditing with Lynis

**GRC concepts covered:** control frameworks (CIS Benchmarks), audit methodology,
gap analysis, evidence collection

## Why this matters

CIS Benchmarks are the industry-standard hardening checklists auditors use
against Linux servers. Lynis automates checking a box against these controls —
this is literally what a junior GRC analyst does in a Linux shop.

## Exercises

1. **Run a full audit**
   ```bash
   sudo lynis audit system
   ```
   This takes a few minutes and produces a hardening index score.

2. **Review the report**
   ```bash
   sudo cat /var/log/lynis-report.dat | less
   sudo cat /var/log/lynis.log | grep -i warning
   ```

3. **Pick 5 findings and research the control**
   For each `[WARNING]` or suggestion Lynis gives you:
   - What CIS control or best practice does it map to?
   - What's the actual risk if left unfixed?
   - What's the remediation command?

   Example pattern:
   | Finding | Risk | Remediation |
   |---|---|---|
   | SSH root login permitted | Attacker with root creds gets direct root shell | `PermitRootLogin no` in sshd_config |

4. **Remediate one finding and re-scan**
   ```bash
   sudo lynis audit system --profile /etc/lynis/default.prf
   ```
   Compare hardening index before/after.

## Deliverable

`grc/lab5-findings.md`:
- Your hardening index score, before and after one remediation
- A table of 5 findings mapped to risk + remediation (like above)
- One paragraph: why automated compliance scanning (Lynis) doesn't replace
  human judgment in a GRC audit — this is a real interview question
