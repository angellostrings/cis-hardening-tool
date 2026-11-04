#!/bin/bash
# CIS Hardening Tool - Edo State SOC Analyst Portfolio - by Angelo
echo "=========================================="
echo "CIS HARDENING TOOL v2"
echo "Edo State - SOC Analyst Portfolio - Angelo"
echo "=========================================="

echo "install cramfs /bin/true" | sudo tee /etc/modprobe.d/cramfs.conf > /dev/null
echo "blacklist cramfs" | sudo tee -a /etc/modprobe.d/cramfs.conf > /dev/null
echo "[FIXED] cramfs disabled"

sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN   14/' /etc/login.defs || echo "PASS_MIN_LEN   14" | sudo tee -a /etc/login.defs > /dev/null
echo "[FIXED] Password policies"

sudo sysctl -w net.ipv4.conf.all.send_redirects=0 > /dev/null
sudo sysctl -w net.ipv4.conf.default.send_redirects=0 > /dev/null
sudo sysctl -w net.ipv4.conf.all.send_redirects=0 -p > /dev/null 2>&1 || true
echo "[FIXED] Packet redirects"

sudo apt update -qq && sudo apt install -y ufw openssh-server auditd > /dev/null 2>&1
sudo ufw --force enable > /dev/null 2>&1
echo "[FIXED] UFW enabled"

sudo sed -i 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config || echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config > /dev/null
echo "[FIXED] SSH secured"

sudo chmod 640 /etc/shadow
echo "[FIXED] Shadow permissions"

echo ""
echo "=== HARDENING COMPLETE - EDO STATE SOC ANALYST ==="
