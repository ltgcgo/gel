#!/bin/bash
echo "Pre-install..."
zypper addrepo https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/ security-x86_64
echo "Installation stage 1..."
zypper --gpg-auto-import-keys in -y ca-certificates
echo "Installation stage 2..."
zypper --gpg-auto-import-keys update -y
echo "Installation stage 3..."
zypper --gpg-auto-import-keys in -y systemd opendoas gpg2 bash zsh openssh-server \
	unzip zip bzip2 lzip lziprecover brotli \
	bind-utils net-tools iputils traceroute psmisc nftables \
	nano tree netcat-openbsd pv curl git screen htop neofetch
echo "Post-install..."
mkdir -p /run/sshd
exit