#!/bin/bash
echo "Pre-install..."
rm -f /etc/dnf/protected.d/sudo.conf
dnf remove -y sudo
echo "Installation stage 1..."
dnf install -y ca-certificates
echo "Installation stage 2..."
dnf install -y systemd gpg bash zsh openssh-server shadow-utils \
	unzip zip tar bzip2 lzip brotli zopfli pigz lbzip2 xz \
	net-tools iputils traceroute tcptraceroute psmisc iptables-nft procps-ng \
	nano tree netcat socat pv git screen htop sqlite
echo "Installation stage 3..."
dnf install -y libstdc++
bash raw.sh opendoas-6.8.2.rpm
echo "Removing unnecessary files..."
rm -fv /lib/systemd/system/anaconda.target.wants/*
echo "Post-install..."
mkdir -p /run/sshd
exit
