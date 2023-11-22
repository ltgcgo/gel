#!/bin/bash
echo "Pre-install..."
zypper addrepo https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/ security-x86_64
echo "Installation stage 1..."
zypper --gpg-auto-import-keys in -y ca-certificates
echo "Installation stage 2..."
zypper --gpg-auto-import-keys update -y
echo "Installation stage 3..."
zypper --gpg-auto-import-keys in -y systemd opendoas bash zsh openssh-server \
	unzip zip tar bzip2 brotli xz \
	bind-utils net-tools psmisc \
	nano tree netcat-openbsd pv curl
echo "Post-install..."
mkdir -p /run/sshd
systemctl enable sshd
exit
