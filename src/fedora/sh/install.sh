#!/bin/bash
echo "Pre-install..."
rm -f /etc/dnf/protected.d/sudo.conf
dnf remove -y sudo
echo "Installation stage 1..."
dnf install -y ca-certificates
echo "Installation stage 2..."
dnf install -y systemd opendoas gpg bash zsh openssh-server \
	unzip zip bzip2 lzip lziprecover brotli zopfli pigz lbzip2 \
	bind9-next-utils net-tools iputils traceroute tcptraceroute psmisc nftables procps-ng \
	nano tree netcat socat pv curl git screen htop sqlite
echo "Post-install..."
mkdir -p /run/sshd
exit
