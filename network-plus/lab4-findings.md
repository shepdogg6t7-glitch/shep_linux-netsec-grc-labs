# Lab 4 Findings — Firewall Configuration & Verification

## ufw rule set

Status: active

    To                         Action      From
    --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 80/tcp                     ALLOW IN    Anywhere
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)
[ 4] 80/tcp (v6)                ALLOW IN    Anywhere (v6)

Rule 1/3 (22/tcp): kept SSH open deliberately before setting default-deny, so I
would not lock myself out of remote access on a real server.
Rule 2/4 (80/tcp): allowed HTTP in, representing a web service this host might run.
IPv4 and IPv6 versions are both present since ufw manages both stacks separately.

## Before/after: closing port 8080

Started a listener: python3 -m http.server 8080

Before blocking:
    nmap -Pn -p 8080 localhost -> 8080/tcp open  http-proxy

Blocked with: sudo ufw deny 8080/tcp (confirmed present via
sudo iptables -L -v -n as a DROP rule on tcp dpt:8080)

After blocking, scanned three ways:
    nmap -Pn -p 8080 localhost      -> still open
    nmap -Pn -p 8080 172.24.247.76  -> still open
    iptables packet/byte counters on the DROP rule -> stayed at 0 0 throughout

## Key finding: firewall rules don't protect a host from itself

I expected the port to show closed/filtered after adding the deny rule, but it
stayed open no matter which local address I scanned against, and the iptables
counters never incremented — proving the DROP rule was never actually evaluated.
This happens because traffic from a host to its own IP (including loopback and
often its own assigned interface address) is routed internally by the kernel
without necessarily crossing the network interface's INPUT chain the same way
traffic from a genuinely remote host would. The practical exam takeaway: you
cannot reliably validate a host firewall by scanning yourself. Testing must come
from a separate machine on the network to see how the firewall actually behaves
against real external traffic.

## Closed vs. filtered (nmap)

"Closed" means a host responded and explicitly said no service is listening on
that port (typically a TCP RST). "Filtered" means nmap got no response at all,
or an ICMP unreachable, and can't tell whether a service exists behind the
silence, because a firewall (or the network path) is dropping/blocking the
probe with no reply. A well-configured firewall usually produces "filtered"
results to external scanners, since silently dropping packets reveals less
information to an attacker than a "closed" response does. This is exactly what
makes "closed" vs "filtered" a favorite exam trick: closed still confirms a
live host, filtered gives an attacker no information about whether anything
exists behind that port at all.

cat network-plus/lab4-findings.md
nano network-plus/lab4-findings.md

## Corrected root cause: loopback ACCEPT rule, not internal routing

The DROP rule counters staying at 0 0 wasn't because traffic to a host's own IP
skips the INPUT chain entirely — it's because ufw inserts an unconditional
ACCEPT rule for the loopback interface as the very first rule in the
ufw-before-input chain, which runs before user-defined rules in ufw-user-input
(where my 8080 DROP rule lives). Confirmed with:

    sudo iptables -L ufw-before-input -v
    56  4849 ACCEPT  all  --  lo  any  anywhere  anywhere

Because Linux routes traffic to a host's own assigned IPs (not just 127.0.0.1)
out through lo internally, this rule caught my "external" scans against
172.24.247.76 too — matching three rules before my DROP rule was ever reached.
This is a first-match-wins rule-ordering issue, not a routing quirk.

## Follow-up: verifying from a genuinely external path

To confirm this, I re-armed the block (sudo ufw deny 8080/tcp) and tested from
Windows PowerShell across the WSL2 virtual network adapter
(vEthernet (WSL (Hyper-V firewall))) rather than from within WSL itself:

    Test-NetConnection -ComputerName 172.24.247.76 -Port 8080
    ...
    TcpTestSucceeded : False

Checking sudo iptables -L ufw-user-input -v -n afterward confirmed the DROP
rule's counters incremented from 0 0 to 5 260, whereas they stayed at 0 0
throughout every self-scan attempt. This is direct evidence the firewall rule
was never evaluated during the self-scan (loopback bypass), and is correctly
evaluated and enforced against traffic arriving over a real network path.
