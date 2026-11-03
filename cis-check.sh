#!/bin/bash
# CIS Hardening Tool - by Angelo - Edo State -> Warri
# For SOC Analyst Portfolio - Ubuntu 22.04 CIS Level 1 Checks

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

pass() { echo -e "${GREEN}[PASS]${NC} $1"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}[FAIL]${NC} $1"; FAIL=$((FAIL+1)); }

echo "=========================================="
echo " CIS HARDENING TOOL - by Angelo"
echo " Edo State - SOC Analyst Portfolio"
echo " Ubuntu CIS Level 1 - 10 Checks"
echo "=========================================="
echo ""

# 1. CIS 1.1.1.1 - cramfs disabled
if modprobe -n -v cramfs 2>&1 | grep -q "install /bin/true\|blacklisted"; then
  pass "1.1.1.1 cramfs filesystem disabled"
else
  fail "1.1.1.1 cramfs NOT disabled - should be blacklisted"
fi

# 2. CIS 3.3.1 - IP forwarding disabled
if [ "$(sysctl -n net.ipv4.ip_forward)" == "0" ]; then
  pass "3.3.1 IP forwarding disabled (net.ipv4.ip_forward=0)"
else
  fail "3.3.1 IP forwarding ENABLED - should be 0"
fi

# 3. CIS 3.3.2 - Send redirects disabled
if [ "$(sysctl -n net.ipv4.conf.all.send_redirects)" == "0" ]; then
  pass "3.3.2 Packet redirects disabled"
else
  fail "3.3.2 Packet redirects ENABLED - should be 0"
fi

# 4. CIS 2.2.1.1 - apache2 not enabled (example service)
if ! systemctl is-enabled apache2 &>/dev/null; then
  pass "2.2.1.1 apache2 service disabled (not needed)"
else
  fail "2.2.1.1 apache2 service ENABLED - disable if not needed"
fi

# 5. CIS 3.5.1.1 - UFW firewall enabled
if systemctl is-enabled ufw &>/dev/null || ufw status | grep -q "active"; then
  pass "3.5.1.1 UFW firewall is active"
else
  fail "3.5.1.1 UFW firewall NOT active"
fi

# 6. CIS 5.2.10 - SSH PermitRootLogin no
if grep -Eq "^PermitRootLogin no" /etc/ssh/sshd_config 2>/dev/null; then
  pass "5.2.10 SSH PermitRootLogin set to no"
else
  fail "5.2.10 SSH PermitRootLogin NOT set to no (CRITICAL)"
fi

# 7. CIS 5.4.1.1 - PASS_MAX_DAYS 365 or less
PASS_MAX=$(grep ^PASS_MAX_DAYS /etc/login.defs | awk '{print $2}')
if [ "$PASS_MAX" -le 365 ] 2>/dev/null; then
  pass "5.4.1.1 PASS_MAX_DAYS = $PASS_MAX (<=365)"
else
  fail "5.4.1.1 PASS_MAX_DAYS = $PASS_MAX - should be <=365"
fi

# 8. CIS 4.1.3.1 - auditd installed
if dpkg -l | grep -q auditd && systemctl is-enabled auditd &>/dev/null; then
  pass "4.1.3.1 auditd installed and enabled"
else
  fail "4.1.3.1 auditd NOT installed/enabled"
fi

# 9. CIS 6.1.2 - /etc/shadow permissions 640
PERM=$(stat -c %a /etc/shadow 2>/dev/null)
if [ "$PERM" == "640" ] || [ "$PERM" == "0" ]; then
  pass "6.1.2 /etc/shadow permissions = $PERM (secure)"
else
  fail "6.1.2 /etc/shadow permissions = $PERM - should be 640"
fi

# 10. CIS 5.4.1.5 - No empty passwords
if ! awk -F: '($2 == "" ) { print }' /etc/shadow | grep -q .; then
  pass "5.4.1.5 No accounts with empty passwords"
else
  fail "5.4.1.5 Found accounts with empty passwords!"
fi

echo ""
echo "=========================================="
echo -e " SCORE: ${GREEN}$PASS PASSED${NC} / ${RED}$FAIL FAILED${NC} out of 10"
echo "=========================================="
if [ $FAIL -eq 0 ]; then
  echo -e "${GREEN}System is CIS Level 1 Compliant!${NC}"
else
  echo -e "${YELLOW}Fix FAILED items to become compliant${NC}"
fi
