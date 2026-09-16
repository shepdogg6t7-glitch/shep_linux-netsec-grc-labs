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
