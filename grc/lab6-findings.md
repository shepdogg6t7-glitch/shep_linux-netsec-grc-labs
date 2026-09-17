# Lab 6 Findings — Custom Security Audit Script

## Audit results

Ran `grc/02-audit-script.sh`, a custom bash script mirroring 7 CIS Ubuntu
Benchmark controls, output as CSV (`grc/audit-report.csv`):

| Control ID | Description | Status |
|---|---|---|
| CIS-5.2.8 | SSH root login disabled | PASS |
| CIS-5.2.10 | SSH password authentication disabled | PASS |
| CIS-3.5.1 | Host firewall enabled | PASS |
| CIS-1.9 | Automatic updates configured | PASS |
| CIS-6.1.10 | No world-writable files in /etc | PASS |
| CIS-5.4.1.1 | Password max age <= 90 days | PASS (after remediation) |
| CIS-4.1.1.1 | Audit daemon (auditd) running | FAIL (environment limitation, see below) |

## Remediation: password max age

`/etc/login.defs` had `PASS_MAX_DAYS=99999` (effectively no expiration).
Fixed the default for future accounts:

    sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs

Important gotcha: changing `/etc/login.defs` only affects accounts created
*after* the change — it does not retroactively apply to existing users. Had
to separately apply it to my own account:

    sudo chage -M 90 kelvi_f

This is a real auditor blind spot: checking the config file alone (as my
script does) tells you the *policy*, not whether *existing accounts* actually
comply with it. A more thorough control would also check `chage -l` output
per user, not just `/etc/login.defs`.

## Known limitation: auditd will not start under WSL2

Attempting to remediate CIS-4.1.1.1 (`sudo systemctl enable --now auditd`)
failed. Running the daemon directly surfaced the real error:

    Error sending status request (Operation not permitted)
    Error sending enable request (Operation not permitted)
    Unable to set initial audit startup state to 'enable', exiting

This is a known WSL2 constraint, not a misconfiguration: WSL2 runs a custom,
lightweight Microsoft-maintained kernel that does not expose full
audit-subsystem control over the netlink socket auditd requires to enable
itself. This control would pass on a real Ubuntu server or a full VM with a
standard kernel — the finding here is an environment boundary, not a failed
remediation.

Practical takeaway: a GRC audit script or checklist item can be textbook
correct and still fail in specific environments for reasons unrelated to
actual security posture. Recognizing that distinction (config/security gap
vs. platform limitation) matters when reporting findings, so remediation
effort isn't wasted chasing something the platform itself doesn't support.
