#!/bin/bash
echo "Pre-install..."
zypper addrepo -y https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/ security-x86_64
echo "Installation stage 1..."
zypper in -y ca-certificates
echo "Installation stage 2..."
zypper update -y
echo "Installation stage 3..."
zypper in -y systemd opendoas gpg2 bash zsh openssh-server \
	unzip zip bzip2 lzip lziprecover brotli \
	bind-utils net-tools iputils traceroute psmisc \
	nano tree netcat-openbsd pv curl git screen htop neofetch
echo "Post-install..."
mkdir -p /run/sshd
exit