# CIS Hardening Tool - Edo State SOC

**By Angelo | Edo State | 10/10 PASS | Ubuntu 26.04 LTS Ready | WSL Compatible**

A Bash-based CIS Benchmark v2 hardening tool for Ubuntu 24.04 / 26.04 LTS, built for Edo State SOC operations. Achieves **100% CIS compliance** on WSL.

## 🎯 Results

- **CIS v2 - 10/10 PASS - Fully Compliant**
- Tested on Ubuntu 26.04 LTS (WSL)
- Fixed: UFW, SSH, auditd, cramfs, redirects

## 🛡️ What It Hardens

- **Filesystem:** Disables cramfs, freevxfs, jffs2, hfs, hfsplus, udf
- **Services:** Secure SSH (Protocol 2, no root login, idle timeout)
- **Network:** UFW firewall enabled, packet redirects disabled
- **Logging:** auditd enabled and configured
- **Access:** Secures cron, at, and sudoers

## 🚀 Usage

```bash
# Clone
git clone git@github.com:angellostrings/cis-hardening-tool.git
cd cis-hardening-tool

# Make executable
chmod +x cis-harden.sh

# Run hardening (requires sudo)
sudo ./cis-harden.sh

# Verify compliance
sudo ./cis-harden.sh --audit
