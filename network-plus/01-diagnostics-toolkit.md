# Lab 1: Network Diagnostics Toolkit

**Network+ objectives covered:** 5.2 (network troubleshooting methodology),
1.4/1.5 (ports, protocols), 5.4 (command-line tools)

## Commands to practice (old vs new)

| Task                     | Legacy tool          | Modern tool          |
|---------------------------|-----------------------|-----------------------|
| Show interfaces/IPs       | `ifconfig`            | `ip addr show`        |
| Show routing table        | `route -n`            | `ip route show`       |
| Show connections/ports    | `netstat -tulnp`      | `ss -tulnp`           |
| Trace path to host        | `traceroute`          | `traceroute` (same)   |
| Test reachability         | `ping`                | `ping` (same)         |
| DNS lookup                | `nslookup`            | `dig`                 |

Network+ still tests `ifconfig`/`netstat` even though `ip`/`ss` are what real
sysadmins use now — learn both.

## Exercises

1. **Interface inventory**
   ```bash
   ip addr show
   ifconfig -a
   ```
   Write down: interface name, IP/CIDR, MAC address, MTU for each interface.

2. **Routing table read**
   ```bash
   ip route show
   route -n
   ```
   Identify: default gateway, which interface handles which subnet.

3. **Port/service audit**
   ```bash
   ss -tulnp
   sudo netstat -tulnp
   ```
   List every listening port and the process behind it. Cross-reference with
   the well-known ports list (22=SSH, 80=HTTP, 443=HTTPS, 53=DNS, etc.) —
   this is directly tested on the exam.

4. **Path tracing**
   ```bash
   traceroute google.com
   traceroute -I google.com   # ICMP instead of UDP
   ```
   Note where latency jumps — that's the troubleshooting skill the exam wants.

5. **DNS resolution chain**
   ```bash
   dig google.com
   dig +trace google.com
   nslookup google.com
   ```
   Compare `dig +trace` output to understand the root → TLD → authoritative
   server chain (Network+ domain 1.5).

## Deliverable

Save your findings as `network-plus/lab1-findings.md`:
- Your interfaces table
- Your routing table explained in your own words
- A list of open ports on your machine and what's using them
- One `traceroute` output with an explanation of each hop

Commit this to your GitHub repo — it's proof of hands-on skill, not just a
checklist you ran through.
