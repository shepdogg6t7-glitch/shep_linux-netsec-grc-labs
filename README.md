# Linux Networking + GRC Hands-On Labs

Practical labs built on a real Ubuntu/Debian box, mapped to:
- **CompTIA Network+ objectives** (diagnostics, routing, ports/services, packet analysis, firewalls)
- **GRC frameworks** (CIS Benchmarks, NIST CSF, ISO 27001) applied to Linux hardening & audit

Goal: every lab produces a real artifact (output file, script, report) you can commit to
this repo as evidence of the skill — this becomes a portfolio piece, not just notes.

## Repo layout

```
network-plus/   Network+ objective labs (diagnostics, subnetting, packet capture, firewall)
grc/            Audit, hardening, and risk-documentation labs
docs/           Roadmap, objective-to-lab mapping, glossary
```

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
- `lynis`, `auditd` → security auditing (GRC labs)

## Suggested order

1. `network-plus/01-diagnostics-toolkit.md` — core commands, build muscle memory
2. `network-plus/02-subnetting-practice.sh` — self-quizzing subnet calculator
3. `network-plus/03-packet-capture-lab.md` — tcpdump + protocol analysis
4. `network-plus/04-firewall-lab.md` — ufw/iptables rules + verification
5. `grc/01-cis-benchmark-lab.md` — run Lynis, interpret findings
6. `grc/02-audit-script.sh` — custom audit script → CSV report
7. `grc/03-risk-register-template.csv` — turn findings into a real risk register
8. `grc/04-policy-mapping.md` — map findings to NIST CSF / ISO 27001 controls

See `docs/roadmap.md` for a week-by-week plan and `docs/objective-map.md` for exact
Network+ exam objective codes covered by each lab.
