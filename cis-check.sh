#!/bin/bash
echo "=========================================="
echo "CIS Benchmark Audit Tool"
echo "Edo State - SOC Analyst Portfolio - Angelo"
echo "WSL Compatible Version"
echo "=========================================="
echo ""

PASS=0
FAIL=0

check() {
  if eval "$1" > /dev/null 2>&1; then
    echo "[PASS] $2"
    PASS=$((PASS+1))
  else
    echo "[FAIL] $2"
    FAIL=$((FAIL+1))
  fi
}

check "grep -q 'install cramfs /bin/true' /etc/modprobe.d/cramfs.conf" "1.1.1.1 cramfs disabled - secure"
check "grep -q '^PASS_MAX_DAYS.*90' /etc/login.defs" "5.4.1.1 PASS_MAX_DAYS = 90 - secure"
check "grep -q '^PASS_MIN_DAYS.*1' /etc/login.defs" "5.4.1.2 PASS_MIN_DAYS = 1 - secure"
check "sysctl net.ipv4.conf.all.send_redirects | grep -q '0'" "3.3.2 Packet redirects disabled - secure"

# FIXED FOR WSL - checks if UFW is installed (WSL can't show active)
check "dpkg -l | grep -q ufw" "3.5.1.1 UFW firewall installed - secure (WSL)"

check "grep -q '^PermitRootLogin no' /etc/ssh/sshd_config" "5.2.10 SSH PermitRootLogin no - secure"

PERM=$(stat -c %a /etc/shadow 2>/dev/null)
check "[ $PERM -eq 640 ]" "6.1.2 /etc/shadow permissions = $PERM - secure"

check "dpkg -l | grep -q auditd" "4.1.3.1 auditd installed - secure"

# FIXED - now handles spaces around = 
check "grep -E -q 'minlen.*14' /etc/security/pwquality.conf" "5.4.1.3 Password min length 14 - secure"

check "! awk -F: '\$2 == \"\" {print}' /etc/shadow | grep -q ." "6.2.1 No empty passwords - secure"

echo ""
echo "=========================================="
echo "SCORE: $PASS PASSED / $FAIL FAILED out of 10"
if [ $FAIL -eq 0 ]; then
  echo "System is CIS Level 1 Compliant! - Edo State SOC Analyst"
else
  echo "System needs hardening"
fi
echo "=========================================="
