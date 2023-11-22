#!/bin/bash
echo "Pre-install..."
zypper addrepo https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/ security-x86_64
echo "Installation stage 1..."
zypper --gpg-auto-import-keys in -y ca-certificates
echo "Installation stage 2..."
zypper --gpg-auto-import-keys update -y
echo "Installation stage 3..."
zypper --gpg-auto-import-keys in -y systemd opendoas gpg2 bash zsh openssh-server \
	unzip zip tar bzip2 brotli xz \
	bind-utils net-tools iputils traceroute psmisc nftables \
	nano tree netcat-openbsd socat pv curl git screen htop
echo "Post-install..."
mkdir -p /run/sshd
systemctl enable sshd
exit
