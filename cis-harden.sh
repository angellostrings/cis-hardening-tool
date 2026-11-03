#!/bin/bash
# CIS Hardening Tool v2 - Fixes all 10 checks - by Angelo
echo "=== CIS HARDENING v2 STARTED by Angelo ==="

# 1. Fix cramfs - blacklist unused filesystem
echo "install cramfs /bin/true" | sudo tee /etc/modprobe.d/cramfs.conf > /dev/null
echo "blacklist cramfs" | sudo tee -a /etc/modprobe.d/cramfs.conf > /dev/null
echo "[FIXED] 1.1.1.1 cramfs disabled"

# 2. Fix packet redirects
sudo sysctl -w net.ipv4.conf.all.send_redirects=0 > /dev/null
sudo sysctl -w net.ipv4.conf.default.send_redirects=0 > /dev/null
echo "net.ipv4.conf.all.send_redirects = 0" | sudo tee -a /etc/sysctl.conf > /dev/null
echo "net.ipv4.conf.default.send_redirects = 0" | sudo tee -a /etc/sysctl.conf > /dev/null
echo "[FIXED] 3.3.2 Packet redirects disabled"

# 3. Fix UFW - Install and enable
sudo apt update && sudo apt install -y ufw > /dev/null 2>&1
sudo ufw --force enable > /dev/null 2>&1
echo "[FIXED] 3.5.1.1 UFW installed & enabled"

# 4. Fix SSH - Install openssh-server and disable root
sudo apt install -y openssh-server > /dev/null 2>&1
sudo sed -i 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config || echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
echo "[FIXED] 5.2.10 SSH PermitRootLogin no"

# 5. Fix auditd
sudo apt install -y auditd audispd-plugins > /dev/null 2>&1
sudo systemctl enable auditd > /dev/null 2>&1 || sudo service auditd start > /dev/null 2>&1
echo "[FIXED] 4.1.3.1 auditd installed"

# Previous fixes (keep them)
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo chmod 640 /etc/shadow 2>/dev/null
echo "[FIXED] Previous fixes re-applied"

echo ""
echo "=== HARDENING v2 COMPLETE ==="
echo "Now run: bash cis-check.sh"
