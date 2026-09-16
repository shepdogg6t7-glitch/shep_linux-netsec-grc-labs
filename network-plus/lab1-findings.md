# Lab 1 Findings

## Interfaces
| Interface | IP/CIDR | MAC | MTU |
|---|---|---|---|
| lo | 127.0.0.1/8 (loopback), 10.255.255.254/32 | 00:00:00:00:00:00 | 65536 |
| eth0 | 172.24.247.76/20 | 00:15:5d:44:b3:b1 | 1500 |

lo is the loopback interface, traffic to itself, never leaves the machine. eth0 is
the actual network interface WSL uses, on a /20 subnet (172.24.240.0-172.24.255.255).

## Routing table
default via 172.24.240.1 dev eth0 proto kernel
172.24.240.0/20 dev eth0 proto kernel scope link src 172.24.247.76

The first line is the default route: any traffic not matching a more specific rule
gets sent to 172.24.240.1 (the gateway) via eth0. The second line says the local
/20 subnet is directly reachable on eth0 with no gateway needed, it's the same
broadcast domain.

## Open ports
| Port | Protocol | Local address | Likely service |
|---|---|---|---|
| 22 | tcp | 0.0.0.0 / [::] | sshd, SSH server listening on all interfaces |
| 53 | tcp/udp | 127.0.0.54, 127.0.0.53%lo, 10.255.255.254 | systemd-resolved, local DNS stub resolver |
| 323 | udp | 127.0.0.1, [::1] | chronyd, NTP time sync client, localhost only |

Nothing here is listening on a public-facing interface except SSH (22), which is
expected on a Linux box meant to be remoted into. DNS and NTP being bound to
loopback/internal addresses means they are not exposed outside the machine.

## Traceroute
Hop 1 (172.24.240.1): WSL virtual gateway, sub-millisecond, expected for a local hop.
Hop 2 (192.168.0.1, home router): jumps to ~8ms as first real hardware hop.
Hops 3-5 (10.184.142.x): private ISP addresses (Verizon), 239ms spike likely from
  the router deprioritizing ICMP replies, not a real path problem.
Hops 6, 8, 11 (* * *): no reply, common for routers that silently drop traceroute probes.
Hops 7, 9, 10 (myvzw.com): inside Verizon backbone, latency stabilizes ~120ms.
Hop 12+: handoff into Google's own network (72.14.x, 142.251.x, 1e100.net).
Hop 28 (ncdfwo-in-f100.1e100.net): destination, a Google frontend server near Dallas-Fort Worth.

The long stretch of * * * between hops 20-27 is normal, Google's network declining
to respond to traceroute probes for internal hops, not a fault.
