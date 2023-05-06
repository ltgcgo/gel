#!/bin/bash
echo "Pre-install..."
rm -rf /etc/apt/preferences
rm -rf /etc/apt/sources.list.d
mkdir /etc/apt/sources.list.d
echo "Installation stage 1..."
apt clean
apt update
dpkg -i openssl_3.0.8-1_amd64.deb
dpkg -i apt-transport-https_2.6.0_all.deb
apt -o Dpkg::Options::=--force-confnew install --fix-broken -y
apt -o Dpkg::Options::=--force-confnew install -y ca-certificates apt-transport-https
echo "Installation stage 2..."
apt update
sed -i "s/http/https/g" $PREFIX/etc/apt/sources.list
apt -o Dpkg::Options::=--force-confnew upgrade -y
echo "Installation stage 3..."
apt -o Dpkg::Options::=--force-confnew install -y init doas gnupg gpgv bash zsh ssh \
	unzip zip bzip2 lzip lziprecover brotli \
	dnsutils net-tools traceroute tcptraceroute psmisc nftables \
	nano tree netcat-openbsd pv curl git screen htop neofetch
echo "Post-install..."
mkdir -p /run/sshd
exit