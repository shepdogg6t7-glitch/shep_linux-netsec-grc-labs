#!/usr/bin/env bash
# Lab 6: Custom Linux security audit script -> CSV findings report
# Mirrors a subset of CIS Ubuntu Linux Benchmark checks.
# Usage: sudo ./02-audit-script.sh > audit-report.csv

echo "control_id,description,status,detail"

check() {
    local id="$1" desc="$2" status="$3" detail="$4"
    printf '"%s","%s","%s","%s"\n' "$id" "$desc" "$status" "$detail"
}

# 1. Root SSH login
if grep -qE '^\s*PermitRootLogin\s+yes' /etc/ssh/sshd_config 2>/dev/null; then
    check "CIS-5.2.8" "SSH root login disabled" "FAIL" "PermitRootLogin yes found"
else
    check "CIS-5.2.8" "SSH root login disabled" "PASS" "root login not explicitly permitted"
fi

# 2. Password login vs key-only
if grep -qE '^\s*PasswordAuthentication\s+yes' /etc/ssh/sshd_config 2>/dev/null; then
    check "CIS-5.2.10" "SSH password authentication disabled" "FAIL" "PasswordAuthentication yes"
else
    check "CIS-5.2.10" "SSH password authentication disabled" "PASS" "not set to yes"
fi

# 3. UFW/firewall active
if command -v ufw >/dev/null && sudo ufw status | grep -q "Status: active"; then
    check "CIS-3.5.1" "Host firewall enabled" "PASS" "ufw active"
else
    check "CIS-3.5.1" "Host firewall enabled" "FAIL" "ufw not active or not installed"
fi

# 4. Automatic security updates
if dpkg -l | grep -q unattended-upgrades; then
    check "CIS-1.9" "Automatic updates configured" "PASS" "unattended-upgrades installed"
else
    check "CIS-1.9" "Automatic updates configured" "FAIL" "unattended-upgrades not found"
fi

# 5. World-writable files in /etc
ww_count=$(find /etc -xdev -type f -perm -0002 2>/dev/null | wc -l)
if [[ "$ww_count" -eq 0 ]]; then
    check "CIS-6.1.10" "No world-writable files in /etc" "PASS" "0 found"
else
    check "CIS-6.1.10" "No world-writable files in /etc" "FAIL" "$ww_count found"
fi

# 6. Password max age policy
max_days=$(grep -E '^PASS_MAX_DAYS' /etc/login.defs 2>/dev/null | awk '{print $2}')
if [[ -n "$max_days" && "$max_days" -le 90 ]]; then
    check "CIS-5.4.1.1" "Password max age <= 90 days" "PASS" "PASS_MAX_DAYS=$max_days"
else
    check "CIS-5.4.1.1" "Password max age <= 90 days" "FAIL" "PASS_MAX_DAYS=${max_days:-unset}"
fi

# 7. auditd running
if systemctl is-active --quiet auditd 2>/dev/null; then
    check "CIS-4.1.1.1" "Audit daemon (auditd) running" "PASS" "active"
else
    check "CIS-4.1.1.1" "Audit daemon (auditd) running" "FAIL" "not running"
fi
