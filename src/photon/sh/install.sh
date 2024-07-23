#!/bin/bash
echo "Pre-install..."
rm -f /etc/dnf/protected.d/sudo.conf
dnf remove -y sudo
echo "Installation stage 1..."
dnf install -y ca-certificates
echo "Installation stage 2..."
dnf install -y bash zsh openssh-server shadow \
	unzip zip \
	net-tools iputils psmisc nftables procps-ng dnsmasq \
	nano tree netcat sqlite
echo "Installation stage 3..."
#dnf install -y libstdc++
#bash raw.sh bind9-next-license-9.19.11.rpm
#bash raw.sh bind9-next-libs-9.19.11.rpm
#bash raw.sh bind9-next-utils-9.19.11.rpm
#bash raw.sh lziprecover-1.23-3.rpm
#bash raw.sh opendoas-6.8.2.rpm
echo "Removing unnecessary files..."
rm -fv /lib/systemd/system/anaconda.target.wants/*
echo "Post-install..."
mkdir -p /run/sshd
exit
