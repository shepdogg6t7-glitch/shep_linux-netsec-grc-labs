# Lab 4: Firewall Configuration & Verification

**Network+ objectives covered:** 4.3 (security appliances), 5.2 (troubleshooting
connectivity), 1.4 (ports/protocols)

## Part A — ufw (simple, good for building intuition)

```bash
sudo ufw status verbose
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp        # keep SSH open so you don't lock yourself out
sudo ufw allow 80/tcp
sudo ufw enable
sudo ufw status numbered
```

Verify from another terminal/machine:
```bash
nmap -Pn -p 22,80,443 <target-ip>
```
Confirm 22 and 80 show open, 443 shows filtered/closed.

## Part B — iptables (what's actually running underneath)

```bash
sudo iptables -L -v -n
sudo iptables -A INPUT -p tcp --dport 443 -j DROP
sudo iptables -L -v -n   # confirm the rule landed
```

Test the drop with `nmap` or `curl` from another host, then remove it:
```bash
sudo iptables -D INPUT -p tcp --dport 443 -j DROP
```

## Deliverable

`network-plus/lab4-findings.md`:
- Your `ufw status numbered` output, annotated with why each rule exists
- Before/after `nmap` scan showing a port you closed
- One paragraph: difference between "closed" and "filtered" in nmap output,
  and what that tells you about a firewall's behavior (this is a favorite
  Network+ exam trick question)
