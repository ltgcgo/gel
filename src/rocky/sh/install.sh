#!/bin/bash
echo "Pre-install..."
rm -f /etc/dnf/protected.d/sudo.conf
dnf remove -y sudo
echo "Installation stage 1..."
dnf install -y ca-certificates
echo "Installation stage 2..."
dnf install -y systemd gpg bash zsh openssh-server \
	unzip zip bzip2 lzip brotli zopfli pigz lbzip2 \
	net-tools iputils traceroute tcptraceroute psmisc nftables \
	nano tree netcat socat pv git screen htop neofetch
echo "Installation stage 3..."
dnf install -y libstdc++
#bash raw.sh bind9-next-license-9.19.11.rpm
#bash raw.sh bind9-next-libs-9.19.11.rpm
#bash raw.sh bind9-next-utils-9.19.11.rpm
#bash raw.sh lziprecover-1.23-3.rpm
bash raw.sh opendoas-6.8.2.rpm
echo "Post-install..."
mkdir -p /run/sshd
exit
