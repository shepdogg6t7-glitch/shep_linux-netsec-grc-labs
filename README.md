# Linux Networking + GRC Hands-On Labs

Practical labs built on a real Ubuntu/Debian box (WSL2), mapped to:
- **CompTIA Network+ objectives** (diagnostics, routing, ports/services, packet analysis, firewalls)
- **GRC frameworks** (CIS Benchmarks, NIST CSF 2.0, ISO 27001:2022) applied to Linux hardening & audit

Goal: every lab produces a real artifact (output file, script, report) committed
to this repo as evidence of the skill — this is a portfolio piece, not just notes.

**Status: All 8 planned labs complete.** Every lab includes real command
output, not just a checklist — several surfaced genuine troubleshooting
findings worth reading directly:

- [`network-plus/lab4-findings.md`](network-plus/lab4-findings.md) — root-caused
  why a self-scan can't validate a firewall rule (ufw's loopback ACCEPT rule
  fires before user rules are evaluated), then independently confirmed the
  fix by scanning from a genuinely external host and watching the iptables
  counters increment.
- [`grc/lab6-findings.md`](grc/lab6-findings.md) — diagnosed a real WSL2
  platform limitation (auditd can't enable itself under WSL2's kernel) rather
  than reporting a false "fixed" status, and documented it as an accepted
  risk with compensating-control rationale in the risk register.
- [`grc/03-risk-register-template.csv`](grc/03-risk-register-template.csv) —
  a populated risk register (not placeholder rows) showing a real risk
  lifecycle: Closed, Accepted, and Open findings, each with dates and
  rationale.
- [`grc/lab7-mapping.md`](grc/lab7-mapping.md) — crosswalks real findings
  across CIS, NIST CSF 2.0, and ISO 27001:2022, using current control codes
  (not the retired NIST CSF 1.1 numbering many older references still cite).

## Repo layout

```
network-plus/   Network+ objective labs (diagnostics, subnetting, packet capture, firewall)
grc/            Audit, hardening, and risk-documentation labs
docs/           Roadmap, objective-to-lab mapping, glossary
```



## Security Documentation (GRC)

Focused cybersecurity documentation for portfolio review — not all 800 NIST controls, only those relevant to this project:

- [docs/security/security-posture.md](docs/security/security-posture.md) — implemented security controls
- [docs/security/threat-model.md](docs/security/threat-model.md) — threats, assets, mitigations
- [docs/security/nist-controls.md](docs/security/nist-controls.md) — focused NIST SP 800-53 Rev 5 control mapping (subset)
- [docs/architecture/system-architecture.md](docs/architecture/system-architecture.md) — Mermaid system architecture diagram

These docs load only when working in this project. AtlasOps remains clean with no security documentation.


## Setup (run once on YOUR machine)

```bash
sudo apt update
sudo apt install -y net-tools iproute2 traceroute nmap tcpdump dnsutils \
    iputils-ping ufw lynis auditd curl wget
```

- `net-tools` → `ifconfig`, `netstat`
- `iproute2` → `ip`, `ss` (the modern replacements — learn both, Network+ tests old and new)
- `nmap`, `tcpdump` → scanning & packet capture
- `dnsutils` → `dig`, `nslookup`
- `ufw` → simple firewall management
- `lynis`, `auditd` → security auditing (GRC labs). Note: `auditd` installs
  fine but cannot fully start under WSL2 due to a kernel limitation — see
  `grc/lab6-findings.md` for the diagnosis. Works normally on a real VM or
  bare-metal Ubuntu install.

## Completed labs

1. `network-plus/01-diagnostics-toolkit.md` — core commands, build muscle memory
2. `network-plus/02-subnetting-practice.sh` — self-quizzing subnet calculator
3. `network-plus/03-packet-capture-lab.md` — tcpdump + protocol analysis
4. `network-plus/04-firewall-lab.md` — ufw/iptables rules + verification ([findings](network-plus/lab4-findings.md))
5. `grc/01-cis-benchmark-lab.md` — Lynis audit and CIS-mapped remediation ([findings](grc/lab5-findings.md))
6. `grc/02-audit-script.sh` — custom audit script → CSV report ([findings](grc/lab6-findings.md))
7. `grc/03-risk-register-template.csv` — real findings turned into a populated risk register
8. `grc/lab7-mapping.md` — findings mapped to CIS / NIST CSF 2.0 / ISO 27001:2022 controls

See `docs/roadmap.md` for the week-by-week plan and `docs/objective-map.md` for
exact Network+ exam objective codes covered by each lab.

## Agent skills
Project-level skills in `.claude/skills` come from mukul975/Anthropic-Cybersecurity-Skills (Apache-2.0), commit 54a798831d2266a3ca61ce68a7acb80b81160d57. It is an independent community project, not affiliated with Anthropic. Only the `process.py` helpers for the risk-assessment and vendor-risk skills are included, after review; they use the Python standard library only.
