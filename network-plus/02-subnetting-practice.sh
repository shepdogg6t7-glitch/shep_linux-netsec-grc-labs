#!/usr/bin/env bash
# Lab 2: Subnetting drill — Network+ objective 1.3
# Generates random IP/CIDR problems and checks your answers.
# Usage: ./02-subnetting-practice.sh [number_of_questions]

set -euo pipefail
COUNT="${1:-10}"
correct=0

random_octet() { echo $(( RANDOM % 256 )); }

for ((i=1; i<=COUNT; i++)); do
    ip="$(random_octet).$(random_octet).$(random_octet).0"
    cidr=$(( (RANDOM % 9) + 24 ))  # /24 through /32 for beginner-friendly range

    # Compute expected values with python3 (ships on most distros; installs via apt if missing)
    read -r network broadcast hosts <<EOF
$(python3 - "$ip" "$cidr" <<'PY'
import sys, ipaddress
ip, cidr = sys.argv[1], sys.argv[2]
net = ipaddress.ip_network(f"{ip}/{cidr}", strict=False)
usable = max(net.num_addresses - 2, 0)
print(net.network_address, net.broadcast_address, usable)
PY
)
EOF

    echo "Q$i: Given $ip/$cidr"
    read -rp "  Network address? " ans_net
    read -rp "  Broadcast address? " ans_bcast
    read -rp "  Usable host count? " ans_hosts

    if [[ "$ans_net" == "$network" && "$ans_bcast" == "$broadcast" && "$ans_hosts" == "$hosts" ]]; then
        echo "  ✅ Correct!"
        ((correct++))
    else
        echo "  ❌ Answer: network=$network broadcast=$broadcast usable_hosts=$hosts"
    fi
    echo
done

echo "Score: $correct / $COUNT"
