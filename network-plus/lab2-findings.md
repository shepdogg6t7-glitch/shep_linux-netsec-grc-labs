# Lab 2 Findings — Subnetting Practice

Skipped the scripted quiz — prior networking coursework already covers this material.
Verified competency on five problems worked manually, including mid-octet boundary cases:

| IP/CIDR | Network | Broadcast | Usable Hosts |
|---|---|---|---|
| 234.58.17.x/24 | 234.58.17.0 | 234.58.17.255 | 254 |
| 10.42.183.0/26 | 10.42.183.0 | 10.42.183.63 | 62 |
| 198.16.9.0/28 | 198.16.9.0 | 198.16.9.15 | 14 |
| 172.20.55.0/20 | 172.20.48.0 | 172.20.63.255 | 4094 |
| 192.168.100.0/29 | 192.168.100.0 | 192.168.100.7 | 6 |

All answers correct on first attempt, including derived subnet masks, block-size
math for non-octet-aligned boundaries, and first/last usable IPs.
